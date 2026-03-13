<%-- 
    Document   : addCategory
    Created on : Mar 7, 2026, 10:00:06 PM
    Author     : phant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Add Category</h1>
        <h3 style="color: #d93025">${requestScope.error}</h3>
        <form action="add">
            enter name: <input type="text" name="name" required/><br/>
            enter describe: <input type="text" name="describe" required/><br/>
            <input type="submit" value="SAVE"/>
        </form>
    </body>
</html>
