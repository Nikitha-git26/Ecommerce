<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="com.fashionstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Detail - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<% User currentUser = (User) session.getAttribute("loggedInUser"); %>
<div class="navbar">
    <div class="brand"><a href="${pageContext.request.contextPath}/home">FashionStore</a></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Shop</a>
        <a href="${pageContext.request.contextPath}/style-quiz">Style Finder</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <% if (currentUser != null) { %>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/login">Login</a>
        <a href="${pageContext.request.contextPath}/register">Sign Up</a>
        <% } %>
    </div>
</div>
<main class="container">
    <%
        Product product = (Product) request.getAttribute("product");
        if (product != null) {
    %>
    <div class="detail-card">
        <div class="detail-image-wrap">
            <img class="detail-image" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
        </div>
        <div class="detail-info">
            <a class="breadcrumb" href="${pageContext.request.contextPath}/products">Shop / <%= product.getCategory() %></a>
            <span class="pill"><%= product.getCategory() %></span>
            <h1><%= product.getName() %></h1>
            <p class="detail-price">Rs. <%= String.format("%,.0f", product.getPrice()) %></p>
            <p class="detail-description"><%= product.getDescription() != null ? product.getDescription() : "No description available." %></p>
            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="add-cart-form">
                <input type="hidden" name="productId" value="<%= product.getId() %>">
                <label for="size">Choose your size</label>
                <select name="size" id="size" required>
                    <%
                        java.util.List<String> sizes = (java.util.List<String>) request.getAttribute("sizes");
                        for (String size : sizes) {
                    %>
                    <option value="<%= size %>"><%= size %></option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">Add to Cart</button>
            </form>
        </div>
    </div>
    <%
        } else {
    %>
    <p>Product not found.</p>
    <%
        }
    %>
</main>
</body>
</html>
