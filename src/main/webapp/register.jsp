<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join ProjectHub | Create Account</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --purple: #7955f5;
            --blue: #4776ff;
            --pink: #ff65b8;
            --dark: #211b45;
            --muted: #85849c;
        }

        body {
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
            background: #f5f4ff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 35px 20px;
            overflow-x: hidden;
        }

        .background-orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(2px);
            pointer-events: none;
            z-index: -1;
        }

        .orb-one {
            width: 340px;
            height: 340px;
            background: linear-gradient(135deg, #d9caff, #f7c8ed);
            top: -130px;
            left: -100px;
            opacity: .75;
        }

        .orb-two {
            width: 400px;
            height: 400px;
            background: linear-gradient(135deg, #c5d8ff, #e4ceff);
            right: -150px;
            bottom: -160px;
            opacity: .8;
        }

        .page-wrapper {
            width: 100%;
            max-width: 1080px;
            min-height: 650px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: #fff;
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 30px 90px rgba(70, 48, 145, .17);
            animation: appear .7s ease;
        }

        @keyframes appear {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* LEFT HERO PANEL */

        .hero-panel {
            position: relative;
            overflow: hidden;
            padding: 45px 42px;
            color: white;
            background: linear-gradient(
                    145deg,
                    #7655f7 0%,
                    #6658ed 42%,
                    #4779f8 100%
            );
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .hero-panel::before {
            content: "";
            position: absolute;
            width: 300px;
            height: 300px;
            border: 1px solid rgba(255,255,255,.18);
            border-radius: 50%;
            right: -140px;
            top: 100px;
            box-shadow:
                    0 0 0 35px rgba(255,255,255,.035),
                    0 0 0 70px rgba(255,255,255,.025);
        }

        .hero-panel::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff82ce, #ffbc9d);
            opacity: .18;
            bottom: -100px;
            left: -80px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
            z-index: 1;
        }

        .brand-icon {
            width: 46px;
            height: 46px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.2);
            border: 1px solid rgba(255,255,255,.3);
            border-radius: 15px;
            font-size: 25px;
            box-shadow: 0 8px 20px rgba(30,20,100,.12);
        }

        .brand-name {
            font-size: 23px;
            font-weight: 800;
            letter-spacing: -.8px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            margin: 55px 0;
        }

        .hero-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 50px;
            background: rgba(255,255,255,.13);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 24px;
        }

        .hero-label span {
            width: 7px;
            height: 7px;
            background: #7dffce;
            border-radius: 50%;
            box-shadow: 0 0 10px #7dffce;
        }

        .hero-content h1 {
            font-size: clamp(35px, 4vw, 48px);
            line-height: 1.15;
            letter-spacing: -2px;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .hero-content h1 .highlight {
            color: #ffd5f1;
        }

        .hero-content p {
            max-width: 380px;
            font-size: 14px;
            line-height: 1.9;
            color: rgba(255,255,255,.84);
        }

        .feature-list {
            display: grid;
            gap: 14px;
            margin-top: 32px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 13px;
            font-size: 13px;
            font-weight: 500;
            color: rgba(255,255,255,.95);
        }

        .feature-icon {
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: rgba(255,255,255,.15);
            border: 1px solid rgba(255,255,255,.16);
            border-radius: 11px;
            font-size: 16px;
        }

        .hero-footer {
            position: relative;
            z-index: 1;
            color: rgba(255,255,255,.72);
            font-size: 11px;
        }

        /* RIGHT REGISTRATION PANEL */

        .form-panel {
            padding: 45px 43px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-top {
            margin-bottom: 27px;
        }

        .welcome-tag {
            display: inline-block;
            padding: 7px 12px;
            color: #7555ed;
            background: #f0ebff;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .5px;
            margin-bottom: 17px;
        }

        .form-top h2 {
            color: var(--dark);
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -1.1px;
            margin-bottom: 10px;
        }

        .form-top p {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.7;
        }

        .message {
            padding: 13px 15px;
            margin-bottom: 18px;
            border-radius: 12px;
            font-size: 12px;
            line-height: 1.6;
        }

        .success-message {
            color: #137a4b;
            background: #e9fff3;
            border: 1px solid #b9f2d2;
        }

        .error-message {
            color: #b42345;
            background: #fff0f3;
            border: 1px solid #ffd0da;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            color: #35304f;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 9px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #9c96b8;
            font-size: 16px;
            pointer-events: none;
        }

        .form-group input {
            width: 100%;
            height: 51px;
            padding: 0 45px;
            border: 1.5px solid #e8e5f2;
            border-radius: 12px;
            outline: none;
            background: #fbfaff;
            color: #30294f;
            font-family: inherit;
            font-size: 13px;
            transition: .25s ease;
        }

        .form-group input::placeholder {
            color: #aaa5bc;
        }

        .form-group input:focus {
            background: white;
            border-color: var(--purple);
            box-shadow: 0 0 0 4px rgba(121,85,245,.10);
        }

        .password-toggle {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #8d86a8;
            font-family: inherit;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
        }

        .password-hint {
            font-size: 10px;
            color: #9993af;
            margin-top: 8px;
        }

        .submit-button {
            width: 100%;
            height: 53px;
            margin-top: 5px;
            border: none;
            border-radius: 12px;
            color: white;
            background: linear-gradient(100deg, #7955f5, #536ff5 65%, #4388f7);
            font-family: inherit;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 10px 23px rgba(104, 85, 235, .25);
            transition: transform .2s ease, box-shadow .2s ease;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(104, 85, 235, .34);
        }

        .submit-button:active {
            transform: translateY(0);
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 13px;
            margin: 24px 0;
            color: #aaa5bd;
            font-size: 11px;
        }

        .divider::before,
        .divider::after {
            content: "";
            height: 1px;
            flex: 1;
            background: #eeebf6;
        }

        .login-link {
            text-align: center;
            color: #817b99;
            font-size: 12px;
        }

        .login-link a {
            color: #7555ed;
            font-weight: 800;
            text-decoration: none;
        }

        .login-link a:hover {
            color: #e34ca8;
        }

        .terms {
            margin-top: 24px;
            color: #aaa5bb;
            font-size: 10px;
            line-height: 1.8;
            text-align: center;
        }

        @media (max-width: 850px) {
            .page-wrapper {
                max-width: 560px;
                grid-template-columns: 1fr;
            }

            .hero-panel {
                padding: 30px;
            }

            .hero-content {
                margin: 35px 0 25px;
            }

            .hero-content h1 {
                font-size: 36px;
            }

            .feature-list {
                grid-template-columns: 1fr 1fr;
            }

            .hero-footer {
                margin-top: 25px;
            }

            .form-panel {
                padding: 38px 32px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 14px;
            }

            .page-wrapper {
                border-radius: 22px;
            }

            .hero-panel {
                padding: 25px 23px;
            }

            .hero-content h1 {
                font-size: 32px;
            }

            .hero-content p {
                font-size: 13px;
            }

            .feature-list {
                grid-template-columns: 1fr;
            }

            .form-panel {
                padding: 30px 23px;
            }

            .form-top h2 {
                font-size: 27px;
            }
        }
    </style>
</head>

<body>

<div class="background-orb orb-one"></div>
<div class="background-orb orb-two"></div>

<main class="page-wrapper">

    <!-- LEFT COLORFUL HERO SECTION -->
    <section class="hero-panel">

        <div class="brand">
            <div class="brand-icon">✦</div>
            <div class="brand-name">ProjectHub</div>
        </div>

        <div class="hero-content">

            <div class="hero-label">
                <span></span>
                Your developer community
            </div>

            <h1>
                Build things.<br>
                Meet people.<br>
                <span class="highlight">Grow together.</span>
            </h1>

            <p>
                Your next big idea deserves a great team.
                Connect with developers, discover talent and
                turn your ideas into something amazing.
            </p>

            <div class="feature-list">

                <div class="feature-item">
                    <div class="feature-icon">👨‍💻</div>
                    <span>Discover talented developers</span>
                </div>

                <div class="feature-item">
                    <div class="feature-icon">🤝</div>
                    <span>Connect and collaborate</span>
                </div>

                <div class="feature-item">
                    <div class="feature-icon">🚀</div>
                    <span>Bring your projects to life</span>
                </div>

            </div>
        </div>

        <div class="hero-footer">
            © 2026 ProjectHub · Made for builders
        </div>

    </section>

    <!-- RIGHT REGISTRATION FORM -->
    <section class="form-panel">

        <div class="form-top">
            <div class="welcome-tag">✨ START YOUR JOURNEY</div>
            <h2>Create your account</h2>
            <p>Join the community and start building your future.</p>
        </div>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="message success-message">
            ✓ <%= request.getAttribute("successMessage") %>
        </div>
        <% } %>

        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="message error-message">
            ⚠ <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register"
              method="post">

            <div class="form-group">
                <label for="name">Full name</label>

                <div class="input-wrapper">
                    <span class="input-icon">♙</span>
                    <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Enter your full name"
                            autocomplete="name"
                            maxlength="100"
                            required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email address</label>

                <div class="input-wrapper">
                    <span class="input-icon">✉</span>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            maxlength="254"
                            required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Create password</label>

                <div class="input-wrapper">
                    <span class="input-icon">♙</span>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a strong password"
                            autocomplete="new-password"
                            minlength="8"
                            required>

                    <button
                            type="button"
                            class="password-toggle"
                            id="togglePassword"
                            aria-label="Show password"
                            aria-pressed="false">
                        SHOW
                    </button>
                </div>

                <div class="password-hint">
                    Use at least 8 characters for your password.
                </div>
            </div>

            <button type="submit" class="submit-button">
                Create My Account&nbsp; →
            </button>

        </form>

        <div class="divider">Already part of the community?</div>

        <div class="login-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">
                Sign in →
            </a>
        </div>

        <div class="terms">
            By creating an account, you agree to use ProjectHub
            respectfully and responsibly.
        </div>

    </section>

</main>

<script>
    const passwordInput = document.getElementById("password");
    const toggleButton = document.getElementById("togglePassword");

    toggleButton.addEventListener("click", function () {
        const isPassword = passwordInput.type === "password";

        passwordInput.type = isPassword ? "text" : "password";
        toggleButton.textContent = isPassword ? "HIDE" : "SHOW";
        toggleButton.setAttribute("aria-pressed", String(isPassword));
        toggleButton.setAttribute(
            "aria-label",
            isPassword ? "Hide password" : "Show password"
        );
    });
</script>

</body>
</html>
