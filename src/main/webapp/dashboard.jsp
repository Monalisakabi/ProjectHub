<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    // Initialize FollowService
    FollowService followService = new FollowService();

    // Fetch all other registered developers
    List<User> otherUsers =
            followService.getOtherUsers(currentUserId);

    // Fetch IDs of developers followed by the current user
    Set<Long> followingUserIds =
            followService.getFollowingUserIds(currentUserId);

    // Get the logged-in user's name
    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    // Escape HTML characters to prevent HTML injection
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

        .logout:hover {
            background: #1d4ed8;
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

        /* Discover Developers section */
        .developers {
            margin-top: 35px;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .developers h2 {
            margin-top: 0;
            color: #2563eb;
        }

        .developers-description {
            color: #6b7280;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        .developer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .developer-card {
            padding: 20px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: #f9fafb;
        }

        .developer-card h3 {
            margin-top: 0;
            overflow-wrap: anywhere;
        }

        .developer-card p {
            color: #6b7280;
        }

        .follow-btn,
        .unfollow-btn {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }

        .follow-btn {
            background: #2563eb;
        }

        .unfollow-btn {
            background: #dc2626;
        }

        .follow-btn:hover {
            background: #1d4ed8;
        }

        .unfollow-btn:hover {
            background: #b91c1c;
        }

        .empty-message {
            color: #6b7280;
            line-height: 1.5;
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

            .developers {
                padding: 22px;
            }

            main {
                margin: 25px auto;
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

    <!-- Welcome section -->
    <section class="welcome">

        <h1>Welcome, <%= safeUserName %>! 👋</h1>

        <p>
            Welcome to ProjectHub — your space to build projects,
            collaborate with others, and showcase your skills.
        </p>

        <span class="status">Login successful</span>

    </section>

    <!-- Dashboard feature cards -->
    <section class="cards">

        <div class="card">
            <h2>👤 My Profile</h2>
            <p>
                Manage your personal information, skills, and social links.
            </p>
        </div>

        <div class="card">
            <h2>💻 Projects</h2>
            <p>
                Create projects, showcase your work, and discover new ideas.
            </p>
        </div>

        <div class="card">
            <h2>🤝 Collaboration</h2>
            <p>
                Connect with other developers and collaborate on projects.
            </p>
        </div>

    </section>

    <!-- Discover Developers section -->
    <section class="developers">

        <h2>👥 Discover Developers</h2>

        <p class="developers-description">
            Connect with other developers and grow your network.
        </p>

        <div class="developer-grid">

            <% if (otherUsers == null || otherUsers.isEmpty()) { %>

            <p class="empty-message">
                No other developers have registered yet.
            </p>

            <% } else { %>

            <% for (User developer : otherUsers) {

                boolean isFollowing =
                        followingUserIds.contains(developer.getId());

                String developerName = developer.getName();

                if (developerName == null ||
                        developerName.trim().isEmpty()) {
                    developerName = "Developer";
                }

                String safeDeveloperName = developerName
                        .replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")
                        .replace("\"", "&quot;")
                        .replace("'", "&#39;");
            %>

            <div class="developer-card">

                <h3><%= safeDeveloperName %></h3>

                <p>ProjectHub Developer</p>

                <form
                        action="<%= request.getContextPath() %>/follow"
                        method="post">

                    <input
                            type="hidden"
                            name="followedId"
                            value="<%= developer.getId() %>">

                    <% if (isFollowing) { %>

                    <input
                            type="hidden"
                            name="action"
                            value="unfollow">

                    <button
                            type="submit"
                            class="unfollow-btn">
                        Unfollow
                    </button>

                    <% } else { %>

                    <input
                            type="hidden"
                            name="action"
                            value="follow">

                    <button
                            type="submit"
                            class="follow-btn">
                        Follow
                    </button>

                    <% } %>

                </form>

            </div>

            <% } %>

            <% } %>

        </div>

    </section>

</main>

</body>
</html>
