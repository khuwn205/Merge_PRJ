<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng tin đồ vật</title>
</head>
<body>
    <h2>${empty formTitle ? 'Báo mất đồ (Lost)' : formTitle}</h2>

    <c:if test="${not empty ERROR}">
        <p style="color:red;">${ERROR}</p>
    </c:if>

    <form action="report_lost" method="post" enctype="multipart/form-data">
        <input type="hidden" name="report_type" value="${empty reportType ? 'lost' : reportType}">
        <table>
            <tr>
                <td>Tiêu đề đồ vật (*)</td>
                <td><input type="text" name="title" value="${oldTitle}" required></td>
            </tr>
            <tr>
                <td>Mô tả (*)</td>
                <td><textarea name="description" rows="4" cols="40" required>${oldDescription}</textarea></td>
            </tr>
            <tr>
                <td>Danh mục (*)</td>
                <td>
                    <select name="category_id" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${oldCategoryId == c.categoryId ? 'selected' : ''}>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>${empty locationLabel ? 'Vị trí (*)' : locationLabel}</td>
                <td>
                    <select name="location_id" required>
                        <option value="">-- Chọn vị trí --</option>
                        <c:forEach var="l" items="${locations}">
                            <option value="${l.locationId}" ${oldLocationId == l.locationId ? 'selected' : ''}>
                                ${l.name}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>${empty dateLabel ? 'Thời điểm (*)' : dateLabel}</td>
                <td><input type="datetime-local" name="date_incident" value="${oldDateIncident}" required></td>
            </tr>
            <tr>
                <td>Hình ảnh (tùy chọn)</td>
                <td>
                    <input type="file" name="images" accept="image/*" multiple>
                    <br><small style="color:gray;">(Vui lòng chọn ảnh có kích thước dưới 5MB)</small>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button type="submit">${empty submitLabel ? 'Gửi báo mất' : submitLabel}</button>
                    <a href="home">Quay lại Home</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>