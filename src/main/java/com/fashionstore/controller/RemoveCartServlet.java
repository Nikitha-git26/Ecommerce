package com.fashionstore.controller;

import java.io.IOException;

import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.dao.impl.CartItemDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart/remove")
public class RemoveCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String cartItemIdParam = request.getParameter("cartItemId");
        if (cartItemIdParam != null) {
            try {
                int cartItemId = Integer.parseInt(cartItemIdParam);
                cartItemDAO.removeCartItem(cartItemId);
            } catch (NumberFormatException e) {
                // ignore invalid id
            }
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
