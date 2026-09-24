<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Đăng nhập</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <style>
*{box-sizing:border-box}html,body{min-height:100%;margin:0}body{font-family:"Roboto",Arial,sans-serif;background:radial-gradient(circle at 15% 15%,rgba(37,99,235,.22),transparent 30%),radial-gradient(circle at 85% 85%,rgba(20,184,166,.18),transparent 30%),#0f172a;overflow-x:hidden;min-height:100vh;display:flex;align-items:center;justify-content:center}.container{width:420px;max-width:94vw;margin:7vh auto;background:#fff;border-radius:24px;overflow:hidden;box-shadow:0 30px 80px rgba(0,0,0,.30)}form{background:#fff;display:flex;align-items:center;justify-content:center;flex-direction:column;padding:45px 45px;text-align:center}form h1{font-size:28px;margin:0 0 8px;color:#0f172a;font-weight:900}form p{font-size:14px;color:#64748b;margin:0 0 20px}input{background:#f8fafc;border:1px solid #e2e8f0;padding:13px 15px;margin:6px 0;width:100%;border-radius:10px;font-size:14px;color:#334155;outline:none;transition:.2s}input:focus{background:#fff;border-color:#60a5fa;box-shadow:0 0 0 4px rgba(37,99,235,.10)}button{border-radius:10px;border:0;background:linear-gradient(135deg,#2563eb,#3b82f6);color:#fff;font-size:12px;font-weight:800;padding:13px 30px;letter-spacing:.7px;text-transform:uppercase;transition:.2s;cursor:pointer;margin:14px 0 6px;width:100%;box-shadow:0 8px 18px rgba(37,99,235,.22)}button:hover{transform:translateY(-1px);box-shadow:0 12px 24px rgba(37,99,235,.28)}a{color:#2563eb;font-size:14px;text-decoration:none}a:hover{text-decoration:underline}#notificationTab{position:fixed;top:22px;right:22px;background:#0f766e;color:#fff;padding:13px 18px;border-radius:12px;box-shadow:0 12px 30px rgba(15,118,110,.28);z-index:1000}.signup-note{margin-top:14px;font-size:12px;color:#94a3b8}
</style>
    </head>
    <body>
        <c:if test="${not empty param.success}">
            <div id="notificationTab">${param.success}</div>
        </c:if>
        <c:if test="${status!=null}">
            <div id="notificationTab">${status}</div>
        </c:if>
        <div class="container">
            <form action="login" method="post" autocomplete="off">
                <h1>Đăng nhập</h1>
                <p>Sử dụng tài khoản được cấp bởi quản trị viên.</p>
                <c:if test="${not empty error}">
                    <div style="color:#dc2626;font-size:13px;margin-bottom:10px;">${error}</div>
                </c:if>
                <input type="text" name="email" placeholder="Email" value="${emailInput}" required />
                <input type="password" name="password" placeholder="Mật khẩu" required />
                <button type="submit">Đăng nhập</button>
                <a href="<%= request.getContextPath() %>/forget_password.jsp">Quên mật khẩu?</a>
                <div class="signup-note">Chưa có tài khoản? Vui lòng liên hệ quản trị viên để được cấp tài khoản.</div>
                <div class="signup-note"><a href="<%= request.getContextPath() %>/admin/login">Đăng nhập với quyền quản trị viên</a></div>
                <div class="signup-note"><a href="<%= request.getContextPath() %>/home">&larr; Về trang chủ</a></div>
            </form>
        </div>
        <script>
            window.addEventListener('DOMContentLoaded', function () {
                var noti = document.getElementById('notificationTab');
                if (noti) {
                    setTimeout(function () {
                        noti.style.display = "none";
                    }, 4000);
                }
            });
        </script>
    </body>
</html>
