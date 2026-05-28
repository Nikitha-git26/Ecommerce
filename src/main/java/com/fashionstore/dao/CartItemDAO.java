package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.CartItem;

public interface CartItemDAO {
    List<CartItem> getCartItemsByCartId(int cartId);
    CartItem getCartItemByProductAndSize(int cartId, int productId, String size);
    boolean addCartItem(CartItem cartItem);
    boolean updateCartItemQuantity(int cartItemId, int quantity);
    boolean removeCartItem(int cartItemId);
    boolean clearCartItems(int cartId);
}
