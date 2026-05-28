<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="com.fashionstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FashionStore - Style That Moves</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
%>
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
    <section class="hero-panel">
        <div class="hero-copy">
            <p class="eyebrow">New season edit</p>
            <h1>Street-ready fits with a little runway electricity.</h1>
            <p>Curated Indian pricing, crisp essentials, playful kidswear, and polished layers for everyday plans that accidentally become photo-worthy.</p>
            <div class="hero-actions">
                <a class="button" href="${pageContext.request.contextPath}/products">Shop collection</a>
                <a class="button button-ghost" href="${pageContext.request.contextPath}/style-quiz">Try Style Finder</a>
            </div>
        </div>
        <div class="hero-visual">
            <div class="style-card card-one">Festive neutrals</div>
            <div class="style-card card-two">Campus classics</div>
            <div class="style-card card-three">Weekend layers</div>
        </div>
    </section>

    <section class="category-showcase">
        <a href="${pageContext.request.contextPath}/products?category=Men" class="category-tile men">
            <span>Men</span>
            <strong>Clean cuts, fresh sneakers</strong>
        </a>
        <a href="${pageContext.request.contextPath}/products?category=Women" class="category-tile women">
            <span>Women</span>
            <strong>Dresses, jackets, statement color</strong>
        </a>
        <a href="${pageContext.request.contextPath}/products?category=Kids" class="category-tile kids">
            <span>Kids</span>
            <strong>Soft, bright, chaos-approved</strong>
        </a>
    </section>

    <section class="section-head">
        <p class="eyebrow">Featured drops</p>
        <h2>Picked for your first cart</h2>
    </section>

    <div class="product-grid">
        <% if (featuredProducts != null) {
            for (Product product : featuredProducts) {
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
        <% }} %>
    </div>
</main>
</body>
</html>
