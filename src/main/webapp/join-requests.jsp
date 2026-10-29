
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Requests | ProjectHub</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #1e293b;
        }

        header {
            background: #172554;
            color: white;
            padding: 22px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 18px;
        }

        main {
            max-width: 950px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .request-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin: 18px 0;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);
        }

        .status {
            font-weight: bold;
        }

        .pending {
            color: #b45309;
        }

        .accepted {
            color: #15803d;
        }

        .rejected {
            color: #b91c1c;
        }

        .button {
            border: none;
            border-radius: 6px;
            padding: 10px 16px;
            color: white;
            cursor: pointer;
            font-size: 14px;
            margin: 8px 8px 0 0;
        }

        .accept {
            background: #15803d;
        }

        .reject {
            background: #dc2626;
        }

        .muted {
            color: #64748b;
        }

        .empty {
            background: white;
            padding: 28px;
            border-radius: 12px;
            text-align: center;
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
    <h1>Join Requests</h1>

    <c:if test="${not empty project}">
        <h3>Project: <c:out value="${project.title}"/></h3>
    </c:if>

    <c:choose>
        <c:when test="${empty joinRequests}">
            <div class="empty">
                <h3>No join requests yet</h3>
                <p class="muted">
                    Requests to join this project will appear here.
                </p>
            </div>
        </c:when>

        <c:otherwise>
            <c:forEach var="joinRequest" items="${joinRequests}">
                <div class="request-card">

                    <h3>
                        <c:out value="${joinRequest.user.name}"/>
                    </h3>

                    <p class="muted">
                        Requested on:
                        <c:out value="${joinRequest.createdAt}"/>
                    </p>

                    <p>
                        Status:
                        <span class="status
                            ${joinRequest.status == 'PENDING' ? 'pending' :
                              joinRequest.status == 'ACCEPTED' ? 'accepted' : 'rejected'}">
                            <c:out value="${joinRequest.status}"/>
                        </span>
                    </p>

                    <c:if test="${joinRequest.status == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/join-requests"
                              method="post"
                              style="display: inline;">

                            <input type="hidden" name="action" value="process">

                            <input type="hidden"
                                   name="requestId"
                                   value="<c:out value='${joinRequest.id}'/>">

                            <input type="hidden" name="decision" value="ACCEPTED">

                            <button type="submit" class="button accept">
                                Accept
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/join-requests"
                              method="post"
                              style="display: inline;">

                            <input type="hidden" name="action" value="process">

                            <input type="hidden"
                                   name="requestId"
                                   value="<c:out value='${joinRequest.id}'/>">

                            <input type="hidden" name="decision" value="REJECTED">

                            <button type="submit" class="button reject">
                                Reject
                            </button>
                        </form>
                    </c:if>

                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <p>
        <a href="${pageContext.request.contextPath}/projects">
            ← Back to Projects
        </a>
    </p>
</main>

</body>
</html>

