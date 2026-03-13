<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sua bai dang</title>
</head>
<body>
    <h2>Sua bai dang</h2>

    <c:if test="${not empty ERROR}">
        <p style="color:red;">${ERROR}</p>
    </c:if>

    <form action="edit_item" method="post" enctype="multipart/form-data">
        <input type="hidden" name="item_id" value="${itemId}">
        <table>
            <tr>
                <td>Tieu de do vat (*)</td>
                <td><input type="text" name="title" value="${oldTitle}" required></td>
            </tr>
            <tr>
                <td>Mo ta (*)</td>
                <td><textarea name="description" rows="4" cols="40" required>${oldDescription}</textarea></td>
            </tr>
            <tr>
                <td>Danh muc (*)</td>
                <td>
                    <select name="category_id" required>
                        <option value="">-- Chon danh muc --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${oldCategoryId == c.categoryId ? 'selected' : ''}>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Vi tri (*)</td>
                <td>
                    <select name="location_id" required>
                        <option value="">-- Chon vi tri --</option>
                        <c:forEach var="l" items="${locations}">
                            <option value="${l.locationId}" ${oldLocationId == l.locationId ? 'selected' : ''}>
                                ${l.name}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Thoi diem mat (*)</td>
                <td><input type="datetime-local" name="date_incident" value="${oldDateIncident}" required></td>
            </tr>
            <tr>
                <td>Hinh anh hien tai</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty existingImagePaths}">
                            <c:forEach var="imgPath" items="${existingImagePaths}">
                                <img src="${pageContext.request.contextPath}/${imgPath}" alt="${imgPath}" style="max-width:140px; max-height:140px; margin:5px; border:1px solid #ccc;"><br>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>Khong co hinh</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td>Upload hinh moi (tuy chon)</td>
                <td>
                    <input type="file" name="images" accept="image/*" multiple>
                    <br>(Neu chon hinh moi thi se thay toan bo hinh cu)
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button type="submit">Luu cap nhat</button>
                    <a href="my_items">Quay lai Cac tin toi da dang</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>