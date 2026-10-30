<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projecthub.entity.Project" %>
<%@ page import="com.projecthub.entity.ProjectMember" %>
<%@ page import="java.util.List" %>

<%
    Project project = (Project) request.getAttribute("project");
    List<ProjectMember> teamMembers =
            (List<ProjectMember>) request.getAttribute("teamMembers");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Team Dashboard - ProjectHub</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 30px;
        }

        .container {
            max-width: 850px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }

        h1, h2 {
            color: #263445;
        }

        .member {
            padding: 12px;
            margin: 10px 0;
            background: #f1f5f9;
            border-radius: 6px;
        }

        .back {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #2563eb;
        }
    </style>
</head>

<body>
<div class="container">

    <a class="back" href="<%= request.getContextPath() %>/projects">
        ← Back to Projects
    </a>

    <h1>Team Dashboard</h1>

    <h2><%= project.getTitle() %></h2>
    <p><%= project.getDescription() %></p>

    <hr>

    <h2>Project Owner</h2>
    <div class="member">
        <strong><%= project.getOwner().getName() %></strong>
        <p>Team Owner</p>
    </div>

    <h2>Team Members (<%= teamMembers.size() %>)</h2>

    <% if (teamMembers.isEmpty()) { %>
    <p>No members have joined this project yet.</p>
    <% } else {
        for (ProjectMember member : teamMembers) { %>
    <div class="member">
        <strong><%= member.getUser().getName() %></strong>
        <p>Joined: <%= member.getJoinedAt() %></p>
    </div>
    <%  }
    } %>

</div>
</body>
</html>