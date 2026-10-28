
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projecthub.entity.User" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> following = (List<User>) request.getAttribute("following");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Following - ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 20px;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        h1 {
            margin: 0;
            color: #1e3a8a;
        }

        .back-link {
            text-decoration: none;
            color: #2563eb;
            font-weight: bold;
        }

        .card {
            background: white;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.06);
        }

        .developer-name {
            color: #1d4ed8;
            font-size: 18px;
            font-weight: bold;
            text-decoration: none;
        }

        .developer-name:hover {
            text-decoration: underline;
        }

        .email {
            color: #6b7280;
            margin: 8px 0 0;
            overflow-wrap: anywhere;
        }

        .empty-state {
            background: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            color: #6b7280;
        }
    </style>
</head>

<body>
<div class="container">

    <div class="header">
        <h1>🤝 Developers I Follow</h1>
        <a class="back-link"
           href="<%= request.getContextPath() %>/dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <% if (following == null || following.isEmpty()) { %>

    <div class="empty-state">
        <h2>You aren't following anyone yet.</h2>
        <p>Visit the dashboard and follow developers to see them here.</p>
    </div>

    <% } else { %>

    <% for (User developer : following) { %>

    <div class="card">
        <a class="developer-name"
           href="<%= request.getContextPath() %>/public-profile?id=<%= developer.getId() %>">
            <%= developer.getName() %>
        </a>

        <p class="email">
            <%= developer.getEmail() == null ? "" : developer.getEmail() %>
        </p>
    </div>

    <% } %>

    <% } %>

</div>
</body>
</html>
