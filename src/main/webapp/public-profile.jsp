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

  String githubUrl = developer.getGithubUrl();
  String linkedinUrl = developer.getLinkedinUrl();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= escapeHtml(developer.getName()) %> | ProjectHub</title>

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f4f7fb;
      color: #243047;
    }

    header {
      background: #ffffff;
      padding: 18px 7%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #e5eaf2;
    }

    .logo {
      color: #3157d5;
      font-size: 24px;
      font-weight: bold;
      text-decoration: none;
    }

    .back-link {
      text-decoration: none;
      color: #3157d5;
      font-weight: bold;
    }

    main {
      max-width: 720px;
      margin: 55px auto;
      padding: 0 20px;
    }

    .profile-card {
      background: white;
      padding: 38px;
      border-radius: 16px;
      box-shadow: 0 8px 28px rgba(30, 50, 90, 0.08);
    }

    .avatar {
      width: 82px;
      height: 82px;
      border-radius: 50%;
      background: #e5ebff;
      color: #3157d5;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 32px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    h1 {
      margin: 0 0 12px;
      overflow-wrap: anywhere;
    }

    .bio {
      color: #596579;
      line-height: 1.7;
      white-space: pre-wrap;
      overflow-wrap: anywhere;
    }

    .links {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 28px;
    }

    .profile-link {
      display: inline-block;
      padding: 11px 18px;
      border-radius: 8px;
      background: #3157d5;
      color: white;
      text-decoration: none;
      font-weight: bold;
    }

    .empty-bio {
      color: #7b8494;
      font-style: italic;
    }

    @media (max-width: 500px) {
      .profile-card {
        padding: 25px;
      }

      header {
        padding: 16px 5%;
      }
    }
  </style>
</head>

<body>

<header>
  <a class="logo"
     href="<%= request.getContextPath() %>/dashboard.jsp">ProjectHub</a>

  <a class="back-link"
     href="<%= request.getContextPath() %>/dashboard.jsp">← Dashboard</a>
</header>

<main>
  <section class="profile-card">

    <div class="avatar">
      <%= developer.getName() != null && !developer.getName().isBlank()
              ? escapeHtml(developer.getName().substring(0, 1).toUpperCase())
              : "D" %>
    </div>

    <h1><%= escapeHtml(developer.getName()) %></h1>

    <div class="bio">
      <% if (developer.getBio() != null && !developer.getBio().isBlank()) { %>
      <%= escapeHtml(developer.getBio()) %>
      <% } else { %>
      <span class="empty-bio">This developer hasn't added a bio yet.</span>
      <% } %>
    </div>

    <div class="links">
      <% if (isSafeProfileUrl(githubUrl)) { %>
      <a class="profile-link"
         href="<%= escapeHtml(githubUrl.trim()) %>"
         target="_blank"
         rel="noopener noreferrer">GitHub Profile</a>
      <% } %>

      <% if (isSafeProfileUrl(linkedinUrl)) { %>
      <a class="profile-link"
         href="<%= escapeHtml(linkedinUrl.trim()) %>"
         target="_blank"
         rel="noopener noreferrer">LinkedIn Profile</a>
      <% } %>
    </div>

  </section>
</main>

</body>
</html>
