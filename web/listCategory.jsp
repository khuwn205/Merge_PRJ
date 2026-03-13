<%-- 
    Document   : listCategory
    Created on : Mar 7, 2026, 9:34:30 PM
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
            function doDelete(id){
                if(confirm("Are you sure to delete category with id="+id)){
                    window.location="delete?id="+id;
                }
                    
            }
            
        </script>
    </head>
    <body>
    <center>
        <h1>List Categories</h1>
        <h3><a href="addCategory.jsp">Add new</a></h3>
        <table border="1px" width="70%" >
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Describe</th>
                <th>Action</th>
                
            </tr>
            <c:forEach items="${requestScope.data}" var="c">
                <c:set var="id" value="${c.categoryId}"/>
                <tr>
                    <td>${id}</td>
                    <td>${c.name}</td>
                    <td>${c.description}</td>
                    <td>
                        <a href="update?id=${id}">Update</a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="doDelete('${id}')">Delete</a>
                    </td>
                </tr> 
            </c:forEach>

        </table> 
        
        
    </center>

    </body>
</html>
