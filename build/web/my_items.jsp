<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Các tin tôi đã đăng</title>
</head>
<body>
    <h2>Các tin tôi đã đăng</h2>

    <c:if test="${not empty sessionScope.message}">
        <script>
            alert('${fn:escapeXml(sessionScope.message)}');
        </script>
        <c:remove var="message" scope="session"/>
    </c:if>

    <a href="${pageContext.request.contextPath}/home">Quay lại Home</a> |
    <a href="${pageContext.request.contextPath}/report_lost?type=lost">Thêm bài báo mất mới</a> |
    <a href="${pageContext.request.contextPath}/report_lost?type=found">Thêm bài báo nhặt mới</a>
    <br><br>

    <h3>Danh sách tin báo mất</h3>
    <table border="1" width="100%" style="text-align: center;">
        <tr style="background-color: #f2f2f2;">
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Danh mục</th>
            <th>Vị trí</th>
            <th>Loại</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Hành động</th>
        </tr>

        <c:forEach var="it" items="${lostMyItems}">
            <tr>
                <td>${it.itemId}</td>
                <td>${it.title}</td>
                <td>${it.categoryName}</td>
                <td>${it.locationName}</td>
                <td>${it.type}</td>
                <td><b>${it.status}</b></td>
                <td>${it.createdAt}</td>
                <td>
                    <a href="item_detail?id=${it.itemId}">Xem chi tiết</a> | 
                    <a href="edit_item?id=${it.itemId}">Sửa</a> | 
                    <form action="my_items" method="post" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa bài đăng này?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="item_id" value="${it.itemId}">
                        <button type="submit" style="color: red; cursor: pointer;">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty lostMyItems}">
            <tr>
                <td colspan="8">Bạn chưa có tin báo mất nào.</td>
            </tr>
        </c:if>
    </table>

    <br>
    <h3>Danh sách tin báo nhặt</h3>
    <table border="1" width="100%" style="text-align: center;">
        <tr style="background-color: #f2f2f2;">
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Danh mục</th>
            <th>Vị trí</th>
            <th>Loại</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Hành động</th>
        </tr>

        <c:forEach var="it" items="${foundMyItems}">
            <tr>
                <td>${it.itemId}</td>
                <td>${it.title}</td>
                <td>${it.categoryName}</td>
                <td>${it.locationName}</td>
                <td>${it.type}</td>
                <td><b>${it.status}</b></td>
                <td>${it.createdAt}</td>
                <td>
                    <a href="item_detail?id=${it.itemId}">Xem chi tiết</a> | 
                    <a href="edit_item?id=${it.itemId}">Sửa</a> | 
                    <form action="my_items" method="post" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa bài đăng này?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="item_id" value="${it.itemId}">
                        <button type="submit" style="color: red; cursor: pointer;">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty foundMyItems}">
            <tr>
                <td colspan="8">Bạn chưa có tin báo nhặt nào.</td>
            </tr>
        </c:if>
    </table>
</body>
</html>