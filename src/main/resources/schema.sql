-- FashionStore database schema
CREATE DATABASE IF NOT EXISTS fashion_store;
USE fashion_store;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(80) NOT NULL,
    description TEXT,
    image_url VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    size VARCHAR(20) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    address TEXT NOT NULL,
    payment_method VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users (name, email, password) VALUES
('Alice Morgan', 'alice@example.com', 'password123'),
('Bob Carter', 'bob@example.com', 'securepass');

INSERT INTO products (name, price, category, description, image_url) VALUES
('Navy Polo Shirt', 1299.00, 'Men', 'Soft cotton polo shirt with a sharp weekend fit and breathable finish.', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80'),
('White Sneaker', 2499.00, 'Men', 'Everyday white sneakers with cushioned soles for city walks and casual plans.', 'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=900&q=80'),
('Floral Dress', 3199.00, 'Women', 'Lightweight floral midi dress with a soft drape and brunch-ready color.', 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=900&q=80'),
('Black Jacket', 4499.00, 'Women', 'Water-resistant black layer with clean lines and an easy evening silhouette.', 'https://images.unsplash.com/photo-1543076447-215ad9ba6923?auto=format&fit=crop&w=900&q=80'),
('Kids Hoodie', 999.00, 'Kids', 'Cozy everyday hoodie in playful color-block styling for school and playtime.', 'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?auto=format&fit=crop&w=900&q=80'),
('Kids Jeans', 1199.00, 'Kids', 'Stretch denim jeans built for movement, tumbles, and snack-fueled adventures.', 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?auto=format&fit=crop&w=900&q=80'),
('Linen Resort Shirt', 1799.00, 'Men', 'Airy linen-blend shirt with a relaxed collar for holidays, dinners, and warm afternoons.', 'https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=900&q=80'),
('Slim Indigo Jeans', 2199.00, 'Men', 'Dark-wash denim with a clean slim fit that works with tees, shirts, and sneakers.', 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=900&q=80'),
('Olive Utility Jacket', 3899.00, 'Men', 'Lightweight utility jacket with roomy pockets and a travel-ready shape.', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=80'),
('Textured Kurta Set', 2999.00, 'Men', 'Modern textured kurta set for festive evenings, family functions, and elevated comfort.', 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&w=900&q=80'),
('Satin Evening Top', 1899.00, 'Women', 'Soft satin top with an elegant shine for dinner plans and festive styling.', 'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?auto=format&fit=crop&w=900&q=80'),
('Wide-Leg Trousers', 2399.00, 'Women', 'High-waist wide-leg trousers with fluid movement and an office-to-evening finish.', 'assets/images/wide-leg-trousers.svg'),
('Pastel Co-ord Set', 3499.00, 'Women', 'Breezy matching co-ord set in soft pastel tones for effortless day dressing.', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80'),
('Embroidered Kurti', 1599.00, 'Women', 'Light embroidered kurti with everyday comfort and a polished ethnic touch.', 'assets/images/embroidered-kurti.svg'),
('Rainbow Dungarees', 1399.00, 'Kids', 'Cheerful dungarees made for birthday parties, playground plans, and tiny adventures.', 'https://images.unsplash.com/photo-1522771930-78848d9293e8?auto=format&fit=crop&w=900&q=80'),
('Graphic Tee Pack', 899.00, 'Kids', 'Two soft graphic tees with playful prints for everyday school and weekend wear.', 'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?auto=format&fit=crop&w=900&q=80'),
('Mini Denim Jacket', 1499.00, 'Kids', 'Classic mini denim jacket that layers over dresses, tees, and tiny superhero poses.', 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?auto=format&fit=crop&w=900&q=80'),
('Printed Party Dress', 1799.00, 'Kids', 'Bright printed party dress with a comfy fit for celebrations and family photos.', 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?auto=format&fit=crop&w=900&q=80');
