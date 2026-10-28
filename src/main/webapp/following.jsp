<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projecthub.entity.User" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> following = (List<User>) request.getAttribute("following");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Following | ProjectHub</title>
    <style>
        :root {
            --primary: #635bff;
            --primary-dark: #4f46e5;
            --navy: #171936;
            --text: #252746;
            --muted: #777b96;
            --surface: #ffffff;
            --border: #ececf5;
            --background: #f7f7fc;
            --shadow: 0 12px 35px rgba(35, 34, 80, 0.06);
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at 10% 0%, rgba(99,91,255,.09), transparent 30%), var(--background);
        }
        a { -webkit-tap-highlight-color: transparent; }
        .topbar {
            position: sticky; top: 0; z-index: 10;
            display: flex; justify-content: space-between; align-items: center; gap: 20px;
            padding: 18px max(5%, calc((100% - 1120px) / 2));
            background: rgba(255,255,255,.92); backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(230,230,245,.9);
        }
        .brand {
            display: inline-flex; align-items: center; gap: 10px;
            color: var(--navy); text-decoration: none; font-size: 22px;
            font-weight: 800; letter-spacing: -.8px;
        }
        .brand-icon {
            display: grid; place-items: center; width: 38px; height: 38px;
            color: white; border-radius: 12px;
            background: linear-gradient(135deg,#766cff,#5145d8);
            box-shadow: 0 6px 14px rgba(99,91,255,.25);
        }
        .nav-link {
            display: inline-flex; align-items: center; gap: 8px; padding: 10px 15px;
            color: var(--primary-dark); background: #f0efff; border: 1px solid #e6e4ff;
            border-radius: 11px; text-decoration: none; font-size: 14px; font-weight: 700;
            transition: background .2s, transform .2s;
        }
        .nav-link:hover { background: #e7e5ff; transform: translateY(-1px); }
        .container { width: min(100% - 36px, 1000px); margin: 42px auto 70px; }
        .hero {
            position: relative; overflow: hidden; padding: 35px; color: white; border-radius: 24px;
            background: linear-gradient(120deg,#252354,#5145d8 65%,#8176ff);
            box-shadow: 0 18px 45px rgba(71,63,183,.18);
        }
        .hero::after {
            content: ""; position: absolute; width: 220px; height: 220px; right: -65px; top: -95px;
            border: 35px solid rgba(255,255,255,.08); border-radius: 50%; pointer-events: none;
        }
        .eyebrow { margin: 0 0 12px; color: #d5d1ff; font-size: 12px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; }
        .hero h1 { margin: 0; font-size: clamp(28px,4vw,38px); letter-spacing: -1.2px; }
        .description { max-width: 540px; margin: 12px 0 0; color: #e3e1ff; line-height: 1.7; font-size: 15px; }
        .stats { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 25px; }
        .stat-pill {
            display: inline-flex; align-items: center; gap: 9px; padding: 10px 14px;
            border: 1px solid rgba(255,255,255,.19); border-radius: 12px;
            background: rgba(255,255,255,.1); font-size: 13px;
        }
        .stat-number { font-size: 17px; font-weight: 800; }
        .section-heading { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin: 35px 0 18px; }
        .section-heading h2 { margin: 0; color: var(--navy); font-size: 21px; letter-spacing: -.5px; }
        .section-heading p { margin: 6px 0 0; color: var(--muted); font-size: 14px; }
        .following-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 18px; }
        .following-card {
            display: flex; align-items: center; gap: 15px; min-width: 0; padding: 22px;
            background: var(--surface); border: 1px solid var(--border); border-radius: 18px;
            box-shadow: var(--shadow); transition: transform .22s, box-shadow .22s, border-color .22s;
            animation: appear .35s ease both;
        }
        .following-card:hover { transform: translateY(-4px); border-color: #d9d5ff; box-shadow: 0 18px 40px rgba(57,48,130,.11); }
        .avatar {
            display: grid; place-items: center; flex: 0 0 54px; width: 54px; height: 54px;
            color: white; border-radius: 17px; background: linear-gradient(135deg,#766cff,#5145d8);
            box-shadow: 0 7px 15px rgba(99,91,255,.2); font-size: 22px; font-weight: 800; text-transform: uppercase;
        }
        .following-info { min-width: 0; flex: 1; }
        .following-name { display: block; overflow-wrap: anywhere; color: var(--navy); text-decoration: none; font-size: 16px; font-weight: 800; }
        .following-name:hover { color: var(--primary); }
        .following-role { margin: 6px 0 0; color: var(--muted); font-size: 13px; }
        .view-profile {
            display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0;
            width: 36px; height: 36px; color: var(--primary-dark); background: #f1f0ff;
            border-radius: 11px; text-decoration: none; font-size: 20px; transition: background .2s;
        }
        .view-profile:hover { background: #e4e1ff; }
        .empty-state { padding: 55px 25px; text-align: center; background: var(--surface); border: 1px solid var(--border); border-radius: 20px; box-shadow: var(--shadow); }
        .empty-icon { display: grid; place-items: center; width: 76px; height: 76px; margin: 0 auto 20px; color: var(--primary); background: #efedff; border-radius: 24px; font-size: 32px; }
        .empty-state h2 { margin: 0 0 10px; color: var(--navy); font-size: 22px; }
        .empty-state p { max-width: 400px; margin: 0 auto 24px; color: var(--muted); line-height: 1.7; font-size: 14px; }
        .primary-button {
            display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 12px 18px;
            color: white; background: linear-gradient(135deg,#766cff,#5145d8); border-radius: 11px;
            text-decoration: none; font-size: 14px; font-weight: 800;
            box-shadow: 0 7px 18px rgba(99,91,255,.2); transition: transform .2s, box-shadow .2s;
        }
        .primary-button:hover { transform: translateY(-2px); box-shadow: 0 11px 22px rgba(99,91,255,.28); }
        .footer { padding: 28px 10px 0; color: #9294aa; text-align: center; font-size: 12px; }
        a:focus-visible { outline: 3px solid #aaa4ff; outline-offset: 3px; }
        @keyframes appear { from { opacity: 0; transform: translateY(9px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 650px) {
            .container { margin-top: 25px; }
            .hero { padding: 27px 23px; border-radius: 20px; }
            .following-grid { grid-template-columns: 1fr; }
            .following-card { padding: 18px; }
        }
        @media (max-width: 400px) {
            .topbar { padding: 13px 16px; }
            .brand { font-size: 19px; }
            .brand-icon { width: 34px; height: 34px; }
            .nav-link { padding: 9px 10px; font-size: 12px; }
            .container { width: calc(100% - 24px); }
            .hero h1 { font-size: 27px; }
        }
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { animation-duration: .01ms !important; transition-duration: .01ms !important; }
        }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand" href="<%= contextPath %>/dashboard.jsp">
        <span class="brand-icon">P</span><span>ProjectHub</span>
    </a>
    <a class="nav-link" href="<%= contextPath %>/dashboard.jsp"><span aria-hidden="true">←</span> Dashboard</a>
</header>

<main class="container">
    <section class="hero">
        <p class="eyebrow">Your network</p>
        <h1>Following</h1>
        <p class="description">Keep up with the developers you admire. Explore their profiles, discover new ideas and grow your developer network.</p>
        <div class="stats">
            <div class="stat-pill">
                <span aria-hidden="true">✨</span>
                <span class="stat-number"><%= following == null ? 0 : following.size() %></span>
                <span>Following</span>
            </div>
            <div class="stat-pill"><span aria-hidden="true">🤝</span><span>Connections that inspire</span></div>
        </div>
    </section>

    <div class="section-heading">
        <div><h2>People you follow</h2><p>Visit their profiles and see what they are working on.</p></div>
    </div>

    <% if (following == null || following.isEmpty()) { %>
    <section class="empty-state">
        <div class="empty-icon" aria-hidden="true">🔎</div>
        <h2>Find your people</h2>
        <p>You're not following any developers yet. Explore the ProjectHub community and follow developers whose work interests you.</p>
        <a class="primary-button" href="<%= contextPath %>/dashboard.jsp">Discover developers <span aria-hidden="true">→</span></a>
    </section>
    <% } else { %>
    <section class="following-grid" aria-label="Developers you follow">
        <% for (User developer : following) {
            String name = developer.getName();
            if (name == null || name.trim().isEmpty()) name = "Developer";
            String initial = name.substring(0, 1).toUpperCase();
            String safeName = name.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
            String safeInitial = initial.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
        %>
        <article class="following-card">
            <div class="avatar" aria-hidden="true"><%= safeInitial %></div>
            <div class="following-info">
                <a class="following-name" href="<%= contextPath %>/public-profile?id=<%= developer.getId() %>"><%= safeName %></a>
                <p class="following-role">ProjectHub Developer</p>
            </div>
            <a class="view-profile" href="<%= contextPath %>/public-profile?id=<%= developer.getId() %>" aria-label="View <%= safeName %>'s profile" title="View profile">↗</a>
        </article>
        <% } %>
    </section>
    <% } %>

    <footer class="footer">ProjectHub · Build connections. Share ideas. Grow together.</footer>
</main>
</body>
</html>
