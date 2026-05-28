<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.CartItem" %>
<%@ page import="com.fashionstore.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="navbar">
    <div class="brand"><a href="${pageContext.request.contextPath}/home">FashionStore</a></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products">Shop</a>
        <a href="${pageContext.request.contextPath}/checkout">Checkout</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Your Cart</h1>
    <%
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
        double total = request.getAttribute("total") != null ? (double) request.getAttribute("total") : 0.0;
    %>
    <%
        if (cartItems != null && !cartItems.isEmpty()) {
    %>
    <table class="cart-table">
        <tr>
            <th>Product</th>
            <th>Size</th>
            <th>Quantity</th>
            <th>Price</th>
            <th></th>
        </tr>
        <%
            for (int i = 0; i < cartItems.size(); i++) {
                CartItem item = cartItems.get(i);
                Product product = cartProducts.size() > i ? cartProducts.get(i) : null;
                if (product == null) continue;
        %>
        <tr>
            <td><%= product.getName() %></td>
            <td><%= item.getSize() %></td>
            <td>
                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="inline-form">
                    <input type="hidden" name="cartItemId" value="<%= item.getId() %>">
                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1">
                    <button type="submit">Update</button>
                </form>
            </td>
            <td>Rs. <%= String.format("%,.0f", product.getPrice() * item.getQuantity()) %></td>
            <td>
                <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                    <input type="hidden" name="cartItemId" value="<%= item.getId() %>">
                    <button type="submit" class="link-button">Remove</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <div class="summary">
        <div class="summary-text">Total:</div>
        <div class="summary-value">Rs. <%= String.format("%,.0f", total) %></div>
    </div>
    <div class="actions">
        <a class="button" href="${pageContext.request.contextPath}/checkout">Continue to Checkout</a>
        <a class="button button-secondary" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
    </div>
    <%
        } else {
    %>
    <p>Your cart is empty.</p>
    <a class="button" href="${pageContext.request.contextPath}/products">Browse Products</a>
    <%
        }
    %>
</div>
</body>
</html>
