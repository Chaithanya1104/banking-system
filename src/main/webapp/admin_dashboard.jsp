<%@ page import="java.sql.*" %>
<%@ page import="bank.DatabaseConnection" %> <!-- Import for DatabaseConnection class -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache"); 
    response.setHeader("Expires", "0"); // prevents caching at the proxy server
%>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="./css/admin_dashboard.css">
</head>
<body>
    <div style="display: flex; flex-direction: row; justify-content: space-between; margin: 2px 85px">
        <h2 style="margin-left: 10rem; margin-top: 2rem;">Welcome Admin</h2>
        <div class="button-container">
            <button class="logout-button" onclick="logout()">Logout</button>
            <a href="register.jsp">
                <button class="new-user-button">REGISTER A NEW USER</button>
            </a>
        </div>
    </div>

    <h3>Customer Details</h3>
    <table border="1">
        <tr>
            <th>Account Number</th>
            <th>Full Name</th>
            <th>Address</th>
            <th>Mobile Number</th>
            <th>Email ID</th>
            <th>Account Type</th>
            <th>Date of Birth</th>
            <th>ID Proof</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Connection con = DatabaseConnection.getConnection(); // Using DatabaseConnection class for database connectivity
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT account_number, fullname, address, mobile, email, account_type, dob, id_proof FROM customers");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("account_number") %></td>
            <td><%= rs.getString("fullname") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("mobile") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("account_type") %></td>
            <td><%= rs.getDate("dob") %></td>
            <td><%= rs.getString("id_proof") %></td>
            <td style="display: flex;">
                <a style="margin: 4px" href="update_customer.jsp?account_number=<%= rs.getInt("account_number") %>">
                    <button style="background-color: #007bff" class="update-button">Update</button>
                </a>
                <a style="margin: 4px" href="delete_customer.jsp?account_number=<%= rs.getInt("account_number") %>" onclick="return confirm('Are you sure?')">
                    <button class="delete-button">Delete</button>
                </a>
            </td>
        </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace();
            }
        %>
    </table>

    <script>
        function logout() {
            window.location.href = "index.jsp";
        }
    </script>

    <script type="text/javascript">
        window.history.forward();
        function noBack() {
            window.history.forward();
        }
    </script>
</body>
</html>
