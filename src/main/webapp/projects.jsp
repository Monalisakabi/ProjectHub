
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore Projects | ProjectHub</title>

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

        header a {
            color: white;
            text-decoration: none;
            margin-left: 16px;
        }

        main {
            max-width: 1100px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .button {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 11px 16px;
            border-radius: 7px;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            padding: 23px;
            border-radius: 12px;
            box-shadow: 0 3px 14px rgba(0, 0, 0, 0.06);
        }

        .card h2 {
            margin-top: 0;
            overflow-wrap: anywhere;
        }

        .description {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            line-height: 1.6;
        }

        .muted {
            color: #64748b;
            font-size: 14px;
        }

        .empty {
            background: white;
            padding: 35px;
            text-align: center;
            border-radius: 12px;
        }

        @media (max-width: 600px) {
            header {
                padding: 18px 5%;
            }

            header a {
                margin-left: 0;
                margin-right: 12px;
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
    <div class="heading">
        <div>
            <h1>Explore Projects</h1>
            <p class="muted">Discover what developers are building.</p>
        </div>

        <a class="button"
           href="${pageContext.request.contextPath}/projects?action=create">
            + Create Project
        </a>
    </div>

    <c:choose>
        <c:when test="${empty projects}">
            <div class="empty">
                <h2>No projects yet</h2>
                <p>Be the first to showcase a project on ProjectHub!</p>
                <a class="button"
                   href="${pageContext.request.contextPath}/projects?action=create">
                    Create Your First Project
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="grid">
                <c:forEach var="project" items="${projects}">
                    <article class="card">
                        <h2><c:out value="${project.title}"/></h2>

                        <p class="muted">
                            Created by
                            <c:out value="${project.owner.name}"/>
                        </p>

                        <p class="description">
                            <c:out value="${project.description}"/>
                        </p>

                        <c:if test="${not empty project.techStack}">
                            <p>
                                <strong>Tech stack:</strong>
                                <c:out value="${project.techStack}"/>
                            </p>
                        </c:if>

                        <a class="button"
                           href="${pageContext.request.contextPath}/projects?action=view&id=${project.id}">
                            View Details
                        </a>
                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

</body>
</html>

