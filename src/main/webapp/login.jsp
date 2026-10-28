<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | ProjectHub</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            padding: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f2ff, #eef3ff, #fff0f8);
            color: #241d46;
        }

        .login-wrapper {
            width: 100%;
            max-width: 1050px;
            min-height: 610px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: white;
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 28px 80px rgba(72, 55, 145, .16);
            animation: slideUp .6s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* LEFT PANEL */

        .welcome-panel {
            position: relative;
            overflow: hidden;
            padding: 42px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: white;
            background: linear-gradient(145deg, #7855f6, #6259ed 50%, #4088f7);
        }

        .welcome-panel::before {
            content: "";
            position: absolute;
            width: 320px;
            height: 320px;
            right: -160px;
            top: 90px;
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 50%;
            box-shadow:
                    0 0 0 35px rgba(255,255,255,.05),
                    0 0 0 70px rgba(255,255,255,.035);
        }

        .welcome-panel::after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            left: -100px;
            bottom: -110px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff70bd, #ffb18d);
            opacity: .3;
        }

        .brand,
        .welcome-content,
        .panel-footer {
            position: relative;
            z-index: 1;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 45px;
            height: 45px;
            display: grid;
            place-items: center;
            border-radius: 14px;
            background: rgba(255,255,255,.19);
            border: 1px solid rgba(255,255,255,.25);
            font-size: 26px;
        }

        .brand h2 {
            font-size: 23px;
            font-weight: 800;
            letter-spacing: -.8px;
        }

        .welcome-content {
            margin: 45px 0;
        }

        .eyebrow {
            display: inline-block;
            padding: 9px 13px;
            border-radius: 50px;
            border: 1px solid rgba(255,255,255,.25);
            background: rgba(255,255,255,.12);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1px;
            margin-bottom: 24px;
        }

        .welcome-content h1 {
            font-size: clamp(35px, 4vw, 47px);
            line-height: 1.16;
            letter-spacing: -2px;
            margin-bottom: 20px;
        }

        .welcome-content h1 span {
            color: #ffd2ef;
        }

        .welcome-content p {
            max-width: 370px;
            color: rgba(255,255,255,.83);
            font-size: 13px;
            line-height: 1.9;
        }

        .benefits {
            margin-top: 30px;
            display: grid;
            gap: 15px;
        }

        .benefit {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .benefit-icon {
            width: 35px;
            height: 35px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 11px;
            background: rgba(255,255,255,.16);
            font-size: 16px;
        }

        .panel-footer {
            font-size: 10px;
            color: rgba(255,255,255,.7);
        }

        /* RIGHT LOGIN FORM */

        .form-panel {
            padding: 45px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-heading {
            margin-bottom: 30px;
        }

        .form-badge {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 9px;
            background: #f0ebff;
            color: #7555ed;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .6px;
            margin-bottom: 18px;
        }

        .form-heading h1 {
            font-size: 31px;
            letter-spacing: -1.2px;
            margin-bottom: 10px;
        }

        .form-heading p {
            font-size: 13px;
            color: #8b86a3;
            line-height: 1.8;
        }

        .error-message {
            margin-bottom: 20px;
            padding: 13px 15px;
            border: 1px solid #ffd1dc;
            background: #fff0f4;
            color: #b42345;
            border-radius: 12px;
            font-size: 12px;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 21px;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            color: #393252;
            font-size: 12px;
            font-weight: 700;
        }

        .input-wrap {
            position: relative;
        }

        .input-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #9992b7;
            font-size: 16px;
            pointer-events: none;
        }

        .form-group input {
            width: 100%;
            height: 52px;
            padding: 0 48px 0 44px;
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
            color: #aaa5bd;
        }

        .form-group input:focus {
            background: #fff;
            border-color: #7955f5;
            box-shadow: 0 0 0 4px rgba(121,85,245,.1);
        }

        .password-toggle {
            position: absolute;
            top: 50%;
            right: 14px;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #7c70ae;
            font-family: inherit;
            font-size: 10px;
            font-weight: 800;
            cursor: pointer;
        }

        .submit-button {
            width: 100%;
            height: 53px;
            margin-top: 5px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(100deg, #7955f5, #586df5 65%, #4388f7);
            color: white;
            font-family: inherit;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 10px 24px rgba(104,85,235,.25);
            transition: .2s ease;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(104,85,235,.35);
        }

        .register-prompt {
            margin-top: 26px;
            text-align: center;
            color: #85809d;
            font-size: 12px;
        }

        .register-prompt a {
            color: #7555ed;
            font-weight: 800;
            text-decoration: none;
        }

        .register-prompt a:hover {
            color: #e34ca8;
        }

        .bottom-note {
            margin-top: 35px;
            padding-top: 20px;
            border-top: 1px solid #f0edf7;
            color: #a29cb7;
            text-align: center;
            font-size: 10px;
            line-height: 1.8;
        }

        @media (max-width: 800px) {
            .login-wrapper {
                max-width: 530px;
                grid-template-columns: 1fr;
            }

            .welcome-panel {
                padding: 30px;
            }

            .welcome-content {
                margin: 32px 0 25px;
            }

            .welcome-content h1 {
                font-size: 35px;
            }

            .form-panel {
                padding: 38px 32px;
            }

            .panel-footer {
                margin-top: 10px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 12px;
            }

            .login-wrapper {
                border-radius: 21px;
            }

            .welcome-panel {
                padding: 24px;
            }

            .welcome-content h1 {
                font-size: 31px;
            }

            .form-panel {
                padding: 30px 23px;
            }

            .form-heading h1 {
                font-size: 27px;
            }
        }
    </style>
</head>

<body>

<main class="login-wrapper">

    <section class="welcome-panel">

        <div class="brand">
            <div class="brand-icon">✦</div>
            <h2>ProjectHub</h2>
        </div>

        <div class="welcome-content">

            <div class="eyebrow">YOUR NEXT CHAPTER STARTS HERE</div>

            <h1>
                Welcome back.<br>
                Let's build<br>
                <span>something great.</span>
            </h1>

            <p>
                Your developer community is waiting.
                Sign in to reconnect with talented developers,
                discover opportunities and keep your ideas moving.
            </p>

            <div class="benefits">

                <div class="benefit">
                    <div class="benefit-icon">👨‍💻</div>
                    Discover developers and their work
                </div>

                <div class="benefit">
                    <div class="benefit-icon">🤝</div>
                    Grow your professional network
                </div>

                <div class="benefit">
                    <div class="benefit-icon">🚀</div>
                    Keep building your next big idea
                </div>

            </div>
        </div>

        <div class="panel-footer">
            © 2026 ProjectHub · Built for developers
        </div>

    </section>

    <section class="form-panel">

        <div class="form-heading">
            <div class="form-badge">✨ GOOD TO SEE YOU AGAIN</div>
            <h1>Sign in to ProjectHub</h1>
            <p>Enter your details to access your developer account.</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message" role="alert">
            ⚠ <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login"
              method="post">

            <div class="form-group">
                <label for="email">Email address</label>

                <div class="input-wrap">
                    <span class="input-icon">✉</span>

                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <div class="input-wrap">
                    <span class="input-icon">♙</span>

                    <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
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
            </div>

            <button type="submit" class="submit-button">
                Sign In to Your Account &nbsp; →
            </button>

        </form>

        <div class="register-prompt">
            New to ProjectHub?
            <a href="${pageContext.request.contextPath}/register">
                Create an account →
            </a>
        </div>

        <div class="bottom-note">
            Your next collaboration could start with one sign-in.<br>
            Make it happen with ProjectHub.
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
