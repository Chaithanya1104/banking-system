<%@ page import="java.sql.*" %>
<%@ page import="bank.DatabaseConnection" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache"); 
response.setHeader ("Expires", "0"); //prevents caching at the proxy server
%>
<%
    String account_number = request.getParameter("account_number"); // make sure the parameter name matches
    if (account_number == null || account_number.isEmpty()) {
        out.println("Invalid account number.");
    } else {
        try {
            Connection con = DatabaseConnection.getConnection();
            String query = "DELETE FROM customers WHERE account_number = ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, account_number);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("admin_dashboard.jsp?status=deleteSuccess");
            } else {
                out.println("Error: Customer not found.");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }
%>
