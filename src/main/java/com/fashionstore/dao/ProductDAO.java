package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.Product;

public interface ProductDAO {
    List<Product> getAllProducts();
    Product getProductById(int productId);
    List<Product> getProductsByCategory(String category);
    List<Product> searchProducts(String keyword);
}
