package com.fashionstore.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final List<String> categories = Arrays.asList("Men", "Women", "Kids");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String category = request.getParameter("category");
        String sort = request.getParameter("sort");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int productId = Integer.parseInt(idParam);
                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }
                request.setAttribute("product", product);
                request.setAttribute("sizes", Arrays.asList("S", "M", "L", "XL"));
                request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
        }

        List<Product> products;
        if (category != null && !category.isBlank()) {
            products = productDAO.getProductsByCategory(category);
            request.setAttribute("selectedCategory", category);
        } else {
            products = productDAO.getAllProducts();
            request.setAttribute("selectedCategory", "All");
        }

        sortProducts(products, sort);
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedSort", normalizeSort(sort));
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }

    private void sortProducts(List<Product> products, String sort) {
        switch (normalizeSort(sort)) {
            case "priceLow":
                products.sort(Comparator.comparingDouble(Product::getPrice));
                break;
            case "priceHigh":
                products.sort(Comparator.comparingDouble(Product::getPrice).reversed());
                break;
            case "name":
                products.sort(Comparator.comparing(Product::getName));
                break;
            case "newest":
            default:
                products.sort(Comparator.comparingInt(Product::getId).reversed());
                break;
        }
    }

    private String normalizeSort(String sort) {
        if (sort == null || sort.isBlank()) {
            return "newest";
        }
        return sort;
    }
}
