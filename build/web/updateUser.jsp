<%-- 
    Document   : updateUser
    Created on : Mar 8, 2026, 9:21:46 PM
    Author     : phant
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Update User</h1>
        <c:set var="c" value="${requestScope.user}"/>
        <form action="updateuser" method="post">
            <input type="hidden" name="id" value="${c.userId}"/>
            Enter Role: <input type="text" name="role" value="${c.role}"/><br/>
            Enter Active: <input type="text" name="isactive" value="${c.isActive}"/><br/>
            <input type="submit" value="UPDATE"/>
 
        </form>
        
        </body>
    </html>
