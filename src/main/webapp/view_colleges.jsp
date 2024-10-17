
<%@page import="java.sql.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>College List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        h1 {
            text-align: center;
            margin-top: 15px;
            font-family: 'Times New Roman';
        }
        table {
            margin: 25px auto;
            border: solid 1px black;
            width: 80%;
            border-collapse: collapse;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            background-color: #fff;
        }
        th, td {
            padding: 15px;
            border: solid 1px black;
            text-align: left;
        }
        th {
            background-color: #bf3d42;
            color: white;
        }
        .like-btn {
            background-color: #bf3d42;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .like-btn:hover {
            background-color: #a12d35;
        }
        .container {
            text-align: center;
            margin-top: 30px;
        }
        .marquee-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .marquee {
            width: 70%;
            padding: 10px;
            border: solid 2px black;
            background-color: #fff;
        }
    </style>
</head>
<body>

<jsp:include page="header.html" flush="true" />

<h1>List of Colleges in Mumbai </h1>


<%
    // Database connection setup
    Class.forName("com.mysql.cj.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/mumbai";
    String user = "root";
    String pass = "root@1028";
    Connection con = DriverManager.getConnection(url, user, pass);

    // Query to retrieve data from the database
    String query = "SELECT college_name, college_address, college_fee, college_ratings,LIKES FROM college;";
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(query);
%>

<%
    // Query to get the top-rated college
    String topCollege = "";
    try {
        String topQuery = "SELECT college_name FROM college WHERE college_ratings = (SELECT MAX(college_ratings) FROM college);";
        Statement topSt = con.createStatement();
        ResultSet topRs = topSt.executeQuery(topQuery);

        if (topRs.next()) {
            topCollege = topRs.getString("college_name");
        }
    } catch(Exception e) {
        System.out.println(e);
    }
%>

<div class="marquee-container">
    <marquee class="marquee">
        Top College in Mumbai: <%= topCollege %> | Top Hotel in Mumbai: Taj Hotel | Top Library in Mumbai: Janta Library | Top Industry in Mumbai: Tata
    </marquee>
</div>



<center>
    <table class="tabel table-bordered table-striped table-hover">
        <tr>
            <th>College Name</th>
            <th>Location</th>
            <th>&#8377; Fees</th>
            <th>Ratings</th>
            <th>Total likes</th>
            <th>Like</th>
        </tr>
        <%
            while(rs.next()) {
                String collegeName = rs.getString("college_name");
                String collegeAddress = rs.getString("college_address");
                double collegeFee = rs.getDouble("college_fee");
                double collegeRatings = rs.getDouble("college_ratings");
                int likes  = rs.getInt("likes");
        %>
        <tr>
            <td><%= collegeName %></td>
            <td><%= collegeAddress %></td>
            <td>&#8377;<%= String.format("%.2f", collegeFee) %></td>
            <td><%= collegeRatings %></td>
            <td><%= likes %></td>
            <td>
                <!-- Like button sends the college name to likeCollege.jsp -->
                <form action="likeCollege.jsp" method="GET" style="display:inline;">
                    <input type="hidden" name="college_name" value="<%= collegeName %>">
                    <button class="like-btn" type="submit">&#9829;</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</center>

<%--delete section--%>


<%
    String isAdmin = (String) session.getAttribute("isAdmin");
    if ("yes".equals(isAdmin)) {
%>
<div style="background-color: #fff; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); padding: 20px; max-width: 400px; margin: 50px auto;">
    <h2 style="text-align: center; color: #333;">Delete a College</h2>
    <form action="deleteCollege.jsp" method="POST">
        <label for="college_name" style="font-weight: bold;">Enter College Name to Delete:</label><br>
        <input type="text" id="college_name" name="college_name" placeholder="College Name" required
               style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; margin-bottom: 15px; transition: border 0.3s;"
               onfocus="this.style.borderColor='#bf3d42';" onblur="this.style.borderColor='#ccc';"><br>
        <input type="submit" value="Delete"
               style="background-color: #bf3d42; color: white; padding: 10px 15px; border: none; border-radius: 5px; cursor: pointer; width: 100%; transition: background-color 0.3s;"
               onmouseover="this.style.backgroundColor='#bf3d42';" onmouseout="this.style.backgroundColor='#bf3d42';">
    </form>
</div>
<%
} else {
%>
<p>You do not have permission to delete a college.</p>
<%
    }
%>



<jsp:include page="footer.html" flush="true" />

</body>
</html>
