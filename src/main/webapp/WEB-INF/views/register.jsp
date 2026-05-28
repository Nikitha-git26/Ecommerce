<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="login-body">
<div class="login-shell register-shell">
    <div class="login-panel">
        <p class="eyebrow">New here?</p>
        <h1>Create your own FashionStore login.</h1>
        <p class="login-copy">Use any email and password you want. After signup, you will be signed in automatically.</p>
        <form action="${pageContext.request.contextPath}/register" method="post" class="form-card">
            <label>Name</label>
            <input type="text" name="name" required>
            <label>Email</label>
            <input type="email" name="email" required>
            <label>Password</label>
            <input type="password" name="password" minlength="4" required>
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" minlength="4" required>
            <button type="submit">Create Account</button>
        </form>
        <div class="message">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Already registered? Login from the link below." %>
        </div>
        <a class="mini-link" href="${pageContext.request.contextPath}/login">Back to login</a>
    </div>
</div>
</body>
</html>
