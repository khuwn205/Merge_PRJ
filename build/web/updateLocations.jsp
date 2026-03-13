<%-- 
    Document   : updateLocations
    Created on : Mar 8, 2026, 12:08:25 PM
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
        <h1>Update Location</h1>
        <c:set var="c" value="${requestScope.location}"/>
        <form action="updatelocation" method="post">
            <input type="hidden" name="id" value="${c.locationId}"/>
            Enter Name: <input type="text" name="name" value="${c.name}"/> <br/>
            <input type="submit" value="UPDATE"/>
        </form>
    </body>
</html>
