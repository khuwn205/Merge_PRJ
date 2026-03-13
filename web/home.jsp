<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Home</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; color: #333; }
        .header-box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .header-box h2 { margin: 0; color: #2c3e50; }
        .nav-links a { text-decoration: none; padding: 8px 15px; background: #007bff; color: white; border-radius: 5px; margin-left: 10px; font-weight: bold; }
        .nav-links a.inbox-btn { background: #ff4757; } /* Nút hòm thư màu đỏ cho nổi */
        .nav-links a:hover { opacity: 0.8; }
        
        .content-box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; text-align: center; }
        th, td { border: 1px solid #ddd; padding: 12px; }
        th { background-color: #f8f9fa; color: #495057; }
        
        .badge { padding: 5px 10px; border-radius: 4px; font-weight: bold; color: white; display: inline-block; font-size: 12px; }
        .bg-processing { background-color: #ffc107; color: #000; } /* Đang xử lý màu vàng */
        .bg-completed { background-color: #28a745; } /* Hoàn thành màu xanh */
        
        .btn-view { text-decoration: none; color: white; background-color: #17a2b8; padding: 6px 12px; border-radius: 4px; font-weight: bold; }
        .btn-view:hover { background-color: #138496; }
    </style>
</head>
<body>

    <div class="header-box">
        <div>
            <h2>👋 Xin chào, ${sessionScope.currentUser.fullName}!</h2>
            <p style="margin: 5px 0 0 0; color: gray;">Vai trò của bạn: <b>${sessionScope.userRole}</b></p>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home">🏠 Home</a>
            <a href="${pageContext.request.contextPath}/report_lost?type=lost">📢 Báo mất đồ</a>
            <a href="${pageContext.request.contextPath}/report_lost?type=found">📦 Báo nhặt đồ</a>
            <a href="${pageContext.request.contextPath}/my_items">📝 Các tin tôi đã đăng</a>
            <a href="${pageContext.request.contextPath}/inbox" class="inbox-btn">📩 Hòm thư của tôi</a>
            <a href="${pageContext.request.contextPath}/logout" style="background: #6c757d;">🚪 Đăng xuất</a>
        </div>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <script>alert('${fn:escapeXml(sessionScope.message)}');</script>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="content-box">
        <h3 style="color: #dc3545;">📢 DANH SÁCH BÁO MẤT (Đang tìm kiếm)</h3>
        <table>
            <tr>
                <th>Người đăng</th><th>Hình ảnh</th><th>Tiêu đề</th><th>Vị trí</th><th>Trạng thái</th><th>Xem chi tiết</th>
            </tr>
            <c:forEach var="it" items="${lostItems}">
                <tr>
                    <td><b>${it.ownerFullName}</b></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty lostItemImages[it.itemId]}">
                                <img src="${pageContext.request.contextPath}/${lostItemImages[it.itemId]}" style="max-height:80px; border-radius: 4px;">
                            </c:when>
                            <c:otherwise><span style="color: gray;">Không có hình</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>${it.title}</td>
                    <td>${it.locationName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${it.status eq 'completed'}"><span class="badge bg-completed">Đã tìm thấy</span></c:when>
                            <c:otherwise><span class="badge bg-processing">Đang tìm kiếm</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td><a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn-view">Xem chi tiết</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty lostItems}"><tr><td colspan="6">Chưa có bài báo mất nào.</td></tr></c:if>
        </table>
    </div>

    <div class="content-box">
        <h3 style="color: #28a745;">📦 DANH SÁCH BÁO NHẶT (Đang chờ chủ nhân)</h3>
        <table>
            <tr>
                <th>Người đăng</th><th>Hình ảnh</th><th>Tiêu đề</th><th>Vị trí</th><th>Trạng thái</th><th>Xem chi tiết</th>
            </tr>
            <c:forEach var="it" items="${foundItems}">
                <tr>
                    <td><b>${it.ownerFullName}</b></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty foundItemImages[it.itemId]}">
                                <img src="${pageContext.request.contextPath}/${foundItemImages[it.itemId]}" style="max-height:80px; border-radius: 4px;">
                            </c:when>
                            <c:otherwise><span style="color: gray;">Không có hình</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>${it.title}</td>
                    <td>${it.locationName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${it.status eq 'completed'}"><span class="badge bg-completed">Đã trả đồ xong</span></c:when>
                            <c:otherwise><span class="badge bg-processing">Đang chờ chủ</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td><a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn-view">Xem chi tiết</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty foundItems}"><tr><td colspan="6">Chưa có bài báo nhặt nào.</td></tr></c:if>
        </table>
    </div>

</body>
</html>