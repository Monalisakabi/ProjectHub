<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty project ? 'Edit Project' : 'Create Project'} | ProjectHub</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 16px;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.07);
        }

        h1 {
            margin-top: 0;
            color: #172554;
        }

        .subtitle {
            color: #64748b;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            font: inherit;
            margin-bottom: 20px;
        }

        textarea {
            min-height: 140px;
            resize: vertical;
        }

        input:focus, textarea:focus, select:focus {
            outline: 2px solid #93c5fd;
            border-color: #2563eb;
        }

        .button {
            display: inline-block;
            padding: 12px 18px;
            border: none;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
        }

        .cancel {
            margin-left: 10px;
            color: #475569;
            text-decoration: none;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            border-radius: 7px;
            padding: 12px;
            margin-bottom: 20px;
        }

        .hint {
            display: block;
            color: #64748b;
            font-size: 13px;
            margin-top: -14px;
            margin-bottom: 18px;
        }

        @media (max-width: 500px) {
            .container {
                padding: 22px;
            }

            .cancel {
                display: inline-block;
                margin: 15px 0 0;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <h1>
        <c:choose>
            <c:when test="${not empty project}">Edit Your Project</c:when>
            <c:otherwise>Create a Project</c:otherwise>
        </c:choose>
    </h1>

    <p class="subtitle">
        Showcase your work, share your technology stack, and let other developers discover your project.
    </p>

    <c:if test="${not empty errorMessage}">
        <div class="error">
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/projects" method="post">

        <c:choose>
            <c:when test="${not empty project}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${project.id}">
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="create">
            </c:otherwise>
        </c:choose>

        <label for="title">Project Title *</label>
        <input
                type="text"
                id="title"
                name="title"
                maxlength="150"
                value="<c:out value='${project.title}'/>"
                placeholder="e.g. Student Management System"
                required>

        <label for="description">Project Description *</label>
        <textarea
                id="description"
                name="description"
                maxlength="2000"
                placeholder="Describe what your project does..."
                required><c:out value="${project.description}"/></textarea>

        <label for="techStack">Technology Stack</label>
        <input
                type="text"
                id="techStack"
                name="techStack"
                maxlength="500"
                value="<c:out value='${project.techStack}'/>"
                placeholder="e.g. Java, JSP, Hibernate, MySQL">

        <label for="projectType">Project Type *</label>
        <select id="projectType" name="projectType" required>
            <option value="">Select Project Type</option>

            <option value="ACADEMIC"
            ${project.projectType == 'ACADEMIC' ? 'selected' : ''}>
                Academic
            </option>

            <option value="PERSONAL"
            ${project.projectType == 'PERSONAL' ? 'selected' : ''}>
                Personal
            </option>

            <option value="OPEN_SOURCE"
            ${project.projectType == 'OPEN_SOURCE' ? 'selected' : ''}>
                Open Source
            </option>

            <option value="RESEARCH"
            ${project.projectType == 'RESEARCH' ? 'selected' : ''}>
                Research
            </option>
        </select>

        <label for="status">Project Status *</label>
        <select id="status" name="status" required>
            <option value="PUBLISHED"
            ${empty project.status || project.status == 'PUBLISHED' ? 'selected' : ''}>
                Published
            </option>

            <option value="LOOKING_FOR_MEMBERS"
            ${project.status == 'LOOKING_FOR_MEMBERS' ? 'selected' : ''}>
                Looking for Team Members
            </option>
        </select>

        <label for="requiredMembers">Required Team Members *</label>
        <input
                type="number"
                id="requiredMembers"
                name="requiredMembers"
                min="1"
                max="100"
                value="${project.requiredMembers}"
                placeholder="e.g. 3"
                required>

        <label for="requiredSkills">Required Skills</label>

        <select
                id="requiredSkills"
                name="requiredSkillIds"
                multiple
                size="6">

            <c:forEach var="skill" items="${availableSkills}">
                <option value="${skill.id}"
                        <c:forEach var="selectedSkill" items="${project.requiredSkills}">
                            <c:if test="${selectedSkill.id == skill.id}">selected</c:if>
                        </c:forEach>>
                    <c:out value="${skill.name}"/>
                </option>
            </c:forEach>

        </select>

        <span class="hint">
            Hold Ctrl (Windows) to select multiple skills.
        </span>

        <label for="githubUrl">GitHub Repository URL</label>
        <input
                type="url"
                id="githubUrl"
                name="githubUrl"
                maxlength="500"
                value="<c:out value='${project.githubUrl}'/>"
                placeholder="https://github.com/username/project">

        <label for="demoUrl">Live Demo URL</label>
        <input
                type="url"
                id="demoUrl"
                name="demoUrl"
                maxlength="500"
                value="<c:out value='${project.demoUrl}'/>"
                placeholder="https://example.com">

        <button type="submit" class="button">
            <c:choose>
                <c:when test="${not empty project}">Save Changes</c:when>
                <c:otherwise>Publish Project</c:otherwise>
            </c:choose>
        </button>

        <a class="cancel"
           href="${pageContext.request.contextPath}/projects">
            Cancel
        </a>

    </form>
</div>

</body>
</html>