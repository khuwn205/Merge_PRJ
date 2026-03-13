<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hòm thư cá nhân</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; padding: 20px; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h2, h3 { color: #2c3e50; }
        .nav-links { margin-bottom: 20px; }
        .nav-links a { text-decoration: none; padding: 8px 15px; background: #007bff; color: white; border-radius: 5px; margin-right: 10px; }
        .nav-links a:hover { background: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; color: #495057; text-transform: uppercase; font-size: 13px; }
        tr:hover { background-color: #f1f1f1; }
        .action-link { color: #28a745; font-weight: bold; text-decoration: none; }
        .action-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📩 Hòm Thư Của Bạn</h2>
        <div class="nav-links">
            <a href="home">🏠 Quay lại Home</a>
            <a href="my_items">📦 Các tin tôi đã đăng</a>
        </div>

        <h3>📥 Tin Nhắn Đến (Người khác nhắn vào bài của bạn)</h3>
        <table>
            <tr><th>Thời gian</th><th>Người gửi</th><th>Món đồ</th><th>Tiêu đề</th><th>Nội dung</th><th>Hành động</th></tr>
            <c:forEach var="msg" items="${inbox}">
                <tr>
                    <td>${msg.createdAt}</td>
                    <td><b>${msg.senderName}</b></td>
                    <td><i>${msg.itemTitle}</i></td>
                    <td>${msg.title}</td>
                    <td>${msg.message}</td>
                    <td><a href="item_detail?id=${msg.itemId}" class="action-link">Phản hồi ➔</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty inbox}"><tr><td colspan="6" style="text-align: center;">Chưa có tin nhắn nào.</td></tr></c:if>
        </table>

        <h3>📤 Tin Nhắn Đã Gửi (Bạn nhắn cho người khác)</h3>
        <table>
            <tr><th>Thời gian</th><th>Món đồ</th><th>Tiêu đề</th><th>Nội dung</th><th>Hành động</th></tr>
            <c:forEach var="msg" items="${outbox}">
                <tr>
                    <td>${msg.createdAt}</td>
                    <td><i>${msg.itemTitle}</i></td>
                    <td>${msg.title}</td>
                    <td>${msg.message}</td>
                    <td><a href="item_detail?id=${msg.itemId}" class="action-link">Xem lại bài ➔</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty outbox}"><tr><td colspan="5" style="text-align: center;">Bạn chưa gửi tin nhắn nào.</td></tr></c:if>
        </table>
    </div>
</body>
</html>