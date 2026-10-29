<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 20px;
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
        }

        .container {
            max-width: 850px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        h1 {
            margin: 0;
            color: #1e293b;
        }

        .summary {
            margin-top: 10px;
            color: #64748b;
        }

        .button {
            display: inline-block;
            padding: 10px 16px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .notification {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 14px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.04);
        }

        .notification.unread {
            border-left: 5px solid #2563eb;
        }

        .message {
            margin: 0 0 12px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .meta {
            font-size: 13px;
            color: #64748b;
        }

        .badge {
            display: inline-block;
            margin-left: 8px;
            padding: 4px 8px;
            background: #dbeafe;
            color: #1d4ed8;
            border-radius: 12px;
            font-size: 12px;
        }

        .empty {
            background: white;
            padding: 35px 20px;
            text-align: center;
            border-radius: 10px;
            color: #64748b;
        }
    </style>
</head>

<body>
<div class="container">

    <div class="header">
        <div>
            <h1>Notifications</h1>
            <p class="summary">
                You have
                <strong><c:out value="${unreadCount}"/></strong>
                unread notification(s).
            </p>
        </div>

        <a class="button"
           href="${pageContext.request.contextPath}/dashboard.jsp">
            Back to Dashboard
        </a>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="empty">
                <h3>No notifications yet</h3>
                <p>Updates about your project activities will appear here.</p>
            </div>
        </c:when>

        <c:otherwise>

            <c:forEach var="notification" items="${notifications}">
                <div class="notification
        ${notification.read ? '' : 'unread'}">

                    <p class="message">
                        <c:out value="${notification.message}"/>

                        <c:if test="${not notification.read}">
                            <span class="badge">Unread</span>
                        </c:if>
                    </p>

                    <div class="meta">
                        Received:
                        <c:out value="${notification.createdAt}"/>
                    </div>

                    <c:if test="${not notification.read}">
                        <form action="${pageContext.request.contextPath}/notifications"
                              method="post"
                              style="margin-top: 10px;">

                            <input type="hidden" name="action" value="markAsRead">

                            <input type="hidden" name="notificationId"
                                   value="<c:out value='${notification.id}'/>">

                            <button type="submit" class="button">
                                Mark as Read
                            </button>
                        </form>
                    </c:if>

                </div>
            </c:forEach>


        </c:otherwise>
    </c:choose>

</div>
</body>
</html>