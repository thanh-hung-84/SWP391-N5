<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Kích hoạt tài khoản - SWP391</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/custom.css">
    </head>
    <body>
        <jsp:include page="header.jsp"/>

        <div class="container" style="max-width:560px;padding:90px 20px 110px;text-align:center;">
            <c:choose>
                <c:when test="${activated}">
                    <div style="font-size:56px;color:#14b8a6;margin-bottom:18px;"><i class="fa fa-check-circle"></i></div>
                    <h2 style="font-weight:900;color:#0f172a;margin-bottom:12px;">Kích hoạt tài khoản thành công!</h2>
                    <p style="color:#64748b;margin-bottom:28px;">
                        Bạn có thể đăng nhập ngay bằng email và mật khẩu tạm thời đã được gửi trong email.
                    </p>
                    <a href="login.jsp" class="boxed-btn3">Đăng nhập ngay</a>
                </c:when>
                <c:otherwise>
                    <div style="font-size:56px;color:#ef4444;margin-bottom:18px;"><i class="fa fa-times-circle"></i></div>
                    <h2 style="font-weight:900;color:#0f172a;margin-bottom:12px;">Liên kết không hợp lệ hoặc đã hết hạn</h2>
                    <p style="color:#64748b;margin-bottom:28px;">
                        Liên kết kích hoạt chỉ có hiệu lực trong 3 ngày và chỉ dùng được một lần.
                        Vui lòng liên hệ quản trị viên để được cấp lại tài khoản.
                    </p>
                    <a href="home" class="boxed-btn3">Về trang chủ</a>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="footer.jsp"/>
    </body>
</html>
