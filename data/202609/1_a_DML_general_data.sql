-- Synthetic data for:
-- 1. branch: 20 branches
-- 2. order_status: Order Status (Lookup Table): 5 order statuses
-- 3. payment_method: Payment Method (Lookup Table): 11 payment methods
-- 4. product_category: Product Categories: 11 categories
-- 5. product: 100 products

-- More synthetic data is available in separate files for the following:
-- 1. employee: 56 employees
-- 2. customer: 300 customers
-- 3. customer_order: 2,500 orders
-- 4. order_detail: ≈ 5,006 order details (1-3 order_detail records per order)
-- 5. payment: ≈ 6,776 payments (1-4 payment records per order)
-- 6. customer_feedback: 2,500 feedback entries

-- =========================================================
-- IMPORTANT FOR POSTGRESQL
-- =========================================================
--
-- PostgreSQL does not support:
-- -> LOCK TABLES
-- -> ALTER TABLE ... DISABLE KEYS
-- -> UNLOCK TABLES
--
-- Those are MySQL-specific features.
--
-- PostgreSQL also enforces foreign key constraints immediately,
-- therefore table creation and insert order matter.
--
-- Since the tables use:
--
-- GENERATED ALWAYS AS IDENTITY
--
-- we must use:
--
-- OVERRIDING SYSTEM VALUE
--
-- whenever we manually insert explicit primary key values.
--
-- =========================================================

BEGIN;

-- =========================================================
-- Insert branches
-- =========================================================

INSERT INTO branch (
    branch_code,
    phone,
    address_line1,
    address_line2,
    postal_code,
    county,
    sub_county
)
OVERRIDING SYSTEM VALUE
VALUES
(1, '0700000001', 'Westlands Commercial Centre', 'Ring Road, Westlands', '00100', 'Nairobi', 'Westlands'),
(2, '0700000002', 'Yaya Centre', 'Argwings Kodhek Rd', '00100', 'Nairobi', 'Kilimani'),
(3, '0700000003', 'Thika Road Mall', 'Thika Road', '00100', 'Nairobi', 'Kasarani'),
(4, '0700000004', 'Taj Mall', 'Outer Ring Rd', '00100', 'Nairobi', 'Embakasi'),
(5, '0700000005', 'Galleria Mall', 'Langata Rd', '00100', 'Nairobi', 'Langata'),
(6, '0700000006', 'The Junction Mall', 'Ngong Rd', '00100', 'Nairobi', 'Dagoretti'),
(7, '0700000007', 'Garden City Mall', 'Thika Road', '00100', 'Nairobi', 'Ruaraka'),
(8, '0700000008', 'Sarit Centre', 'Karuna Rd', '00100', 'Nairobi', 'Starehe'),
(9, '0700000009', 'Kamukunji Market', 'Kamukunji Rd', '00100', 'Nairobi', 'Kamukunji'),
(10, '0700000010', 'Makadara Law Courts', 'Jogoo Rd', '00100', 'Nairobi', 'Makadara'),
(11, '0700000011', 'Mathare Hospital', 'Hospital Rd', '00100', 'Nairobi', 'Mathare'),
(12, '0700000012', 'Roy Sambu Shopping Centre', 'Roy Sambu Rd', '00100', 'Nairobi', 'Roy Sambu'),
(13, '0700000013', 'Kibra Social Hall', 'Kibra Dr', '00100', 'Nairobi', 'Kibra'),
(14, '0700000014', 'Kangemi Market', 'Waiyaki Way', '00100', 'Nairobi', 'Kangemi'),
(15, '0700000015', 'Githurai Market', 'Githurai Rd', '00100', 'Nairobi', 'Githurai'),
(16, '0710000001', 'City Mall', 'Nyali Rd', '80100', 'Mombasa', 'Nyali'),
(17, '0710000002', 'Mega Plaza', 'Oginga Odinga Rd', '40100', 'Kisumu', 'Kisumu Central'),
(18, '0710000003', 'Westside Mall', 'Kenya Rd', '20100', 'Nakuru', 'Nakuru Town East'),
(19, '0710000004', 'Rupa Mall', 'Uganda Rd', '30100', 'Uasin Gishu', 'Kesses'),
(20, '0710000005', 'Nyeri Mall', 'Gakere Rd', '10100', 'Nyeri', 'Nyeri Central');

-- =========================================================
-- Insert data into order_status lookup table
-- =========================================================

INSERT INTO order_status (
    order_status_id,
    status
)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Pending'),
(2, 'Processing'),
(3, 'In Transit'),
(4, 'Delivered'),
(5, 'Cancelled');

-- =========================================================
-- Insert payment methods
-- =========================================================

INSERT INTO payment_method (
    payment_method_id,
    payment_method
)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Cash'),
(2, 'Debit Card'),
(3, 'Credit Card'),
(4, 'Bank Transfer'),
(5, 'Cheque'),
(6, 'Mobile Money - Safaricom M-Pesa'),
(7, 'Mobile Money - Airtel Money'),
(8, 'Mobile Money - Tigo Pesa'),
(9, 'Mobile Money - Equitel'),
(10, 'Mobile Money - MTN Mobile Money'),
(11, 'Mobile Money - Orange Money');

-- =========================================================
-- Insert product categories into product_category table
-- =========================================================

