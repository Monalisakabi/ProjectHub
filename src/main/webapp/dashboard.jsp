<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null) {
    userName = "User";
    }

    String safeUserName = userName
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace("\"", "&quot;")
    .replace("'", "&#39;");


%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            color: #1f2937;
        }

        header {
            background: #ffffff;
            padding: 18px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            color: #2563eb;
        }

        .logout {
            background: #2563eb;
            color: white;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 6px;
        }

        main {
            max-width: 1050px;
            margin: 45px auto;
            padding: 0 20px;
        }

        .welcome {
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .welcome h1 {
            margin-top: 0;
            color: #2563eb;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
        }

        .card h2 {
            margin-top: 0;
            font-size: 19px;
        }

        .card p {
            color: #6b7280;
            line-height: 1.5;
        }

        .status {
            display: inline-block;
            margin-top: 8px;
            background: #dcfce7;
            color: #166534;
            padding: 6px 10px;
            border-radius: 5px;
            font-size: 13px;
        }

        @media (max-width: 480px) {
            header {
                padding: 15px 5%;
            }

            .logo {
                font-size: 21px;
            }

            .welcome {
                padding: 25px;
            }
        }
    </style>


</head>

<body>

<header>
    <div class="logo">ProjectHub</div>

    <a class="logout"
       href="<%= request.getContextPath() %>/logout">
        Log Out
    </a>


</header>

<main>
    <section class="welcome">
        <h1>Welcome, <%= safeUserName %>! 👋</h1>


        <p>
            Welcome to ProjectHub — your space to build projects,
            collaborate with others, and showcase your skills.
        </p>

        <span class="status">Login successful</span>
    </section>

    <section class="cards">
        <div class="card">
            <h2>👤 My Profile</h2>
            <p>Manage your personal information, skills, and social links.</p>
        </div>

        <div class="card">
            <h2>💻 Projects</h2>
            <p>Create projects, showcase your work, and discover new ideas.</p>
        </div>

        <div class="card">
            <h2>🤝 Collaboration</h2>
            <p>Connect with other developers and collaborate on projects.</p>
        </div>
    </section>


</main>

</body>
</html>
