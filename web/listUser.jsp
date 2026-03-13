<%-- 
    Document   : listUser
    Created on : Mar 8, 2026, 7:58:09 PM
    Author     : phant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            function doDelete(id) {
                if (confirm("Are you sure to delete user with id=" + id)) {
                    window.location = "deleteuser?id=" + id;

                }
            }

        </script>
    </head>
    <body>
    <center>
        <h1>List Users</h1>
        <table border="1px" width="70%">
            <tr>
                <td>Id</td>
                <td>Name</td>
                <td>password</td>
                <td>full name</td>
                <td>email</td>
                <td>Phone Number</td>
                <td>role</td>
                <td>is active</td>
                <td>created at</td>
                <td>Action</td>
            </tr>
            <c:forEach items="${requestScope.data}" var="c">
                <c:set var="id" value="${c.userId}"/>  
                <tr>
                    <td>${id}</td>
                    <td>${c.username}</td>
                    <td>${c.password}</td>
                    <td>${c.fullName}</td>
                    <td>${c.email}</td>
                    <td>${c.phoneNumber}</td>
                    <td>${c.role}</td>
                    <td>${c.isActive}</td>
                    <td>${c.createdAt}</td>
                    <td>
                        <a href="updateuser?id=${id}">Update</a> &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="doDelete('${id}')">Delete</a>
                    </td>


                </tr>
            </c:forEach>



        </table>



    </center>


</body>
</html>
