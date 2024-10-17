
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Like College</title>
</head>
<body>
<%
    try {
        // Check if the user is logged in as a student
        if (session.getAttribute("isStudent") != null && session.getAttribute("isStudent").equals("yes")) {
            String collegeName = request.getParameter("college_name");

            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/mumbai";
            String user = "root";
            String pass = "root@1028";
            Connection con = DriverManager.getConnection(url, user, pass);

            // Update the college's rating
            PreparedStatement pst = con.prepareStatement("UPDATE COLLEGE SET LIKES = LIKES + 1 WHERE COLLEGE_NAME = ?;");
            pst.setString(1, collegeName);
            int i = pst.executeUpdate();

            // Check if the update was successful
            if (i > 0) {
%>
<jsp:include page="view_colleges.jsp" flush="true">
    <jsp:param name="isStudent" value="yes"/>
</jsp:include>
<script type="text/javascript">
    alert("Thanks for your valuable feedback!");
</script>
<%
} else {
%>
<jsp:include page="view_colleges.jsp" flush="true">
    <jsp:param name="isStudent" value="yes"/>
</jsp:include>
<script type="text/javascript">
    alert("Error! College not found.");
</script>
<%
    }
}
else{

%>


<jsp:include page="view_colleges.jsp" flush="true" >
    <jsp:param name="isStudent" value="yes" />
</jsp:include>
<script type="text/javascript">
    alert("Student login needed!");
</script>

<%
        }



    } catch (Exception e) {
        e.printStackTrace();
    }
%>
</body>
</html>