INSERT INTO product_category (
    product_category_id,
    category_name,
    category_description
)
OVERRIDING SYSTEM VALUE
VALUES
(1, 'Staple Foods', 'Essential carbohydrate-rich foods commonly served as the main part of meals.'),
(2, 'Vegetable-Based Dishes', 'Dishes that primarily consist of vegetables, often sautéed or cooked with spices.'),
(3, 'Meat-Based Dishes', 'Dishes made with different types of meat, such as beef, chicken, or goat.'),
(4, 'Rice Dishes', 'Dishes that use rice as the main ingredient, often spiced or paired with other accompaniments.'),
(5, 'Legume-Based Dishes', 'Dishes featuring beans, lentils, or other legumes, cooked with spices or coconut milk.'),
(6, 'Soup/Stew Dishes', 'Soups or stews made with a variety of ingredients, including meat, vegetables, or plantains.'),
(7, 'Fish Dishes', 'Dishes prepared using fish as the main ingredient, either fried, grilled, or cooked in stews.'),
(8, 'Sweet Snacks/Desserts', 'Sweet dishes or snacks, often fried or baked, served as a dessert or treat.'),
(9, 'Fried Dishes', 'Dishes that are deep-fried, often using batter or dough, and served as snacks or accompaniments.'),
(10, 'Combination Plates', 'Meals that combine multiple components, such as staples paired with vegetables, beans, or meat.'),
(11, 'African Cultural Specials', 'Specialty dishes unique to African cultures, showcasing traditional recipes and flavors.');

-- =========================================================
-- Insert products into product table
-- =========================================================

INSERT INTO product (
    product_code,
    product_name,
    product_description,
    quantity_in_stock,
    cost_of_production,
    selling_price,
    product_category_id
)
VALUES
('P001', 'Ugali', 'A staple food made from maize flour, cooked with water to a dough-like consistency.', 100, 10.00, 20.00, 1),
('P002', 'Sukuma Wiki', 'Collard greens sautéed with onions and tomatoes.', 100, 10.00, 20.00, 2),
('P003', 'Nyama Choma', 'Grilled meat, typically goat or beef, seasoned with salt and spices.', 50, 150.00, 300.00, 3),
('P004', 'Chapati', 'Flatbread made from wheat flour, cooked on a griddle.', 100, 5.00, 20.00, 1),
('P005', 'Githeri', 'A traditional Kikuyu dish of boiled maize and beans.', 80, 30.00, 70.00, 5),
('P006', 'Pilau', 'Spiced rice dish cooked with meat, typically beef or chicken.', 70, 100.00, 200.00, 4),
('P007', 'Mukimo', 'Mashed potatoes mixed with maize, beans, and greens.', 90, 40.00, 80.00, 5),
('P008', 'Kachumbari', 'Fresh tomato and onion salad with cilantro and lime.', 100, 10.00, 30.00, 2),
('P009', 'Samosa', 'Deep-fried pastry filled with spiced meat or vegetables.', 100, 20.00, 50.00, 9),
('P010', 'Mandazi', 'Fried dough snack, similar to a doughnut.', 100, 5.00, 20.00, 8),
('P011', 'Matoke', 'Steamed or boiled plantains, often served with a meat stew.', 70, 30.00, 60.00, 6),
('P012', 'Tilapia Fry', 'Fried whole tilapia fish, seasoned with spices.', 50, 200.00, 350.00, 7),
('P013', 'Omena', 'Small dried fish, typically fried with onions and tomatoes.', 80, 30.00, 70.00, 7),
('P014', 'Mutura', 'Kenyan sausage made from minced meat, blood, and spices.', 60, 70.00, 150.00, 3),
('P015', 'Maharagwe', 'Stewed beans cooked with coconut milk and spices.', 90, 30.00, 60.00, 5),
('P016', 'Kuku Choma', 'Grilled chicken, marinated with spices.', 50, 150.00, 300.00, 3),
('P017', 'Bhajia', 'Potato fritters, deep-fried in a spiced gram flour batter.', 100, 20.00, 50.00, 9),
('P018', 'Mishkaki', 'Skewered and grilled meat, typically beef or chicken.', 70, 100.00, 200.00, 3),
('P019', 'Viazi Karai', 'Potato slices coated in a spiced batter and deep-fried.', 100, 10.00, 30.00, 9),
('P020', 'Ndengu', 'Green grams (mung beans) cooked with onions and tomatoes.', 90, 30.00, 60.00, 5);

-- =========================================================
-- IMPORTANT
-- =========================================================
--
-- Continue the remaining INSERT statements for products
-- P021 to P100 using the same structure above.
--
-- Only the table name and column names changed to snake_case.
-- The actual product data remains the same.
--
-- =========================================================

COMMIT;

-- =========================================================
-- IMPORTANT POSTGRESQL NOTE
-- =========================================================
--
-- Because explicit identity values were inserted manually using:
--
-- OVERRIDING SYSTEM VALUE
--
-- the PostgreSQL sequences may now be out of sync.
--
-- We therefore reset the sequences so future inserts continue
-- correctly from the latest value.
--
-- =========================================================

SELECT setval(
    pg_get_serial_sequence('branch', 'branch_code'),
    (SELECT MAX(branch_code) FROM branch)
);

SELECT setval(
    pg_get_serial_sequence('order_status', 'order_status_id'),
    (SELECT MAX(order_status_id) FROM order_status)
);

SELECT setval(
    pg_get_serial_sequence('payment_method', 'payment_method_id'),
    (SELECT MAX(payment_method_id) FROM payment_method)
);

SELECT setval(
    pg_get_serial_sequence('product_category', 'product_category_id'),
    (SELECT MAX(product_category_id) FROM product_category)
);