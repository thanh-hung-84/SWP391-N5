<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng nhập - SWP391 HR</title>
        <style>
            :root {
                --ink: #172018;
                --paper: #f4f0e5;
                --accent: #e85d2a;
                --forest: #244f3b;
                --line: rgba(23, 32, 24, .16);
            }
            * { box-sizing: border-box; }
            body {
                min-height: 100vh;
                margin: 0;
                display: grid;
                place-items: center;
                padding: 28px;
                color: var(--ink);
                font-family: "Trebuchet MS", sans-serif;
                background:
                    radial-gradient(circle at 15% 18%, rgba(232, 93, 42, .22), transparent 26%),
                    linear-gradient(135deg, #173c31 0 42%, #e8dfc8 42% 100%);
            }
            .login-shell {
                width: min(920px, 100%);
                min-height: 560px;
                display: grid;
                grid-template-columns: 1.05fr .95fr;
                overflow: hidden;
                border: 1px solid rgba(255,255,255,.45);
                border-radius: 28px;
                background: var(--paper);
                box-shadow: 0 30px 80px rgba(15, 38, 30, .28);
            }
            .brand-panel {
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 52px;
                color: #fff8e8;
                background: var(--forest);
                isolation: isolate;
            }
            .brand-panel::after {
                content: "";
                position: absolute;
                right: -75px;
                bottom: -80px;
                width: 260px;
                height: 260px;
                border: 52px solid rgba(232, 93, 42, .75);
                border-radius: 50%;
                z-index: -1;
            }
            .brand { font-weight: 900; letter-spacing: .14em; }
            .brand span { color: #ff9a68; }
            .brand-panel h1 {
                max-width: 420px;
                margin: 0;
                font: 700 clamp(42px, 6vw, 70px)/.95 Georgia, serif;
                letter-spacing: -.04em;
            }
            .brand-panel p { max-width: 390px; margin: 20px 0 0; line-height: 1.7; color: #dce6dc; }
            .access-note { font-size: 13px; color: #b8cabd; }
            .form-panel { display: grid; align-content: center; padding: 54px; }
            .eyebrow { color: var(--accent); font-weight: 900; letter-spacing: .12em; text-transform: uppercase; }
            h2 { margin: 10px 0 8px; font: 700 38px/1.1 Georgia, serif; }
            .intro { margin: 0 0 30px; color: #647066; line-height: 1.6; }
            label { display: block; margin: 16px 0 7px; font-size: 14px; font-weight: 800; }
            input {
                width: 100%;
                padding: 14px 15px;
                border: 1px solid var(--line);
                border-radius: 11px;
                background: rgba(255,255,255,.68);
                color: var(--ink);
                font: inherit;
                outline: none;
            }
            input:focus { border-color: var(--accent); box-shadow: 0 0 0 4px rgba(232, 93, 42, .13); }
            button {
                width: 100%;
                margin-top: 24px;
                padding: 14px;
                border: 0;
                border-radius: 11px;
                color: white;
                background: var(--accent);
                font: 900 14px "Trebuchet MS", sans-serif;
                letter-spacing: .06em;
                cursor: pointer;
            }
            button:hover { background: #cb471d; transform: translateY(-1px); }
            .error { margin: 0 0 18px; padding: 12px 14px; border-radius: 10px; color: #8d2415; background: #ffe0d7; }
            .home-link { display: inline-block; margin-top: 20px; color: var(--forest); font-size: 14px; font-weight: 800; text-decoration: none; }
            @media (max-width: 760px) {
                body { padding: 16px; background: #173c31; }
                .login-shell { grid-template-columns: 1fr; }
                .brand-panel { min-height: 280px; padding: 34px; }
                .brand-panel h1 { font-size: 46px; }
                .form-panel { padding: 38px 30px 44px; }
            }
        </style>
    </head>
    <body>
        <main class="login-shell">
            <section class="brand-panel">
                <div class="brand">JOB<span>BOARD</span> / HR</div>
                <div>
                    <h1>Một tài khoản, đúng luồng công việc.</h1>
                    <p>Ứng viên tiếp tục vào trang tuyển dụng; nhân viên, HR và quản lý được chuyển tới khu vực hồ sơ phù hợp.</p>
                </div>
                <div class="access-note">SWP391 Human Resources Workspace</div>
            </section>
            <section class="form-panel">
                <span class="eyebrow">Đăng nhập hệ thống</span>
                <h2>Chào mừng trở lại</h2>
                <p class="intro">Sử dụng email và mật khẩu đã được cấp trong hệ thống.</p>

                <c:if test="${not empty error}">
                    <div class="error"><c:out value="${error}"/></div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" value="<c:out value='${username}'/>" autocomplete="username" required autofocus>
                    <label for="password">Mật khẩu</label>
                    <input id="password" type="password" name="password" autocomplete="current-password" required>
                    <button type="submit">Đăng nhập</button>
                </form>
                <a class="home-link" href="${pageContext.request.contextPath}/home">Quay lại trang chủ</a>
            </section>
        </main>
    </body>
</html>
