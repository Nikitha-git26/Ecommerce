<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.CartItem" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="com.fashionstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="navbar">
    <div class="brand"><a href="${pageContext.request.contextPath}/home">FashionStore</a></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Shop</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Checkout</h1>
    <div class="checkout-grid">
        <div class="checkout-form">
            <form action="${pageContext.request.contextPath}/placeorder" method="post" class="form-card">
                <h2>Delivery Information</h2>
                <label>Name</label>
                <input type="text" value="<%= ((User) request.getAttribute("user")).getName() %>" disabled>
                <label>Address</label>
                <textarea name="address" required></textarea>
                <label>Payment Method</label>
                <select name="paymentMethod" required>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Cash on Delivery">Cash on Delivery</option>
                </select>
                <button type="submit">Place Order</button>
            </form>
            <div class="message"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></div>
        </div>
        <div class="checkout-summary">
            <h2>Order Summary</h2>
            <%
                List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
                double total = request.getAttribute("total") != null ? (double) request.getAttribute("total") : 0.0;
            %>
            <ul class="summary-list">
                <%
                    if (cartItems != null) {
                        for (int i = 0; i < cartItems.size(); i++) {
                            CartItem item = cartItems.get(i);
                            Product product = cartProducts.size() > i ? cartProducts.get(i) : null;
                            if (product == null) continue;
                %>
                <li>
                    <strong><%= product.getName() %></strong> x <%= item.getQuantity() %><br>
                    Size: <%= item.getSize() %> | Rs. <%= String.format("%,.0f", product.getPrice() * item.getQuantity()) %>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <div class="summary">
                <div class="summary-text">Total:</div>
                <div class="summary-value">Rs. <%= String.format("%,.0f", total) %></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
