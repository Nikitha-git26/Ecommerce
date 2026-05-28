package com.fashionstore.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.OrderItemDAO;
import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.dao.impl.CartItemDAOImpl;
import com.fashionstore.dao.impl.OrderDAOImpl;
import com.fashionstore.dao.impl.OrderItemDAOImpl;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/placeorder")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        if (address == null || address.isBlank() || paymentMethod == null || paymentMethod.isBlank()) {
            request.setAttribute("error", "Please enter address and payment method.");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        Cart cart = cartDAO.getCartByUserId(user.getId());
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartId(cart.getId());
        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double total = 0;
        for (CartItem item : items) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                total += product.getPrice() * item.getQuantity();
            }
        }

        Order order = new Order();
        order.setUserId(user.getId());
        order.setTotal(total);
        order.setAddress(address);
        order.setPaymentMethod(paymentMethod);

        int orderId = orderDAO.placeOrder(order);
        if (orderId < 0) {
            request.setAttribute("error", "Unable to place order. Please try again.");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        for (CartItem item : items) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product == null) {
                continue;
            }
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setProductId(product.getId());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setPrice(product.getPrice());
            orderItemDAO.addOrderItem(orderItem);
        }

        cartItemDAO.clearCartItems(cart.getId());
        response.sendRedirect(request.getContextPath() + "/products?orderSuccess=true");
    }
}
