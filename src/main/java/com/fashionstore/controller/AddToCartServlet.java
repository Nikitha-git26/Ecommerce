package com.fashionstore.controller;

import java.io.IOException;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.dao.impl.CartItemDAOImpl;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Cart;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Product;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart/add")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String size = request.getParameter("size");
        if (productIdParam == null || size == null || size.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            User user = (User) session.getAttribute("loggedInUser");
            Cart cart = cartDAO.getCartByUserId(user.getId());
            if (cart == null) {
                int cartId = cartDAO.createCart(user.getId());
                if (cartId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }
                cart = new Cart();
                cart.setId(cartId);
                cart.setUserId(user.getId());
            }

            CartItem existing = cartItemDAO.getCartItemByProductAndSize(cart.getId(), productId, size);
            if (existing != null) {
                cartItemDAO.updateCartItemQuantity(existing.getId(), existing.getQuantity() + 1);
            } else {
                CartItem item = new CartItem();
                item.setCartId(cart.getId());
                item.setProductId(productId);
                item.setSize(size);
                item.setQuantity(1);
                cartItemDAO.addCartItem(item);
            }
        } catch (NumberFormatException e) {
            // ignore invalid product id
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
