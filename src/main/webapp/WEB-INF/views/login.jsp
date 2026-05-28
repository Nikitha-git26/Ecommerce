<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="login-body">
<div class="login-shell">
    <div class="login-panel">
    <p class="eyebrow">Member access</p>
    <h1>Step into your style room.</h1>
    <p class="login-copy">Sign in to add products to cart, checkout, and keep the shopping flow moving.</p>
    <form action="${pageContext.request.contextPath}/login" method="post" class="form-card">
        <label>Email</label>
        <input type="email" name="email" required>
        <label>Password</label>
        <input type="password" name="password" required>
        <button type="submit">Log In</button>
    </form>
    <div class="message">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Please sign in to continue." %>
    </div>
    <a class="mini-link" href="${pageContext.request.contextPath}/register">Create a new account</a>
    <a class="mini-link" href="${pageContext.request.contextPath}/home">Back to home</a>
    </div>
</div>
</body>
</html>
