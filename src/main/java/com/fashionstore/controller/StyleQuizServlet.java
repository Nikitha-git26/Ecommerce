package com.fashionstore.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/style-quiz")
public class StyleQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/style-quiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String vibe = request.getParameter("vibe");
        double budget = parseBudget(request.getParameter("budget"));

        List<Product> source = category == null || category.isBlank()
                ? productDAO.getAllProducts()
                : productDAO.getProductsByCategory(category);
        List<Product> recommendations = new ArrayList<>();

        for (Product product : source) {
            if (product.getPrice() <= budget) {
                recommendations.add(product);
            }
        }

        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedVibe", vibe);
        request.setAttribute("selectedBudget", budget);
        request.setAttribute("recommendations", recommendations);
        request.getRequestDispatcher("/WEB-INF/views/style-quiz.jsp").forward(request, response);
    }

    private double parseBudget(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 5000.0;
        }
    }
}
