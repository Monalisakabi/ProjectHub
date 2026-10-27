<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            color: #1f2937;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .register-container {
            width: 100%;
            max-width: 430px;
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        h1 {
            text-align: center;
            margin-bottom: 8px;
            color: #2563eb;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #2563eb;
        }

        button {
            width: 100%;
            padding: 13px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .message {
            padding: 12px;
            margin-bottom: 18px;
            border-radius: 6px;
            text-align: center;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .login-link a {
            color: #2563eb;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="register-container">

    <h1>ProjectHub</h1>

    <p class="subtitle">Create your account and start collaborating.</p>

    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="message success">
        Registration successful! You can now log in.
    </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="message error">
        Please check your details and try again.
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="post">

        <label for="name">Full Name</label>
        <input
                type="text"
                id="name"
                name="name"
                maxlength="100"
                autocomplete="name"
                required
        >

        <label for="email">Email Address</label>
        <input
                type="email"
                id="email"
                name="email"
                maxlength="150"
                autocomplete="email"
                required
        >

        <label for="password">Password</label>
        <input
                type="password"
                id="password"
                name="password"
                minlength="8"
                autocomplete="new-password"
                required
        >

        <button type="submit">Create Account</button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login.jsp">Log in</a>
    </div>

</div>

</body>
</html>