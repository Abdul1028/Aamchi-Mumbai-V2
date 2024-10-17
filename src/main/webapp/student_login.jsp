
<%@page import="java.sql.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student Login</title>
</head>
<body>

<%
    String role = "";
    String dbPassword = "";

    try {
        // Get the username (email) and password from the form
        String username = request.getParameter("student_user");
        String password = request.getParameter("student_pass");

        // JDBC connection details
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/mumbai";
        String dbUser = "root";
        String dbPass = "root@1028";

        Connection con = DriverManager.getConnection(url, dbUser, dbPass);

        // Prepare the SQL query to check both email and password
        String query = "SELECT role, password FROM USERS WHERE EMAIL = ? AND PASSWORD = ?;";
        PreparedStatement pst = con.prepareStatement(query);

        // Set the parameters for the query
        pst.setString(1, username);
        pst.setString(2, password);

        // Execute the query
        ResultSet rst = pst.executeQuery();

        // Check if a matching record exists
        if (rst.next()) {
            // Retrieve the role (assuming "Student" or something similar)
            role = rst.getString("role");
            dbPassword = rst.getString("password");

            // If the role is 'Student' and password matches, log in as student
            if (role.equals("Student") && dbPassword.equals(password)) {
                session.setAttribute("isStudent", "yes");
%>
<jsp:include page="index.jsp" flush="true">
    <jsp:param name="isStudent" value="yes" />
</jsp:include>

<script type="text/javascript">
    alert("Logged in as a Student!");
</script>
<%
} else {
    // If the role is not 'Student' or password doesn't match
%>
<jsp:include page="student_section.html" flush="true">
    <jsp:param name="isStudent" value="yes" />
</jsp:include>

<script type="text/javascript">
    alert("Invalid Password or Role!");
</script>
<%
    }
} else {
    // If no matching user exists, show an error message
%>
<jsp:include page="index.jsp" flush="true">
    <jsp:param name="isStudent" value="no" />
</jsp:include>

<script type="text/javascript">
    alert("Please sign up as a Student first!");
</script>
<%
        }

    } catch (Exception e) {
        // If there's an error, print it to the console
        e.printStackTrace();
    }
%>

</body>
</html>
