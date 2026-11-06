
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Project Details | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }

        header {
            background: #172554;
            color: white;
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 16px;
        }

        main {
            max-width: 850px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 32px;
            border-radius: 14px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);
        }

        h1 {
            color: #172554;
            overflow-wrap: anywhere;
        }

        .description {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            line-height: 1.8;
            margin-top: 25px;
        }

        .label {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .value {
            margin-top: 0;
            margin-bottom: 24px;
            overflow-wrap: anywhere;
        }

        .status {
            display: inline-block;
            background: #dcfce7;
            color: #166534;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .button {
            display: inline-block;
            padding: 11px 17px;
            border: none;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .button:hover {
            opacity: 0.9;
        }

        .delete-button {
            background: #dc2626;
        }

        .join-button {
            background: #15803d;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            align-items: center;
        }

        .actions form {
            margin: 0;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #2563eb;
            text-decoration: none;
        }

        .skills-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 24px;
        }

        .skill-tag {
            display: inline-block;
            background: #e0e7ff;
            color: #1e40af;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        @media (max-width: 600px) {
            header {
                padding: 18px 5%;
            }

            header a {
                margin-left: 0;
                margin-right: 12px;
            }

            .card {
                padding: 22px;
            }
        }
    </style>
</head>

<body>

<header>
    <h2>ProjectHub</h2>

    <nav>
        <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a>
        <a href="${pageContext.request.contextPath}/projects">Projects</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </nav>
</header>

<main>

    <a class="back-link"
       href="${pageContext.request.contextPath}/projects">
        &larr; Back to Projects
    </a>

    <div class="card">

        <h1>
            <c:out value="${project.title}"/>
        </h1>

        <div style="background: #fff3cd; padding: 15px; margin: 15px 0;">
            <p>Logged-in User ID:
                <c:out value="${sessionScope.userId}"/>
            </p>

            <p>Project Owner ID:
                <c:out value="${project.owner.id}"/>
            </p>
        </div>

        <span class="status">
            <c:out value="${project.status}"/>
        </span>

        <p class="label" style="margin-top: 25px;">Created by</p>
        <p class="value">
            <c:out value="${project.owner.name}"/>
        </p>

        <p class="label">Project Description</p>
        <div class="description">
            <c:out value="${project.description}"/>
        </div>

        <c:if test="${not empty project.projectType}">
            <p class="label" style="margin-top: 28px;">Project Type</p>
            <p class="value">
                <c:out value="${project.projectType}"/>
            </p>
        </c:if>

        <c:if test="${not empty project.techStack}">
            <p class="label">Technology Stack</p>
            <p class="value">
                <c:out value="${project.techStack}"/>
            </p>
        </c:if>

        <p class="label">Members Required</p>
        <p class="value">
            <c:out value="${remainingMembers}"/>
        </p>

        <c:if test="${not empty project.requiredSkills}">
            <p class="label">Required Skills</p>

            <div class="skills-list">
                <c:forEach var="skill" items="${project.requiredSkills}">
                    <span class="skill-tag">
                        <c:out value="${skill.name}"/>
                    </span>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty project.githubUrl}">
            <p class="label">GitHub Repository</p>
            <p class="value">
                <c:out value="${project.githubUrl}"/>
            </p>
        </c:if>

        <c:if test="${not empty project.demoUrl}">
            <p class="label">Live Demo</p>
            <p class="value">
                <c:out value="${project.demoUrl}"/>
            </p>
        </c:if>

        <p class="label">Created On</p>
        <p class="value">
            <c:out value="${project.createdAt}"/>
        </p>

        <%-- Join button for logged-in users who do not own the project --%>
        <c:if test="${not empty sessionScope.userId
                 and sessionScope.userId ne project.owner.id}">

            <form action="${pageContext.request.contextPath}/join-requests"
                  method="post"
                  style="margin-top: 25px;">

                <input type="hidden" name="action" value="create">

                <input type="hidden"
                       name="projectId"
                       value="<c:out value='${project.id}'/>">

                <button type="submit" class="button join-button"
                        <c:if test="${isProjectMember}">disabled</c:if>>

                    <c:choose>

                        <c:when test="${isProjectMember}">
                            Joined
                        </c:when>

                        <c:when test="${hasPendingJoinRequest}">
                            Requested
                        </c:when>

                        <c:otherwise>
                            Request to Join
                        </c:otherwise>

                    </c:choose>
                </button>
            </form>

        </c:if>

        <%-- Project management controls for the owner only --%>
        <c:if test="${not empty sessionScope.userId
                 and sessionScope.userId eq project.owner.id}">

            <div class="actions">
                <a class="button"
                   href="${pageContext.request.contextPath}/team?projectId=${project.id}">
                    Team Dashboard
                </a>

                <a class="button"
                   href="${pageContext.request.contextPath}/join-requests?action=list&amp;projectId=${project.id}">
                    Manage Join Requests
                </a>

                <a class="button"
                   href="${pageContext.request.contextPath}/projects?action=edit&amp;id=${project.id}">
                    Edit Project
                </a>

                <form action="${pageContext.request.contextPath}/projects"
                      method="post"
                      onsubmit="return confirm('Are you sure you want to delete this project?');">

                    <input type="hidden" name="action" value="delete">

                    <input type="hidden"
                           name="id"
                           value="<c:out value='${project.id}'/>">

                    <button type="submit" class="button delete-button">
                        Delete Project
                    </button>
                </form>

            </div>

        </c:if>

    </div>

</main>

</body>
</html>

