package com.fashionstore.dao;

import com.fashionstore.model.User;

public interface UserDAO {
    User loginUser(String email, String password);
    User getUserById(int userId);
    boolean registerUser(User user);
}
