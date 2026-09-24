<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng nhập Admin - SWP391</title>
        <style>
            *{box-sizing:border-box}
            html,body{height:100%;margin:0;font-family:Arial,sans-serif}
            body{
                display:flex;align-items:center;justify-content:center;
                background:radial-gradient(circle at 15% 15%,rgba(37,99,235,.22),transparent 30%),
                           radial-gradient(circle at 85% 85%,rgba(20,184,166,.18),transparent 30%),#0f172a;
            }
            .admin-login-card{
                width:380px;max-width:92vw;background:#fff;border-radius:20px;
                box-shadow:0 30px 70px rgba(0,0,0,.30);padding:36px 32px;
            }
            .admin-login-card h1{margin:0 0 6px;font-size:22px;font-weight:900;color:#0f172a;}
            .admin-login-card p{margin:0 0 22px;font-size:13px;color:#64748b;}
            .admin-login-card input{
                width:100%;padding:12px 14px;margin-bottom:12px;border-radius:10px;
                border:1px solid #e2e8f0;background:#f8fafc;font-size:14px;outline:none;
            }
            .admin-login-card input:focus{border-color:#60a5fa;background:#fff;}
            .admin-login-card button{
                width:100%;padding:13px;border:0;border-radius:10px;margin-top:6px;
                background:linear-gradient(135deg,#2563eb,#14b8a6);color:#fff;
                font-weight:800;font-size:13px;letter-spacing:.5px;text-transform:uppercase;
                cursor:pointer;
            }
            .admin-error{
                background:#fef2f2;color:#dc2626;border:1px solid #fecaca;
                border-radius:10px;padding:10px 14px;font-size:13px;margin-bottom:14px;
            }
        </style>
    </head>
    <body>
        <div class="admin-login-card">
            <h1>Đăng nhập Quản trị viên</h1>
            <p>Khu vực dành cho Admin - tạo tài khoản nhân viên mới.</p>

            <c:if test="${not empty error}">
                <div class="admin-error">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/login">
                <input type="text" name="username" placeholder="Tên đăng nhập" value="${param.username}" required autofocus/>
                <input type="password" name="password" placeholder="Mật khẩu" required/>
                <button type="submit">Đăng nhập</button>
            </form>
            <div style="margin-top:16px;text-align:center;">
                <a href="${pageContext.request.contextPath}/home" style="color:#64748b;font-size:13px;">&larr; Về trang chủ</a>
            </div>
        </div>
    </body>
</html>
