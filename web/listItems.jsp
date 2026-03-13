<%-- 
    Document   : listItems
    Created on : Mar 13, 2026, 10:27:11 PM
    Author     : phant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            function doDelete(id) {
                if (confirm("Are you sure to delete item with id=" + id)) {
                    window.location = "deleteitem?id=" + id;
                }

            }

        </script>
    </head>
    <body>
    <center>

        <h1>List Items</h1>

        <table border="1px" width="90%">

            <tr>

                <td>ID</td>
                <td>User ID</td>
                <td>Category ID</td>
                <td>Location ID</td>
                <td>Title</td>
                <td>Description</td>
                <td>Type</td>
                <td>Status</td>
                <td>Image</td>
                <td>Date Incident</td>
                <td>Created At</td>
                <td>Updated At</td>
                <td>Action</td>

            </tr>

            <c:forEach items="${requestScope.data}" var="i">

                <c:set var="id" value="${i.itemId}"/>

                <tr>

                    <td>${id}</td>

                    <td>${i.userId}</td>

                    <td>${i.categoryId}</td>

                    <td>${i.locationId}</td>

                    <td>${i.title}</td>

                    <td>${i.description}</td>

                    <td>${i.type}</td>

                    <td>${i.status}</td>

                    <td>${i.imagesJSON}</td>

                    <td>${i.dateIncident}</td>

                    <td>${i.createdAt}</td>

                    <td>${i.updatedAt}</td>

                    <td>

                        <a href="updateitem?id=${id}">Update</a>

                        &nbsp;&nbsp;&nbsp;&nbsp;

                        <a href="#" onclick="doDelete('${id}')">Delete</a>

                    </td>

                </tr>

            </c:forEach>

        </table>

    </center>

</body>
</html>
