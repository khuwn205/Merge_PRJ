<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang Chủ - Quản Lý Đồ Thất Lạc</title>
    </head>
    <body>

        <table border="1" width="100%">
            <tr>
                <td><h2>Xin chào, ${sessionScope.currentUser.fullName}!</h2></td>
                <td align="right">
                    Vai trò của bạn: <b>${sessionScope.userRole}</b> <br>
                    <a href="logout">Đăng xuất</a>
                </td>
            </tr>
        </table>

        <c:if test="${not empty sessionScope.message}">
            <script>
                alert('${fn:escapeXml(sessionScope.message)}');
            </script>
            <c:remove var="message" scope="session"/>
        </c:if>

        <br>

        <c:choose>

            <%-- 1. NẾU LÀ ADMIN --%>
            <c:when test="${sessionScope.userRole == 'admin'}">
                <h3>BẢNG ĐIỀU KHIỂN - ADMIN</h3>
                <table border="1" width="100%">
                    <tr>
                        <td width="30%" valign="top">
                            <b>Menu Hệ Thống</b><br><br>
                            - <a href="manage_users">Quản lý Tài khoản (Users)</a><br>
                            - <a href="manage_categories">Quản lý Danh mục (Categories)</a><br>
                            - <a href="manage_locations">Quản lý Vị trí (Locations)</a><br>
                            - <a href="manage_items">Quản lý đồ vật (items)</a><br>
                            - <a href="manage_claims">Quản lý yêu cầu (claims)</a>
                        </td>
                        <td valign="top">
                            <b>Thống kê nhanh</b><br><br>
                            - Tổng số người dùng: <b>${totalUsers}</b><br>
                            - Tổng số đồ đang thất lạc: <b>${totalLostItems}</b>
                        </td>
                    </tr>
                </table>
            </c:when>

            <%-- 2. NẾU LÀ STAFF --%>
            <c:when test="${sessionScope.userRole == 'staff'}">
                <h3>KHÔNG GIAN LÀM VIỆC - STAFF</h3>
                <table border="1" width="100%">
                    <tr>
                        <td width="30%" valign="top">
                            <b>Menu Nghiệp Vụ</b><br><br>
                            - <a href="view_pending_items">Duyệt tin báo đồ (Processing)</a><br>
                            - <a href="view_pending_claims">Giải quyết Yêu cầu (Claims)</a><br>
                            - <a href="search_items">Tra cứu kho đồ</a>
                        </td>
                        <td valign="top">
                            <b>Công việc cần làm</b><br><br>
                            - Có <b>5</b> tin mới chờ duyệt.<br>
                            - Có <b>2</b> yêu cầu Claim cần xử lý ngay.
                        </td>
                    </tr>
                </table>
            </c:when>

            <%-- 3. NẾU LÀ STUDENT (VÀ CÁC TRƯỜNG HỢP CÒN LẠI) --%>
            <c:otherwise>
                <h3>TRANG CÁ NHÂN - SINH VIÊN</h3>
                <table border="1" width="100%">
                    <tr>
                        <td width="30%" valign="top">
                            <b>Menu Của Tôi</b><br><br>
                            - <a href="report_lost">Báo mất đồ (Lost)</a><br>
                            - <a href="report_found">Báo nhặt được đồ (Found)</a><br>
                            - <a href="my_items">Các tin tôi đã đăng</a><br>
                            - <a href="my_claims">Tình trạng yêu cầu nhận đồ</a>
                        </td>
                        <td valign="top">
                            <b>Bảng tin đồ thất lạc mới nhất</b><br><br>
                            <table border="1" width="100%">
                                <tr>
                                    <td><b>Tên đồ vật</b></td>
                                    <td><b>Loại</b></td>
                                    <td><b>Ngày báo</b></td>
                                    <td><b>Hành động</b></td>
                                </tr>
                                <c:forEach var="it" items="${latestFoundItems}">
                                    <tr>
                                        <td>${it.title}</td>
                                        <td>${it.type}</td>
                                        <td>${it.createdAt}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}">
                                                Xem &amp; Nhận
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty latestFoundItems}">
                                    <tr>
                                        <td colspan="4">Chưa có đồ nhặt được nào.</td>
                                    </tr>
                                </c:if>
                            </table>
                        </td>
                    </tr>
                </table>
            </c:otherwise>

        </c:choose>

    </body>
</html>