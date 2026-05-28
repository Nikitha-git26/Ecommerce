<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="com.fashionstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<% User currentUser = (User) session.getAttribute("loggedInUser"); %>
<%
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedSort = (String) request.getAttribute("selectedSort");
    String categoryParam = selectedCategory != null && !"All".equals(selectedCategory) ? "&category=" + selectedCategory : "";
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
    <section class="shop-header">
        <p class="eyebrow">Shop the edit</p>
        <h1>Color, comfort, and cart-worthy pieces.</h1>
        <p>Browse by mood, size, and plan. Prices are now shown in Indian rupees.</p>
    </section>
    <div class="shop-controls">
        <div class="category-filter">
            <a href="${pageContext.request.contextPath}/products?sort=<%= selectedSort %>" class="filter <%= "All".equals(selectedCategory) ? "active" : "" %>">All</a>
            <a href="${pageContext.request.contextPath}/products?category=Men&sort=<%= selectedSort %>" class="filter <%= "Men".equals(selectedCategory) ? "active" : "" %>">Men</a>
            <a href="${pageContext.request.contextPath}/products?category=Women&sort=<%= selectedSort %>" class="filter <%= "Women".equals(selectedCategory) ? "active" : "" %>">Women</a>
            <a href="${pageContext.request.contextPath}/products?category=Kids&sort=<%= selectedSort %>" class="filter <%= "Kids".equals(selectedCategory) ? "active" : "" %>">Kids</a>
        </div>
        <form class="sort-form" action="${pageContext.request.contextPath}/products" method="get">
            <% if (selectedCategory != null && !"All".equals(selectedCategory)) { %>
            <input type="hidden" name="category" value="<%= selectedCategory %>">
            <% } %>
            <label for="sort">Sort by</label>
            <select id="sort" name="sort" onchange="this.form.submit()">
                <option value="newest" <%= "newest".equals(selectedSort) ? "selected" : "" %>>Newest first</option>
                <option value="priceLow" <%= "priceLow".equals(selectedSort) ? "selected" : "" %>>Price: Low to High</option>
                <option value="priceHigh" <%= "priceHigh".equals(selectedSort) ? "selected" : "" %>>Price: High to Low</option>
                <option value="name" <%= "name".equals(selectedSort) ? "selected" : "" %>>Name A-Z</option>
            </select>
        </form>
    </div>
    <div class="product-grid">
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products != null && !products.isEmpty()) {
                for (Product product : products) {
        %>
        <article class="product-card">
            <a class="product-image-link" href="${pageContext.request.contextPath}/products?id=<%= product.getId() %>">
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
            </a>
            <div class="product-info">
                <span class="pill"><%= product.getCategory() %></span>
                <h3><%= product.getName() %></h3>
                <p><%= product.getDescription() != null ? product.getDescription() : "No description." %></p>
                <div class="product-footer">
                    <span class="price">Rs. <%= String.format("%,.0f", product.getPrice()) %></span>
                    <a class="mini-link" href="${pageContext.request.contextPath}/products?id=<%= product.getId() %>">View item</a>
                </div>
            </div>
        </article>
        <%
                }
            } else {
        %>
        <p class="no-products">No products found.</p>
        <%
            }
        %>
    </div>
    <div class="message">
        <%= request.getParameter("orderSuccess") != null ? "Your order was placed successfully!" : "" %>
    </div>
</main>
</body>
</html>
