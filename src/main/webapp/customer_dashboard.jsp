<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bank.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>

<%
    // Check if session exists
    if (Objects.isNull(session.getAttribute("accountNo"))) {
        // Redirect to customerlogin.jsp if session does not exist
        response.sendRedirect("customerlogin.jsp");
        return; // Stop further execution of the JSP
    }

    // Check if the refresh flag is not set in the session
    if (session.getAttribute("refreshed") == null) {
        // Set the refresh flag in the session
        session.setAttribute("refreshed", true);
        // Refresh the page after 1 second
        response.setHeader("Refresh", "1");
    }
%>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache"); 
response.setHeader ("Expires", "0"); // prevents caching at the proxy server
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    
    <script type="text/javascript">
        // Disable browser back button
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
    </script>
    <link rel="stylesheet" type="text/css" href="dashboard.css">
    <link rel="stylesheet" type="text/css" href="./css/customer_dashboard.css">
</head>
<body style="display: flex; flex-direction: column; justify-content:center;">
<div class="container"> 
    <h1>Welcome <%= session.getAttribute("accountNo") %> to Your Dashboard</h1>

    <%
        // Initialize variables for account balance
        double accountBalance = 0;

        try {
            // Establish database connection
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement stmt = con.prepareStatement("SELECT initial_balance FROM customers WHERE account_number = ?");
            stmt.setString(1, session.getAttribute("accountNo").toString());
            ResultSet rs = stmt.executeQuery();
            
            // Retrieve account balance
            if (rs.next()) {
                accountBalance = rs.getDouble("initial_balance");
            }

            // Close resources
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <h2>Account Balance: $<%= accountBalance %></h2>
    <div style="display: flex; flex-direction: row; width: 80vw; justify-content: center;">
        <button onclick="openAddMoneyAlert()">Add Money</button>
        <button onclick="openRemoveMoneyAlert()">Remove Money</button>
        <button onclick="downloadTable()">Download PDF</button>
        <button onclick="resetPassAlert()">Reset Password</button>
        <button onclick="deleteAcc()">Delete Account</button>
        <button class="logout-button" onclick="logout()">Logout</button>
    </div>

    <script>
        function downloadTable() {
            var table = document.getElementById("transactions");
            var opt = {
                margin: 10,
                filename: 'bank_statement.pdf',
                image: { type: 'jpeg', quality: 1 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'pt', format: 'a4', orientation: 'portrait' }
            };
            html2pdf().from(table).set(opt).save();
        }

        function deleteAcc() {
            if (confirm("Are you sure you want to delete your account?")) {
                if (<%= accountBalance %> === 0) {
                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "deleteAccount");
                    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            if (xhr.status === 200) {
                                alert("Account deleted successfully!");
                                window.location.href = "customerlogin.jsp";
                            } else {
                                alert("Error: " + xhr.responseText);
                            }
                        }
                    };
                    xhr.send("accountNo=" + encodeURIComponent(accountNo));
                } else {
                    alert("Cannot delete account. Please ensure your account balance is 0.");
                }
            }
        }

        function resetPassAlert() {
            var newPass = prompt("Enter new Password:");
            if (newPass !== null) {
                resetPassword(newPass);
            }
        }

        function openAddMoneyAlert() {
            var amountToAdd = prompt("Enter amount to add:");
            if (amountToAdd !== null) {
                addMoney(amountToAdd);
            }
        }

        function openRemoveMoneyAlert() {
            var amountToRemove = prompt("Enter amount to remove:");
            if (amountToRemove !== null) {
                removeMoney(amountToRemove);
            }
        }

        function resetPassword(newPassword) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "ResetPasswordServlet");
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        alert("Password reset successful!");
                    } else {
                        alert("Error: " + xhr.responseText);
                    }
                }
            };
            xhr.send("newPassword=" + encodeURIComponent(newPassword));
        }

        function addMoney(amountToAdd) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "AddMoneyServlet");
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        location.reload();
                    } else {
                        alert("Error: " + xhr.responseText);
                    }
                }
            };
            xhr.send("amountToAdd=" + encodeURIComponent(amountToAdd));
        }

        function removeMoney(amountToRemove) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "RemoveMoneyServlet");
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        location.reload();
                    } else {
                        alert("Error: Transaction could not be processed due to insufficient balance.");
                    }
                }
            };
            xhr.send("amountToRemove=" + encodeURIComponent(amountToRemove));
        }

        function logout() {
            window.location.href = "CustomerLogoutServlet";
        }
    </script>

    <h2>Recent Transactions:</h2>
    <label for="sortOrder" style="margin-right: 10px;">Sort Order:</label>
    <select id="sortOrder" onchange="sortTable()" style="padding: 5px; border-radius: 3px;">
        <option value="asc">Ascending</option>
        <option value="desc">Descending</option>
    </select>

    <script>
        function sortTable() {
            var table = document.getElementById("transactions");
            var sortOrder = document.getElementById("sortOrder").value;
            var rows, switching, i, x, y, shouldSwitch;
            switching = true;
            while (switching) {
                switching = false;
                rows = table.rows;
                for (i = 1; i < (rows.length - 1); i++) {
                    shouldSwitch = false;
                    x = new Date(rows[i].getElementsByTagName("TD")[4].innerText);
                    y = new Date(rows[i + 1].getElementsByTagName("TD")[4].innerText);
                    if (sortOrder === "asc") {
                        if (x > y) {
                            shouldSwitch = true;
                            break;
                        }
                    } else if (sortOrder === "desc") {
                        if (x < y) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
                if (shouldSwitch) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                }
            }
        }
    </script>

    <div style="display: flex; justify-content-center; min-width: 100vw">
        <div style="max-width: 70vw;">
            <div class="transactions-table-container">
                <table id="transactions">
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Account No</th>
                            <th>Transaction Type</th>
                            <th>Amount</th>
                            <th>Transaction Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection con = DatabaseConnection.getConnection();
                                PreparedStatement stmt = con.prepareStatement("SELECT * FROM transactions WHERE account_number = ?");
                                stmt.setString(1, session.getAttribute("accountNo").toString());
                                ResultSet rs = stmt.executeQuery();
                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getString("transaction_id") %></td>
                            <td><%= rs.getString("account_number") %></td>
                            <td><%= rs.getString("transaction_type") %></td>
                            <td><%= rs.getDouble("amount") %></td>
                            <td><%= rs.getString("transaction_date") %></td>
                        </tr>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
