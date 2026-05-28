package com.fashionstore.dao;

import com.fashionstore.model.Cart;

public interface CartDAO {
    Cart getCartByUserId(int userId);
    int createCart(int userId);
}
