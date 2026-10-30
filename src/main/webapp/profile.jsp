<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projecthub.entity.User" %>
<%@ page import="com.projecthub.entity.Skill" %>
<%@ page import="java.util.List" %>

<%
    User profileUser = (User) request.getAttribute("profileUser");
    List<Skill> allSkills = (List<Skill>) request.getAttribute("allSkills");

    if (allSkills == null) {
        allSkills = java.util.Collections.emptyList();
    }
    java.util.Set<Skill> mySkills =
            (java.util.Set<Skill>) request.getAttribute("mySkills");

    if (mySkills == null) {
        mySkills = java.util.Collections.emptySet();
    }

    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }

    String contextPath = request.getContextPath();
    boolean updated = "true".equals(request.getParameter("updated"));
    String error = (String) request.getAttribute("error");

    String profileName = profileUser.getName();
    if (profileName == null || profileName.trim().isEmpty()) {
        profileName = "Developer";
    }
    String avatarLetter = profileName.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | ProjectHub</title>

    <style>
        :root {
            --purple: #6d28d9;
            --blue: #2563eb;
            --pink: #ec4899;
            --ink: #242044;
            --muted: #74718e;
            --line: #e9e6f7;
            --shadow: 0 18px 45px rgba(49, 35, 110, .10);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            color: var(--ink);
            background:
                    radial-gradient(circle at 8% 10%, rgba(236,72,153,.11), transparent 24rem),
                    radial-gradient(circle at 94% 16%, rgba(99,102,241,.13), transparent 28rem),
                    #f7f7ff;
        }

        header {
            position: sticky;
            top: 0;
            z-index: 5;
            padding: 16px clamp(18px, 6vw, 88px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            background: rgba(255,255,255,.9);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(226,223,250,.9);
            box-shadow: 0 5px 22px rgba(55,40,110,.05);
        }

        .brand {
            font-size: 25px;
            font-weight: 850;
            letter-spacing: -.8px;
            text-decoration: none;
            background: linear-gradient(100deg, var(--purple), var(--blue) 58%, var(--pink));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        nav { display: flex; gap: 9px; align-items: center; flex-wrap: wrap; }
        nav a {
            padding: 10px 14px;
            border-radius: 11px;
            color: #5b21b6;
            text-decoration: none;
            font-size: 14px;
            font-weight: 750;
            transition: .2s ease;
        }
        nav a:hover { background: #f0eaff; transform: translateY(-1px); }
        nav a.logout {
            color: white;
            background: linear-gradient(110deg, var(--purple), var(--blue));
            box-shadow: 0 7px 16px rgba(91,33,182,.18);
        }
        nav a.logout:hover { box-shadow: 0 10px 22px rgba(91,33,182,.25); }

        .container {
            width: min(1020px, 100%);
            margin: 38px auto 65px;
            padding: 0 22px;
        }

        .hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 23px;
            padding: clamp(25px, 5vw, 42px);
            color: white;
            border-radius: 27px;
            background: linear-gradient(118deg, #5b21b6 0%, #4f46e5 55%, #0ea5e9 100%);
            box-shadow: 0 22px 48px rgba(79,70,229,.23);
        }
        .hero::after {
            content: "";
            position: absolute;
            width: 240px;
            height: 240px;
            border-radius: 50%;
            right: -50px;
            top: -120px;
            background: rgba(255,255,255,.11);
            pointer-events: none;
        }

        .avatar {
            position: relative;
            z-index: 1;
            flex: 0 0 88px;
            width: 88px;
            height: 88px;
            display: grid;
            place-items: center;
            border: 3px solid rgba(255,255,255,.7);
            border-radius: 26px;
            background: linear-gradient(145deg, #f9a8d4, #c4b5fd 55%, #93c5fd);
            color: #422079;
            font-size: 36px;
            font-weight: 850;
            box-shadow: 0 10px 24px rgba(26,16,70,.18);
        }
        .hero-copy { position: relative; z-index: 1; }
        .eyebrow {
            margin: 0 0 8px;
            color: rgba(255,255,255,.8);
            text-transform: uppercase;
            letter-spacing: 1.8px;
            font-size: 11px;
            font-weight: 850;
        }
        .hero h1 {
            margin: 0 0 9px;
            font-size: clamp(27px, 4vw, 38px);
            letter-spacing: -.9px;
        }
        .hero p:last-child {
            margin: 0;
            color: rgba(255,255,255,.88);
            line-height: 1.65;
        }

        .form-card {
            margin-top: 23px;
            padding: clamp(22px, 4vw, 36px);
            border: 1px solid var(--line);
            border-radius: 25px;
            background: rgba(255,255,255,.96);
            box-shadow: var(--shadow);
        }
        .section-heading {
            margin-bottom: 25px;
        }
        .section-heading h2 {
            margin: 0 0 8px;
            color: #342269;
            font-size: 23px;
            letter-spacing: -.4px;
        }
        .section-heading p {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.65;
        }

        .message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 14px 16px;
            border-radius: 13px;
            margin-bottom: 20px;
            line-height: 1.5;
            font-size: 14px;
            font-weight: 650;
        }
        .success { color: #166534; background: #ecfdf3; border: 1px solid #bbf7d0; }
        .error { color: #9f1239; background: #fff1f2; border: 1px solid #fecdd3; }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0 20px;
        }
        .field { margin-bottom: 20px; min-width: 0; }
        .field.full { grid-column: 1 / -1; }
        label {
            display: flex;
            align-items: center;
            gap: 7px;
            margin: 0 0 9px;
            color: #39305f;
            font-size: 13px;
            font-weight: 800;
        }
        .optional {
            color: #8c88a5;
            font-size: 11px;
            font-weight: 650;
        }
        input, textarea {
            display: block;
            width: 100%;
            border: 1px solid #dedbed;
            border-radius: 12px;
            padding: 13px 14px;
            background: #fcfbff;
            color: var(--ink);
            font: inherit;
            font-size: 14px;
            transition: border-color .2s, box-shadow .2s, background .2s;
        }
        input { min-height: 47px; }
        textarea { min-height: 130px; resize: vertical; line-height: 1.6; }
        input::placeholder, textarea::placeholder { color: #aaa6bf; }
        input:hover, textarea:hover { border-color: #c7baf4; }
        input:focus, textarea:focus {
            outline: none;
            border-color: #8b5cf6;
            background: white;
            box-shadow: 0 0 0 4px rgba(139,92,246,.12);
        }
        .field-note {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 7px;
            color: #9691ac;
            font-size: 11px;
        }

        .form-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            padding-top: 7px;
            border-top: 1px solid #f0eef9;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 12px 14px;
            border-radius: 11px;
            color: #5b21b6;
            text-decoration: none;
            font-size: 14px;
            font-weight: 750;
            transition: background .2s;
        }
        .back-link:hover { background: #f2edff; }
        .save-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 47px;
            padding: 13px 22px;
            border: 0;
            border-radius: 12px;
            color: white;
            background: linear-gradient(110deg, var(--purple), var(--blue));
            box-shadow: 0 8px 18px rgba(79,70,229,.22);
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            transition: transform .2s, box-shadow .2s;
        }
        .save-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 23px rgba(79,70,229,.29);
        }
        .save-button:active { transform: translateY(0); }
        a:focus-visible, button:focus-visible {
            outline: 3px solid #a5b4fc;
            outline-offset: 3px;
        }

        @media (max-width: 650px) {
            header { padding: 14px 5%; }
            .brand { font-size: 22px; }
            nav { gap: 3px; }
            nav a { padding: 9px 10px; font-size: 13px; }
            .container { margin: 24px auto 45px; padding: 0 15px; }
            .hero { align-items: flex-start; gap: 16px; border-radius: 22px; }
            .avatar { flex-basis: 65px; width: 65px; height: 65px; border-radius: 20px; font-size: 28px; }
            .form-card { border-radius: 22px; }
            .form-grid { grid-template-columns: 1fr; }
            .field.full { grid-column: auto; }
            .form-actions { align-items: stretch; flex-direction: column-reverse; }
            .save-button, .back-link { width: 100%; justify-content: center; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { transition-duration: .01ms !important; }
        }
    </style>
</head>

<body>
<header>
    <a class="brand" href="<%= contextPath %>/dashboard.jsp">ProjectHub</a>
    <nav aria-label="Main navigation">
        <a href="<%= contextPath %>/dashboard.jsp">Dashboard</a>
        <a class="logout" href="<%= contextPath %>/logout">Log Out</a>
    </nav>
</header>

<main class="container">
    <section class="hero" aria-labelledby="profile-title">
        <div class="avatar" aria-hidden="true"><%= escapeHtml(avatarLetter) %></div>
        <div class="hero-copy">
            <p class="eyebrow">Your developer space</p>
            <h1 id="profile-title">My Profile</h1>
            <p>Make your profile yours. Share your story, highlight your links, and help other developers get to know you.</p>
        </div>
    </section>

    <section class="form-card" aria-labelledby="edit-profile-heading">
        <div class="section-heading">
            <h2 id="edit-profile-heading">Profile details</h2>
            <p>Fields marked with * are required. Your profile information can help other developers connect with you.</p>
        </div>

        <% if (updated) { %>
        <div class="message success" role="status">
            <span aria-hidden="true">✓</span>
            <span>Profile updated successfully! Your changes have been saved.</span>
        </div>
        <% } %>

        <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="message error" role="alert">
            <span aria-hidden="true">!</span>
            <span><%= escapeHtml(error) %></span>
        </div>
        <% } %>

        <form action="<%= contextPath %>/profile" method="post">
            <div class="form-grid">
                <div class="field full">
                    <label for="name">Full name <span aria-hidden="true">*</span></label>
                    <input
                            type="text"
                            id="name"
                            name="name"
                            maxlength="100"
                            autocomplete="name"
                            value="<%= escapeHtml(profileUser.getName()) %>"
                            placeholder="Enter your full name"
                            required
                    >
                </div>

                <div class="field full">
                    <label for="bio">About you <span class="optional">Optional</span></label>
                    <textarea
                            id="bio"
                            name="bio"
                            maxlength="1000"
                            placeholder="Tell the community about your interests, skills, or what you're building..."
                    ><%= escapeHtml(profileUser.getBio()) %></textarea>
                    <div class="field-note">
                        <span>A short introduction helps people connect with you.</span>
                        <span id="bio-count">0 / 1000</span>
                    </div>
                </div>

                <div class="field">
                    <label for="githubUrl">GitHub profile <span class="optional">Optional</span></label>
                    <input
                            type="url"
                            id="githubUrl"
                            name="githubUrl"
                            maxlength="255"
                            autocomplete="url"
                            placeholder="https://github.com/yourusername"
                            value="<%= escapeHtml(profileUser.getGithubUrl()) %>"
                    >
                </div>

                <div class="field">
                    <label for="linkedinUrl">LinkedIn profile <span class="optional">Optional</span></label>
                    <input
                            type="url"
                            id="linkedinUrl"
                            name="linkedinUrl"
                            maxlength="255"
                            autocomplete="url"
                            placeholder="https://www.linkedin.com/in/yourusername"
                            value="<%= escapeHtml(profileUser.getLinkedinUrl()) %>"
                    >
                </div>
            </div>

            <div class="form-actions">
                <a class="back-link" href="<%= contextPath %>/dashboard.jsp">← Back to dashboard</a>
                <button class="save-button" type="submit"><span aria-hidden="true">✓</span> Save changes</button>
            </div>
        </form>
    </section>
    <section class="form-card" aria-labelledby="skills-heading">
        <div class="section-heading">
            <h2 id="skills-heading">My Technical Skills</h2>
            <p>Select a skill to add it to your developer profile.</p>
        </div>
        <div class="field">
            <label>Skills on your profile</label>

            <% if (mySkills.isEmpty()) { %>
            <p>You haven't added any skills yet.</p>
            <% } else { %>
            <div>
                <% for (Skill skill : mySkills) { %>
                <span style="display:inline-block; margin:4px; padding:8px 12px;
                                     background:#eee8ff; border-radius:16px;">
                            <%= escapeHtml(skill.getName()) %>
                        </span>
                <% } %>
            </div>
            <% } %>
        </div>

        <% if (allSkills.isEmpty()) { %>
        <p>No skills are available yet. Please try again after skills
            have been added to the database.</p>
        <% } else { %>
        <form action="<%= contextPath %>/profile" method="post">
            <input type="hidden" name="action" value="addSkill">

            <div class="field">
                <label for="skillId">Choose a skill</label>

                <select id="skillId" name="skillId" required>
                    <option value="">-- Select a skill --</option>

                    <% for (Skill skill : allSkills) { %>
                    <option value="<%= skill.getId() %>">
                        <%= escapeHtml(skill.getName()) %>
                    </option>
                    <% } %>
                </select>
            </div>

            <button class="save-button" type="submit">
                + Add Skill
            </button>
        </form>
        <% } %>
    </section>
</main>

<script>
    (function () {
        const bio = document.getElementById("bio");
        const count = document.getElementById("bio-count");

        function updateBioCount() {
            count.textContent = bio.value.length + " / 1000";
        }

        bio.addEventListener("input", updateBioCount);
        updateBioCount();
    })();
</script>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>

</body>
</html>
