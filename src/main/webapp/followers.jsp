<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projecthub.entity.User" %>

<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }


    List<User> followers =
    (List<User>) request.getAttribute("followers");


%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Followers | ProjectHub</title>


    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            margin: 0;
            padding: 30px;
            color: #243247;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin-top: 0;
            color: #243b63;
        }

        .user-card {
            padding: 16px;
            margin: 12px 0;
            background: #f7f9fc;
            border: 1px solid #e3e9f2;
            border-radius: 8px;
        }

        .user-name {
            color: #2458a6;
            font-weight: bold;
            text-decoration: none;
        }

        .user-name:hover {
            text-decoration: underline;
        }

        .empty-message {
            color: #68778b;
            padding: 20px 0;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #2458a6;
            text-decoration: none;
        }
    </style>


</head>

<body>
<div class="container">


    <h1>My Followers</h1>

    <% if (followers == null || followers.isEmpty()) { %>

    <p class="empty-message">
        You don't have any followers yet.
    </p>

    <% } else { %>

    <p>
        <strong><%= followers.size() %></strong>
        follower(s)
    </p>

    <% for (User follower : followers) { %>

    <div class="user-card">
        <a class="user-name"
           href="<%= request.getContextPath() %>/public-profile?id=<%= follower.getId() %>">
            <%= follower.getName() %>
        </a>
    </div>

    <% } %>

    <% } %>

    <a class="back-link"
       href="<%= request.getContextPath() %>/dashboard.jsp">
        &larr; Back to Dashboard
    </a>


</div>
</body>
</html>
