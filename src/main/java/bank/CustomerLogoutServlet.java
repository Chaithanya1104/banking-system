package bank;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CustomerLogoutServlet")
public class CustomerLogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the session
        HttpSession session = request.getSession(false); // Do not create a new session if it doesn't exist
        if (session != null) {
            // Set the session attribute to null
            session.setAttribute("accountNo", null); // Assuming "accountNo" is the session attribute holding the account number
        }
        
        // Redirect back to the customer login page
        response.sendRedirect("customerlogin.jsp");
    }
}