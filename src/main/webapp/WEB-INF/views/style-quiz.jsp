<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="com.fashionstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Style Finder - FashionStore</title>
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
        <% } %>
    </div>
</div>

<main class="container">
    <section class="quiz-hero">
        <p class="eyebrow">Personalized shopping</p>
        <h1>Style Finder</h1>
        <p>Pick who you are shopping for, choose a vibe, set your budget, and FashionStore will shortlist pieces for you.</p>
    </section>

    <form action="${pageContext.request.contextPath}/style-quiz" method="post" class="quiz-form">
        <label>
            Shopping for
            <select name="category" required>
                <option value="Men">Men</option>
                <option value="Women">Women</option>
                <option value="Kids">Kids</option>
            </select>
        </label>
        <label>
            Vibe
            <select name="vibe" required>
                <option value="Everyday">Everyday clean</option>
                <option value="Statement">Statement look</option>
                <option value="Comfort">Comfort first</option>
            </select>
        </label>
        <label>
            Max budget
            <select name="budget" required>
                <option value="1500">Rs. 1,500</option>
                <option value="3000">Rs. 3,000</option>
                <option value="5000">Rs. 5,000</option>
            </select>
        </label>
        <button type="submit">Find My Picks</button>
    </form>

    <%
        List<Product> recommendations = (List<Product>) request.getAttribute("recommendations");
        if (recommendations != null) {
    %>
    <section class="section-head quiz-results-head">
        <p class="eyebrow">Your picks</p>
        <h2><%= recommendations.isEmpty() ? "No exact matches yet" : "Recommended for your vibe" %></h2>
    </section>
    <div class="product-grid">
        <% if (!recommendations.isEmpty()) {
            for (Product product : recommendations) {
        %>
        <article class="product-card">
            <a class="product-image-link" href="${pageContext.request.contextPath}/products?id=<%= product.getId() %>">
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
            </a>
            <div class="product-info">
                <span class="pill"><%= product.getCategory() %></span>
                <h3><%= product.getName() %></h3>
                <p><%= product.getDescription() %></p>
                <div class="product-footer">
                    <span class="price">Rs. <%= String.format("%,.0f", product.getPrice()) %></span>
                    <a class="mini-link" href="${pageContext.request.contextPath}/products?id=<%= product.getId() %>">View</a>
                </div>
            </div>
        </article>
        <% }} else { %>
        <p class="no-products">Try increasing your budget or choosing another category.</p>
        <% } %>
    </div>
    <% } %>
</main>
</body>
</html>
