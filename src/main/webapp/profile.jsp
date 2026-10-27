m<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projecthub.entity.User" %>

<%
    User profileUser = (User) request.getAttribute("profileUser");

    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }

    String contextPath = request.getContextPath();
    boolean updated = "true".equals(request.getParameter("updated"));

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f5f9;
            color: #222;
        }

        header {
            background: #172554;
            color: white;
            padding: 18px 8%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 18px;
        }

        .container {
            max-width: 650px;
            margin: 45px auto;
            padding: 0 18px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 5px 22px rgba(0, 0, 0, 0.07);
        }

        h1 {
            margin-top: 0;
            color: #172554;
        }

        .subtitle {
            color: #666;
            margin-bottom: 25px;
        }

        label {
            display: block;
            font-weight: bold;
            margin: 18px 0 7px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccd2dd;
            border-radius: 7px;
            font: inherit;
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        input:focus, textarea:focus {
            outline: 2px solid #93c5fd;
            border-color: #2563eb;
        }

        button {
            margin-top: 24px;
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .message {
            padding: 12px;
            border-radius: 7px;
            margin-bottom: 18px;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #2563eb;
            text-decoration: none;
        }

        @media (max-width: 500px) {
            header {
                padding: 16px;
            }

            .card {
                padding: 22px;
            }

            .container {
                margin-top: 25px;
            }
        }
    </style>
</head>

<body>

<header>
    <h2>ProjectHub</h2>

    <nav>
        <a href="<%= contextPath %>/dashboard.jsp">Dashboard</a>
        <a href="<%= contextPath %>/logout">Logout</a>
    </nav>
</header>

<main class="container">
    <section class="card">

        <h1>My Developer Profile</h1>
        <p class="subtitle">
            Update your information and let other developers know you.
        </p>

        <% if (updated) { %>
        <div class="message success">
            Profile updated successfully!
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="message error">
            <%= error %>
        </div>
        <% } %>

        <form action="<%= contextPath %>/profile" method="post">

            <label for="name">Full Name *</label>
            <input
                    type="text"
                    id="name"
                    name="name"
                    maxlength="100"
                    value="<%= escapeHtml(profileUser.getName()) %>"
                    required
            >

            <label for="bio">Bio</label>
            <textarea
                    id="bio"
                    name="bio"
                    maxlength="1000"
                    placeholder="Tell us about yourself..."
            ><%= escapeHtml(profileUser.getBio()) %></textarea>

            <label for="githubUrl">GitHub Profile URL</label>
            <input
                    type="url"
                    id="githubUrl"
                    name="githubUrl"
                    maxlength="255"
                    placeholder="https://github.com/yourusername"
                    value="<%= escapeHtml(profileUser.getGithubUrl()) %>"
            >

            <label for="linkedinUrl">LinkedIn Profile URL</label>
            <input
                    type="url"
                    id="linkedinUrl"
                    name="linkedinUrl"
                    maxlength="255"
                    placeholder="https://www.linkedin.com/in/yourusername"
                    value="<%= escapeHtml(profileUser.getLinkedinUrl()) %>"
            >

            <button type="submit">Save Profile</button>

        </form>

        <a class="back-link"
           href="<%= contextPath %>/dashboard.jsp">
            ← Back to Dashboard
        </a>

    </section>
</main>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>

</body>
</html>
