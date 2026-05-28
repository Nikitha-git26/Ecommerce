package com.fashionstore.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/fashion_store?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASSWORD = "root";

    private static final String H2_URL = "jdbc:h2:~/fashion_store;DB_CLOSE_DELAY=-1;MODE=MySQL;DATABASE_TO_UPPER=true;AUTO_SERVER=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASSWORD = "";

    private static volatile boolean h2Initialized = false;

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
        } catch (Exception mysqlException) {
            System.out.println("DBConnection: MySQL connection failed, falling back to H2. Error: " + mysqlException.getMessage());
            try {
                Class.forName("org.h2.Driver");
                System.out.println("DBConnection: Connecting to H2 using URL " + H2_URL);
                Connection connection = DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD);
                initializeH2Schema(connection);
                return connection;
            } catch (Exception h2Exception) {
                System.err.println("DBConnection: H2 fallback failed: " + h2Exception.getMessage());
                RuntimeException runtimeException = new RuntimeException("Unable to connect to database using MySQL and H2 fallback.", h2Exception);
                runtimeException.addSuppressed(mysqlException);
                throw runtimeException;
            }
        }
    }

    private static void initializeH2Schema(Connection connection) throws Exception {
        if (h2Initialized) {
            return;
        }

        synchronized (DBConnection.class) {
            if (h2Initialized) {
                return;
            }

            try (Statement cleanupStatement = connection.createStatement()) {
                try {
                    cleanupStatement.execute("DROP ALL OBJECTS");
                } catch (SQLException cleanupException) {
                    System.out.println("DBConnection: H2 cleanup before schema init failed: " + cleanupException.getMessage());
                }
            }

            try (InputStream stream = DBConnection.class.getClassLoader().getResourceAsStream("schema.sql")) {
                if (stream == null) {
                    throw new SQLException("schema.sql resource not found in classpath");
                }

                try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
                    StringBuilder sqlBuilder = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String trimmed = line.trim();
                        if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.toUpperCase().startsWith("CREATE DATABASE") || trimmed.toUpperCase().startsWith("USE ")) {
                            continue;
                        }
                        sqlBuilder.append(line).append("\n");
                    }

                    String[] statements = sqlBuilder.toString().split(";\\s*");
                    try (Statement statement = connection.createStatement()) {
                        for (String rawStatement : statements) {
                            String sql = rawStatement.trim();
                            if (sql.isEmpty()) {
                                continue;
                            }
                            if (sql.endsWith(";")) {
                                sql = sql.substring(0, sql.length() - 1).trim();
                            }
                            try {
                                statement.execute(sql);
                            } catch (SQLException sqlException) {
                                if (shouldIgnoreH2InitializationError(sqlException, sql)) {
                                    System.out.println("DBConnection: Ignoring H2 init error for statement: " + sql + " - " + sqlException.getMessage());
                                } else {
                                    throw sqlException;
                                }
                            }
                        }
                    }
                }
            }

            h2Initialized = true;
        }
    }

    private static boolean shouldIgnoreH2InitializationError(SQLException exception, String sql) {
        String trimmed = sql.trim().toUpperCase();
        if (trimmed.startsWith("INSERT")) {
            String sqlState = exception.getSQLState();
            if ("23505".equals(sqlState) || exception.getMessage().toUpperCase().contains("UNIQUE INDEX") || exception.getMessage().toUpperCase().contains("PRIMARY KEY")) {
                return true;
            }
        }
        return false;
    }
}
