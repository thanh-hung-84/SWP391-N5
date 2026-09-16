<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>${empty pageTitle ? 'Phỏng vấn' : pageTitle} - HR Tools</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/interview.css">
    </head>
    <body class="iv-body">
        <div class="iv-shell">
            <aside class="iv-sidebar">
                <div class="iv-logo">JOB<span>BOARD</span> · HR</div>
                <nav class="iv-nav">
                    <a href="${pageContext.request.contextPath}/interview-schedule"
                       class="${currentNav == 'schedule' ? 'active' : ''}">📅 Lên lịch phỏng vấn</a>
                    <a href="${pageContext.request.contextPath}/interview-calendar"
                       class="${currentNav == 'calendar' ? 'active' : ''}">🗓️ Lịch phỏng vấn</a>
                    <a href="${pageContext.request.contextPath}/barem"
                       class="${currentNav == 'barem' ? 'active' : ''}">📋 Barem đánh giá</a>
                </nav>
                <div class="iv-sidebar-footer">
                    Đăng nhập với<br>
                    <b style="color:#fff">${sessionScope.staffName}</b> (${sessionScope.roleName})<br>
                    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                </div>
            </aside>
            <main class="iv-main">
