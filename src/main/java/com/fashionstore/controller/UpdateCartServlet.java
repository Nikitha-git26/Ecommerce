package com.fashionstore.controller;

import java.io.IOException;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.dao.impl.CartItemDAOImpl;
import com.fashionstore.model.Cart;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart/update")
public class UpdateCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDAO = new CartDAOImpl();
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
        String quantityParam = request.getParameter("quantity");
        if (cartItemIdParam == null || quantityParam == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            int cartItemId = Integer.parseInt(cartItemIdParam);
            int quantity = Integer.parseInt(quantityParam);
            if (quantity <= 0) {
                cartItemDAO.removeCartItem(cartItemId);
            } else {
                cartItemDAO.updateCartItemQuantity(cartItemId, quantity);
            }
        } catch (NumberFormatException e) {
            // ignore
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
