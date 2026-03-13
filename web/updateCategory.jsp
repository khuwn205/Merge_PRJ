<%-- 
    Document   : updateCategory
    Created on : Mar 8, 2026, 10:10:08 AM
    Author     : phant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Update Category</h1>
        <c:set var="c" value="${requestScope.category}"/>
        <form action="update" method="post">
            <input type="hidden" name="id" value="${c.categoryId}"/>
            enter name: <input type="text" name="name" value="${c.name}"/><br/>
            enter describe: <input type="text" name="describe" value="${c.description}"/><br/>
            <input type="submit" value="UPDATE"/>
            
            
        </form>
    </body>
</html>
