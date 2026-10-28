<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.projecthub.entity.User" %>
<%@ page import="com.projecthub.service.FollowService" %>

<%
    // Check whether the user is logged in
    Object sessionUserId = session.getAttribute("userId");

    if (!(sessionUserId instanceof Number)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Long currentUserId = ((Number) sessionUserId).longValue();

    // Get the developers currently followed by this user
    FollowService followService = new FollowService();
    Set<Long> followingUserIds =
            followService.getFollowingUserIds(currentUserId);

    // Get search data from the servlet
    String searchName = (String) request.getAttribute("searchName");
    List<User> searchResults =
            (List<User>) request.getAttribute("searchResults");

    if (searchName == null) {
        searchName = "";
    }

    if (searchResults == null) {
        searchResults = java.util.Collections.emptyList();
    }
%>

<%!
    // Escape HTML to prevent user-provided text from being rendered as HTML
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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Search Developers | ProjectHub</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            background: linear-gradient(
                    135deg,
                    #667eea 0%,
                    #764ba2 50%,
                    #f093fb 100%
            );
            color: #2d2d44;
        }

        .navbar {
            width: 100%;
            padding: 18px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: 0 4px 20px rgba(35, 25, 80, 0.12);
        }

        .logo {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #6c42c1;
        }

        .nav-links {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .nav-links a {
            text-decoration: none;
            color: #51466e;
            font-weight: 600;
            padding: 10px 16px;
            border-radius: 10px;
            transition: 0.25s ease;
        }

        .nav-links a:hover {
            background: #f0eaff;
            color: #7145c6;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 45px auto;
        }

        .page-header {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 36px;
            margin-bottom: 10px;
            text-shadow: 0 3px 12px rgba(40, 20, 80, 0.2);
        }

        .page-header p {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.92);
        }

        .search-card {
            max-width: 760px;
            margin: 0 auto 35px;
            padding: 25px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(35, 20, 80, 0.18);
        }

        .search-form {
            display: flex;
            gap: 12px;
        }

        .search-form input {
            flex: 1;
            min-width: 0;
            padding: 15px 18px;
            border: 2px solid #e4dcf8;
            border-radius: 12px;
            font-size: 15px;
            outline: none;
            transition: 0.25s ease;
        }

        .search-form input:focus {
            border-color: #805ad5;
            box-shadow: 0 0 0 4px rgba(128, 90, 213, 0.12);
        }

        .search-btn {
            border: none;
            padding: 14px 24px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.25s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 18px rgba(102, 72, 180, 0.3);
        }

        .results-heading {
            color: white;
            font-size: 23px;
            margin-bottom: 20px;
        }

        .developer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 22px;
        }

        .developer-card {
            background: rgba(255, 255, 255, 0.98);
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(35, 20, 80, 0.15);
            text-align: center;
            transition: transform 0.25s ease,
            box-shadow 0.25s ease;
        }

        .developer-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 35px rgba(35, 20, 80, 0.23);
        }

        .avatar {
            width: 75px;
            height: 75px;
            margin: 0 auto 15px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea, #c471ed);
            color: white;
            font-size: 30px;
            font-weight: 800;
            box-shadow: 0 6px 15px rgba(102, 72, 180, 0.25);
        }

        .developer-card h3 {
            font-size: 20px;
            margin-bottom: 8px;
            overflow-wrap: anywhere;
        }

        .developer-name {
            text-decoration: none;
            color: #6542b5;
            transition: color 0.2s ease;
        }

        .developer-name:hover {
            color: #d04fa0;
            text-decoration: underline;
        }

        .developer-card p {
            color: #77718a;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .card-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: stretch;
        }

        .profile-btn,
        .follow-btn,
        .unfollow-btn {
            display: inline-block;
            width: 100%;
            padding: 11px 16px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: 0.25s ease;
        }

        .profile-btn {
            color: #6c42c1;
            background: #f0eaff;
        }

        .profile-btn:hover {
            background: #e4d8ff;
        }

        .follow-btn {
            color: white;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .follow-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(102, 72, 180, 0.25);
        }

        .unfollow-btn {
            color: #d14363;
            background: #fff0f3;
            border: 1px solid #ffd1db;
        }

        .unfollow-btn:hover {
            background: #ffe0e7;
        }

        .follow-form {
            width: 100%;
            margin: 0;
        }

        .empty-state {
            background: rgba(255, 255, 255, 0.97);
            padding: 40px 25px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(35, 20, 80, 0.15);
        }

        .empty-state h3 {
            color: #6542b5;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #77718a;
            line-height: 1.6;
        }

        .back-link {
            display: inline-block;
            margin-top: 22px;
            text-decoration: none;
            color: #6c42c1;
            font-weight: 700;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .navbar {
                padding: 16px 5%;
            }

            .logo {
                font-size: 23px;
            }

            .nav-links {
                gap: 5px;
            }

            .nav-links a {
                padding: 8px 10px;
                font-size: 13px;
            }

            .container {
                width: 92%;
                margin: 30px auto;
            }

            .page-header h1 {
                font-size: 29px;
            }

            .search-card {
                padding: 18px;
            }

            .search-form {
                flex-direction: column;
            }

            .search-btn {
                width: 100%;
            }

            .developer-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="logo">ProjectHub</div>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/dashboard.jsp">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/profile">
            My Profile
        </a>
    </div>
</nav>

<main class="container">

    <header class="page-header">
        <h1>Discover Developers</h1>
        <p>Find developers, explore their profiles, and grow your network.</p>
    </header>

    <section class="search-card">
        <form class="search-form"
              action="<%= request.getContextPath() %>/search-developers"
              method="get">

            <input
                    type="text"
                    name="name"
                    placeholder="Search developers by name..."
                    value="<%= escapeHtml(searchName) %>"
                    maxlength="100"
                    required
            >

            <button type="submit" class="search-btn">
                Search
            </button>
        </form>
    </section>

    <h2 class="results-heading">
        <%
            if (!searchName.isEmpty()) {
        %>
        Search Results
        <%
        } else {
        %>
        Search for Developers
        <%
            }
        %>
    </h2>

    <%
        if (searchName.isEmpty()) {
    %>

    <div class="empty-state">
        <h3>Who are you looking for?</h3>
        <p>
            Enter a developer's name in the search box above
            to discover their profile and follow them.
        </p>
    </div>

    <%
    } else if (searchResults.isEmpty()) {
    %>

    <div class="empty-state">
        <h3>No developers found</h3>

        <p>
            We couldn't find any developers matching
            "<%= escapeHtml(searchName) %>".
            Try another name.
        </p>

        <a class="back-link"
           href="<%= request.getContextPath() %>/search-developers">
            Clear Search
        </a>
    </div>

    <%
    } else {
    %>

    <div class="developer-grid">

        <%
            for (User developer : searchResults) {
                boolean isFollowing =
                        followingUserIds.contains(developer.getId());

                String developerName = developer.getName();

                String initial = "?";
                if (developerName != null
                        && !developerName.trim().isEmpty()) {
                    initial = developerName.trim()
                            .substring(0, 1)
                            .toUpperCase();
                }
        %>

        <article class="developer-card">

            <div class="avatar">
                <%= escapeHtml(initial) %>
            </div>

            <h3>
                <a class="developer-name"
                   href="<%= request.getContextPath() %>/public-profile?id=<%= developer.getId() %>">
                    <%= escapeHtml(developerName) %>
                </a>
            </h3>

            <p>ProjectHub Developer</p>

            <div class="card-actions">

                <a class="profile-btn"
                   href="<%= request.getContextPath() %>/public-profile?id=<%= developer.getId() %>">
                    View Profile
                </a>

                <form class="follow-form"
                      action="<%= request.getContextPath() %>/follow"
                      method="post">

                    <input type="hidden"
                           name="followedId"
                           value="<%= developer.getId() %>">

                    <% if (isFollowing) { %>

                    <input type="hidden"
                           name="action"
                           value="unfollow">

                    <button type="submit"
                            class="unfollow-btn">
                        Unfollow
                    </button>

                    <% } else { %>

                    <input type="hidden"
                           name="action"
                           value="follow">

                    <button type="submit"
                            class="follow-btn">
                        Follow
                    </button>

                    <% } %>

                </form>

            </div>

        </article>

        <%
            }
        %>

    </div>

    <%
        }
    %>

</main>

</body>
</html>
