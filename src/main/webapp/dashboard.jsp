<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.projecthub.entity.User" %>
<%@ page import="com.projecthub.service.FollowService" %>

<%
    Object sessionUserId = session.getAttribute("userId");

    if (!(sessionUserId instanceof Number)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Long currentUserId = ((Number) sessionUserId).longValue();

    FollowService followService = new FollowService();

    List<User> otherUsers = followService.getOtherUsers(currentUserId);

    Set<Long> followingUserIds =
            followService.getFollowingUserIds(currentUserId);

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
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

        :root {
            --ink: #202044;
            --muted: #70708b;
            --purple: #6d28d9;
            --blue: #2563eb;
            --pink: #ec4899;
            --line: #ecebfa;
            --surface: #ffffff;
            --shadow: 0 18px 45px rgba(50, 35, 120, .10);
        }

        * { box-sizing: border-box; }

        html { scroll-behavior: smooth; }

        body {
            margin: 0;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            color: var(--ink);
            background:
                    radial-gradient(circle at 8% 8%, rgba(236, 72, 153, .10), transparent 25rem),
                    radial-gradient(circle at 92% 20%, rgba(99, 102, 241, .12), transparent 28rem),
                    #f7f7ff;
            min-height: 100vh;
        }

        header {
            position: sticky;
            top: 0;
            z-index: 10;
            padding: 17px clamp(20px, 6vw, 90px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
            background: rgba(255, 255, 255, .88);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(226, 223, 250, .9);
            box-shadow: 0 5px 22px rgba(55, 40, 110, .05);
        }

        .logo {
            font-size: 25px;
            font-weight: 850;
            letter-spacing: -.8px;
            background: linear-gradient(100deg, #6d28d9, #2563eb 58%, #ec4899);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .header-actions { display: flex; align-items: center; gap: 10px; }

        .header-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 17px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 750;
            transition: transform .2s, box-shadow .2s, background .2s;
        }

        .header-btn:hover { transform: translateY(-2px); }
        .profile-link { background: #f0eaff; color: #5b21b6; }
        .profile-link:hover { background: #e5d9ff; }
        .logout {
            color: white;
            background: linear-gradient(110deg, #6d28d9, #3b82f6);
            box-shadow: 0 7px 16px rgba(91, 33, 182, .20);
        }
        .logout:hover { box-shadow: 0 10px 22px rgba(91, 33, 182, .28); }

        main {
            width: min(1160px, 100%);
            margin: 36px auto 70px;
            padding: 0 24px;
        }

        .welcome {
            position: relative;
            overflow: hidden;
            padding: clamp(28px, 5vw, 52px);
            border-radius: 28px;
            color: white;
            background: linear-gradient(118deg, #5b21b6 0%, #4f46e5 52%, #0ea5e9 100%);
            box-shadow: 0 22px 48px rgba(79, 70, 229, .24);
        }

        .welcome::before, .welcome::after {
            content: "";
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
            background: rgba(255, 255, 255, .10);
        }
        .welcome::before { width: 250px; height: 250px; right: -45px; top: -100px; }
        .welcome::after { width: 155px; height: 155px; right: 155px; bottom: -105px; }

        .welcome h1 {
            position: relative;
            z-index: 1;
            margin: 0 0 13px;
            font-size: clamp(28px, 4vw, 42px);
            letter-spacing: -1.1px;
            line-height: 1.15;
        }
        .welcome p {
            position: relative;
            z-index: 1;
            max-width: 680px;
            margin: 0;
            color: rgba(255, 255, 255, .88);
            line-height: 1.75;
            font-size: 16px;
        }

        .status {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 24px;
            padding: 9px 13px;
            border: 1px solid rgba(255,255,255,.24);
            border-radius: 999px;
            background: rgba(255,255,255,.15);
            color: white;
            font-size: 13px;
            font-weight: 750;
        }
        .status::before {
            content: "";
            width: 7px; height: 7px;
            border-radius: 50%;
            background: #86efac;
            box-shadow: 0 0 0 4px rgba(134,239,172,.17);
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 205px), 1fr));
            gap: 18px;
            margin-top: 24px;
        }

        .card {
            position: relative;
            min-height: 190px;
            padding: 24px;
            border: 1px solid var(--line);
            border-radius: 21px;
            background: var(--surface);
            box-shadow: 0 9px 28px rgba(55, 40, 110, .055);
        }

        .feature-card {
            display: block;
            color: inherit;
            text-decoration: none;
            transition: transform .22s ease, box-shadow .22s ease, border-color .22s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            border-color: #d7cbff;
            box-shadow: var(--shadow);
        }
        .feature-card:focus-visible, .header-btn:focus-visible,
        .developer-name-link:focus-visible, button:focus-visible {
            outline: 3px solid #a5b4fc;
            outline-offset: 4px;
        }
        .card h2 {
            margin: 0 0 12px;
            color: #3f2a83;
            font-size: 18px;
            letter-spacing: -.25px;
        }
        .card p {
            margin: 0;
            color: var(--muted);
            line-height: 1.65;
            font-size: 14px;
        }
        .feature-hint {
            display: inline-block;
            margin-top: 19px;
            color: #6d28d9;
            font-size: 13px;
            font-weight: 800;
        }

        .developers {
            margin-top: 28px;
            padding: clamp(22px, 4vw, 34px);
            border: 1px solid var(--line);
            border-radius: 26px;
            background: rgba(255,255,255,.94);
            box-shadow: var(--shadow);
        }
        .developers h2 {
            margin: 0 0 8px;
            color: #30205f;
            font-size: clamp(22px, 3vw, 28px);
            letter-spacing: -.6px;
        }
        .developers-description {
            margin: 0 0 24px;
            color: var(--muted);
            line-height: 1.6;
        }
        .developer-search-form {
            display: flex;
            gap: 12px;
            margin: 0 0 26px;
            max-width: 650px;
        }

        .developer-search-input {
            flex: 1;
            min-width: 0;
            padding: 14px 16px;
            border: 1px solid #ddd6fe;
            border-radius: 13px;
            background: #ffffff;
            color: #202044;
            font-size: 15px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .developer-search-input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 4px rgba(124, 58, 237, .12);
        }

        .developer-search-btn {
            padding: 13px 21px;
            border: none;
            border-radius: 13px;
            background: linear-gradient(110deg, #6d28d9, #3b82f6);
            color: white;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 7px 16px rgba(79, 70, 229, .18);
            transition: transform .2s, box-shadow .2s;
        }

        .developer-search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 22px rgba(79, 70, 229, .25);
        }

        @media (max-width: 480px) {
            .developer-search-form {
                flex-direction: column;
            }

            .developer-search-btn {
            width: 100%;
        }

        }


        .developer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 225px), 1fr));
            gap: 16px;
        }
        .developer-card {
            min-width: 0;
            padding: 21px;
            border: 1px solid #ece9fb;
            border-radius: 19px;
            background: linear-gradient(145deg, #fff 0%, #faf9ff 100%);
            transition: transform .2s, box-shadow .2s, border-color .2s;
        }
        .developer-card:hover {
            transform: translateY(-3px);
            border-color: #d9ceff;
            box-shadow: 0 13px 25px rgba(67, 56, 202, .09);
        }
        .developer-card h3 {
            margin: 0 0 7px;
            font-size: 17px;
            overflow-wrap: anywhere;
        }
        .developer-name-link {
            color: #5b21b6;
            text-decoration: none;
            overflow-wrap: anywhere;
        }
        .developer-name-link:hover { color: #2563eb; text-decoration: underline; }
        .developer-card p {
            margin: 0 0 18px;
            color: var(--muted);
            font-size: 13px;
        }

        .follow-btn, .unfollow-btn {
            width: 100%;
            min-height: 42px;
            padding: 11px 14px;
            border: 0;
            border-radius: 12px;
            color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 800;
            transition: transform .18s, box-shadow .18s, filter .18s;
        }
        .follow-btn {
            background: linear-gradient(110deg, #6d28d9, #3b82f6);
            box-shadow: 0 7px 14px rgba(79, 70, 229, .17);
        }
        .unfollow-btn {
            background: linear-gradient(110deg, #f43f5e, #e11d48);
            box-shadow: 0 7px 14px rgba(225, 29, 72, .13);
        }
        .follow-btn:hover, .unfollow-btn:hover { transform: translateY(-1px); filter: brightness(1.04); }
        .follow-btn:active, .unfollow-btn:active { transform: translateY(0); }

        .empty-message {
            grid-column: 1 / -1;
            margin: 0;
            padding: 25px;
            border: 1px dashed #d8d2f3;
            border-radius: 16px;
            color: var(--muted);
            background: #faf9ff;
            line-height: 1.6;
            text-align: center;
        }

        @media (max-width: 600px) {
            header { padding: 14px 5%; }
            .logo { font-size: 22px; }
            .header-actions { gap: 7px; }
            .header-btn { padding: 10px 12px; font-size: 13px; }
            main { margin: 23px auto 45px; padding: 0 15px; }
            .welcome { border-radius: 22px; }
            .cards { gap: 13px; }
            .card { min-height: auto; padding: 21px; }
            .developers { margin-top: 20px; border-radius: 22px; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                scroll-behavior: auto !important;
                transition-duration: .01ms !important;
                animation-duration: .01ms !important;
            }
        }

    </style>
</head>

<body>

<header>
    <div class="logo">ProjectHub</div>

    <div class="header-actions">

        <a class="header-btn profile-link"
           href="<%= request.getContextPath() %>/profile">
            My Profile
        </a>

        <a class="header-btn logout"
           href="<%= request.getContextPath() %>/logout">
            Log Out
        </a>

    </div>
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

        <a class="card feature-card"
           href="<%= request.getContextPath() %>/profile">

            <h2>👤 My Profile</h2>

            <p>
                Manage your personal information, bio,
                GitHub URL, and LinkedIn URL.
            </p>

            <span class="feature-hint">Edit Profile →</span>

        </a>

        <div class="card">

            <h2>💻 Projects</h2>

            <p>
                Create projects, showcase your work, and discover new ideas.
            </p>

            <a href="${pageContext.request.contextPath}/projects">
                View Projects →
            </a>

        </div>

        <div class="card">

            <h2>🤝 Collaboration</h2>

            <p>
                Connect with other developers and collaborate on projects.
            </p>

        </div>

        <a class="card feature-card"
           href="<%= request.getContextPath() %>/followers">

            <h2>👥 My Followers</h2>

            <p>
                See the developers who follow you.
            </p>

            <span class="feature-hint">View Followers →</span>
        </a>

        <a class="card feature-card"
           href="<%= request.getContextPath() %>/following">

            <h2>🤝 Following</h2>

            <p>
                See the developers you follow.
            </p>

            <span class="feature-hint">View Following →</span>
        </a>


    </section>

    <!-- Discover Developers section -->

    <section class="developers">

        <h2>👥 Discover Developers</h2>

        <p class="developers-description">
            Connect with other developers and grow your network.
        </p>
        <form
                action="<%= request.getContextPath() %>/search-developers"
                method="get"
                class="developer-search-form">


            <input
                    type="text"
                    name="name"
                    class="developer-search-input"
                    placeholder="🔎 Search developers by name..."
                    aria-label="Search developers by name"
                    maxlength="100"
                    required>

            <button type="submit" class="developer-search-btn">
                Search Developers
            </button>


        </form>

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


                <h3>
                    <a href="<%= request.getContextPath() %>/public-profile?id=<%= developer.getId() %>"
                       class="developer-name-link">
                        <%= safeDeveloperName %>
                    </a>
                </h3>

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
