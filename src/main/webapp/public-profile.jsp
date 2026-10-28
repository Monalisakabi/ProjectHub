<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.projecthub.entity.User" %>

<%!
  private String escapeHtml(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
  }

  private boolean isSafeProfileUrl(String value) {
    if (value == null || value.isBlank()) return false;
    try {
      java.net.URI uri = new java.net.URI(value.trim());
      String scheme = uri.getScheme();
      return uri.isAbsolute()
              && ("https".equalsIgnoreCase(scheme)
              || "http".equalsIgnoreCase(scheme))
              && uri.getHost() != null;
    } catch (Exception e) {
      return false;
    }
  }
%>

<%
  User developer = (User) request.getAttribute("profileUser");

  if (developer == null) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Developer not found.");
    return;
  }

  String developerName = developer.getName() != null && !developer.getName().isBlank()
          ? developer.getName().trim() : "Developer";
  String githubUrl = developer.getGithubUrl();
  String linkedinUrl = developer.getLinkedinUrl();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= escapeHtml(developerName) %> | ProjectHub</title>

  <style>
    :root {
      --ink: #202044;
      --muted: #6c6b85;
      --purple: #6941c6;
      --blue: #3678f5;
      --pink: #ec4899;
      --line: #ecebfa;
      --surface: rgba(255, 255, 255, 0.94);
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      min-height: 100vh;
      font-family: Inter, "Segoe UI", Arial, sans-serif;
      color: var(--ink);
      background:
              radial-gradient(ellipse at 12% 8%, rgba(236, 72, 153, .14), transparent 34%),
              radial-gradient(ellipse at 90% 20%, rgba(54, 120, 245, .16), transparent 34%),
              linear-gradient(135deg, #f8f6ff 0%, #f1f5ff 52%, #fff5fb 100%);
    }

    a { -webkit-tap-highlight-color: transparent; }

    .topbar {
      position: relative;
      z-index: 2;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 18px;
      padding: 18px clamp(20px, 7vw, 100px);
      background: rgba(255, 255, 255, .82);
      border-bottom: 1px solid rgba(230, 229, 248, .9);
      backdrop-filter: blur(16px);
    }

    .brand {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      color: var(--ink);
      text-decoration: none;
      font-size: 22px;
      font-weight: 850;
      letter-spacing: -.7px;
    }

    .brand-mark {
      width: 36px;
      height: 36px;
      display: grid;
      place-items: center;
      border-radius: 12px;
      color: #fff;
      background: linear-gradient(135deg, var(--purple), var(--blue), var(--pink));
      box-shadow: 0 7px 18px rgba(105, 65, 198, .25);
      font-size: 17px;
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 15px;
      border: 1px solid #e7e5f7;
      border-radius: 12px;
      background: #fff;
      color: #5145a8;
      text-decoration: none;
      font-weight: 750;
      font-size: 14px;
      transition: transform .2s ease, box-shadow .2s ease, border-color .2s ease;
    }

    .back-link:hover {
      transform: translateY(-2px);
      border-color: #c9c2f5;
      box-shadow: 0 8px 20px rgba(62, 54, 130, .10);
    }

    main {
      width: min(920px, calc(100% - 36px));
      margin: clamp(30px, 6vw, 66px) auto 60px;
    }

    .eyebrow {
      margin: 0 0 13px;
      color: #7867c8;
      text-align: center;
      text-transform: uppercase;
      letter-spacing: 2.2px;
      font-size: 11px;
      font-weight: 850;
    }

    .page-title {
      margin: 0 0 30px;
      text-align: center;
      font-size: clamp(28px, 4vw, 40px);
      line-height: 1.15;
      letter-spacing: -1.4px;
    }

    .page-title span {
      color: transparent;
      background: linear-gradient(100deg, var(--purple), var(--blue), var(--pink));
      -webkit-background-clip: text;
      background-clip: text;
    }

    .profile-card {
      position: relative;
      overflow: hidden;
      background: var(--surface);
      border: 1px solid rgba(255, 255, 255, .95);
      border-radius: 28px;
      box-shadow: 0 24px 70px rgba(54, 58, 120, .13);
      animation: rise-in .55s ease both;
    }

    .cover {
      height: 176px;
      position: relative;
      overflow: hidden;
      background: linear-gradient(115deg, #633bd0 0%, #3678f5 52%, #ec4899 100%);
    }

    .cover::before,
    .cover::after {
      content: "";
      position: absolute;
      border: 1px solid rgba(255, 255, 255, .25);
      border-radius: 50%;
    }

    .cover::before {
      width: 310px;
      height: 310px;
      top: -205px;
      right: 8%;
      box-shadow: 0 0 0 28px rgba(255,255,255,.06), 0 0 0 58px rgba(255,255,255,.05);
    }

    .cover::after {
      width: 210px;
      height: 210px;
      bottom: -160px;
      left: 10%;
      box-shadow: 0 0 0 24px rgba(255,255,255,.07);
    }

    .profile-content {
      padding: 0 clamp(22px, 5vw, 56px) 42px;
    }

    .identity-row {
      display: flex;
      align-items: flex-end;
      gap: 22px;
      margin-top: -57px;
      position: relative;
    }

    .avatar {
      flex: 0 0 auto;
      width: 116px;
      height: 116px;
      display: grid;
      place-items: center;
      border: 6px solid #fff;
      border-radius: 30px;
      background: linear-gradient(145deg, #f0eaff, #e4edff 58%, #ffe4f2);
      color: #5c49bd;
      box-shadow: 0 12px 30px rgba(37, 40, 92, .16);
      font-size: 44px;
      font-weight: 900;
      text-transform: uppercase;
    }

    .identity-text {
      min-width: 0;
      padding: 0 0 9px;
    }

    h1 {
      margin: 0;
      overflow-wrap: anywhere;
      font-size: clamp(25px, 4vw, 34px);
      letter-spacing: -1px;
      line-height: 1.2;
    }

    .subtitle {
      margin: 8px 0 0;
      color: var(--muted);
      font-size: 14px;
    }

    .section-divider {
      height: 1px;
      margin: 30px 0 25px;
      background: linear-gradient(90deg, #e5ddff, #e8edff, transparent);
    }

    .section-heading {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 0 0 14px;
      font-size: 15px;
      font-weight: 850;
    }

    .section-icon {
      width: 31px;
      height: 31px;
      display: grid;
      place-items: center;
      border-radius: 10px;
      background: #f0ebff;
      color: #6b48c9;
      font-size: 15px;
    }

    .bio {
      margin: 0;
      color: #555771;
      font-size: 15px;
      line-height: 1.85;
      white-space: pre-wrap;
      overflow-wrap: anywhere;
    }

    .empty-bio {
      display: block;
      padding: 17px 18px;
      border: 1px dashed #d8d4f1;
      border-radius: 14px;
      background: #faf9ff;
      color: #85839e;
      font-style: italic;
    }

    .links {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 14px;
    }

    .profile-link {
      display: flex;
      align-items: center;
      gap: 13px;
      min-width: 0;
      padding: 16px;
      border: 1px solid #e9e7fa;
      border-radius: 16px;
      background: #fff;
      color: var(--ink);
      text-decoration: none;
      transition: transform .2s ease, box-shadow .2s ease, border-color .2s ease;
    }

    .profile-link:hover {
      transform: translateY(-3px);
      border-color: #cfc5fb;
      box-shadow: 0 12px 25px rgba(70, 58, 145, .10);
    }

    .social-icon {
      flex: 0 0 auto;
      width: 42px;
      height: 42px;
      display: grid;
      place-items: center;
      border-radius: 13px;
      color: #fff;
      font-size: 16px;
      font-weight: 900;
    }

    .github-icon { background: linear-gradient(135deg, #27263a, #55536e); }
    .linkedin-icon { background: linear-gradient(135deg, #0878b9, #4a9fe0); }

    .social-copy { min-width: 0; }
    .social-title { display: block; font-size: 14px; font-weight: 850; }
    .social-subtitle {
      display: block;
      margin-top: 4px;
      color: #85839e;
      font-size: 12px;
    }

    .arrow {
      margin-left: auto;
      color: #8b7ad1;
      font-size: 20px;
    }

    .no-links {
      padding: 18px;
      border-radius: 14px;
      background: #f8f7ff;
      color: #77758f;
      font-size: 14px;
      line-height: 1.6;
    }

    .bottom-action {
      display: flex;
      justify-content: center;
      margin-top: 26px;
    }

    .bottom-action a {
      display: inline-flex;
      align-items: center;
      gap: 9px;
      padding: 12px 18px;
      border-radius: 13px;
      color: #fff;
      background: linear-gradient(105deg, var(--purple), var(--blue));
      text-decoration: none;
      font-size: 14px;
      font-weight: 800;
      box-shadow: 0 9px 22px rgba(89, 83, 207, .23);
      transition: transform .2s ease, box-shadow .2s ease;
    }

    .bottom-action a:hover {
      transform: translateY(-2px);
      box-shadow: 0 13px 26px rgba(89, 83, 207, .3);
    }

    @keyframes rise-in {
      from { opacity: 0; transform: translateY(14px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 600px) {
      .topbar { padding: 14px 18px; }
      .brand { font-size: 20px; }
      .back-link { padding: 9px 11px; font-size: 13px; }
      main { width: min(100% - 24px, 920px); margin-top: 32px; }
      .cover { height: 135px; }
      .identity-row { align-items: flex-start; flex-direction: column; gap: 13px; margin-top: -48px; }
      .avatar { width: 96px; height: 96px; border-radius: 25px; font-size: 36px; }
      .identity-text { padding: 0; }
      .profile-content { padding-bottom: 30px; }
      .section-divider { margin: 24px 0 21px; }
      .links { grid-template-columns: 1fr; }
    }

    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
        animation-duration: .01ms !important;
        animation-iteration-count: 1 !important;
        scroll-behavior: auto !important;
        transition-duration: .01ms !important;
      }
    }
  </style>
</head>

<body>
<header class="topbar">
  <a class="brand" href="<%= request.getContextPath() %>/dashboard.jsp">
    <span class="brand-mark">P</span>
    <span>ProjectHub</span>
  </a>
  <a class="back-link" href="<%= request.getContextPath() %>/dashboard.jsp">
    <span aria-hidden="true">←</span> Dashboard
  </a>
</header>

<main>
  <p class="eyebrow">Developer community</p>
  <h2 class="page-title">Meet the <span>developer</span></h2>

  <section class="profile-card" aria-label="Developer profile">
    <div class="cover" aria-hidden="true"></div>

    <div class="profile-content">
      <div class="identity-row">
        <div class="avatar" aria-hidden="true"><%= escapeHtml(developerName.substring(0, 1)) %></div>
        <div class="identity-text">
          <h1><%= escapeHtml(developerName) %></h1>
          <p class="subtitle">ProjectHub community member</p>
        </div>
      </div>

      <div class="section-divider"></div>

      <h2 class="section-heading">
        <span class="section-icon" aria-hidden="true">✦</span>
        About
      </h2>
      <p class="bio">
        <% if (developer.getBio() != null && !developer.getBio().isBlank()) { %><%= escapeHtml(developer.getBio()) %><% } else { %><span class="empty-bio">This developer hasn't added a bio yet.</span><% } %>
      </p>

      <div class="section-divider"></div>

      <h2 class="section-heading">
        <span class="section-icon" aria-hidden="true">↗</span>
        Connect
      </h2>

      <div class="links">
        <% if (isSafeProfileUrl(githubUrl)) { %>
        <a class="profile-link" href="<%= escapeHtml(githubUrl.trim()) %>" target="_blank" rel="noopener noreferrer">
          <span class="social-icon github-icon" aria-hidden="true">GH</span>
          <span class="social-copy">
              <span class="social-title">GitHub</span>
              <span class="social-subtitle">View code and projects</span>
            </span>
          <span class="arrow" aria-hidden="true">↗</span>
        </a>
        <% } %>

        <% if (isSafeProfileUrl(linkedinUrl)) { %>
        <a class="profile-link" href="<%= escapeHtml(linkedinUrl.trim()) %>" target="_blank" rel="noopener noreferrer">
          <span class="social-icon linkedin-icon" aria-hidden="true">in</span>
          <span class="social-copy">
              <span class="social-title">LinkedIn</span>
              <span class="social-subtitle">Connect professionally</span>
            </span>
          <span class="arrow" aria-hidden="true">↗</span>
        </a>
        <% } %>

        <% if (!isSafeProfileUrl(githubUrl) && !isSafeProfileUrl(linkedinUrl)) { %>
        <div class="no-links">No social links have been added yet. Check back later for ways to connect.</div>
        <% } %>
      </div>
    </div>
  </section>

  <div class="bottom-action">
    <a href="<%= request.getContextPath() %>/dashboard.jsp">
      <span aria-hidden="true">⌂</span> Back to developer dashboard
    </a>
  </div>
</main>
</body>
</html>
