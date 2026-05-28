package com.fashionstore.dao;

import com.fashionstore.model.Order;

public interface OrderDAO {
    int placeOrder(Order order);
}
