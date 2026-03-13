<%-- 
    Document   : listClaims
    Created on : Mar 13, 2026, 11:01:52 PM
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

                if (confirm("Are you sure to delete claim id=" + id)) {

                    window.location = "deleteclaim?id=" + id;

                }

            }

        </script>
    </head>
    <body>
    <center>

        <h1>List Claims</h1>

        <table border="1" width="80%">

            <tr>

                <td>ID</td>
                <td>Item ID</td>
                <td>Claimer ID</td>
                <td>Status</td>
                <td>Proof</td>
                <td>Response</td>
                <td>Responded By</td>
                <td>Created</td>
                <td>Updated</td>
                <td>Action</td>

            </tr>

            <c:forEach items="${requestScope.data}" var="c">

                <c:set var="id" value="${c.claimId}"/>

                <tr>

                    <td>${id}</td>

                    <td>${c.itemId}</td>

                    <td>${c.claimerId}</td>

                    <td>${c.status}</td>

                    <td>${c.proofDescription}</td>

                    <td>${c.responseMessage}</td>

                    <td>${c.respondedBy}</td>

                    <td>${c.createdAt}</td>

                    <td>${c.updatedAt}</td>

                    <td>

                        <a href="#" onclick="doDelete('${id}')">Delete</a>

                    </td>

                </tr>

            </c:forEach>

        </table>

    </center>

</body>
</html>
