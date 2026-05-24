-- =========================================
-- Naming Convention Used in This Lab
-- =========================================

-- This lab uses snake_case naming throughout the database design.

-- Examples:
-- -> customer_order
-- -> order_detail
-- -> payment_method
-- -> branch_code

-- Other common naming conventions include:

-- -> PascalCase
--    Example:
--    CustomerOrder
--    PaymentMethod

-- -> camelCase
--    Example:
--    customerOrder
--    paymentMethod

-- -> lowercase
--    Example:
--    customerorder
--    paymentmethod

-- In PostgreSQL, snake_case is commonly preferred because:
-- -> it improves readability
-- -> it avoids issues with quoted identifiers
-- -> it works well with SQL tools, ORMs, and analytics systems
-- -> it is widely used in production PostgreSQL environments

-- The most important principle is **consistency**.
-- Once a naming convention is chosen, it should be applied consistently
-- throughout the database schema.

-- =========================================

-- We first create the database and user with **appropriate** permissions, 
-- then we create the tables. This is a more secure approach than granting 
-- excessive privileges to the application user.

-- =========================================

-- The security principle in this case is:
-- Assume credentials will eventually leak.
-- Then, design "damage containment" in advance.

-- =========================================

-- In a production environment, separate roles are commonly used for:

-- -> Database Administration (_db_admin):
--    Database setup, schema management, maintenance, and security

-- -> Application Runtime (_app_runtime):
--    CRUD operations performed by the Information System application

-- -> Data Analytics / Reporting (_analytics):
--    Read-only access for dashboards, BI tools, analytics, and AI workflows

-- -> Backup / Recovery (_backup):
--    Read-only access for database backups, recovery operations,
--    and disaster recovery procedures

-- =========================================

-- In a production environment, you would replace 'siwaka_dishes_' with the name
-- of the specific Information System or application.

-- You would also use strong, unique passwords for each role, and you would not
-- hard-code credentials in application code or scripts. Instead, you would use
-- environment variables to manage sensitive information.

-- Each Information System would therefore have its own:
-- -> database administrator user
-- -> application runtime user
-- -> analytics/reporting user
-- -> backup/recovery user

-- This approach improves security through isolation and least privilege.

-- If credentials for one Information System are compromised, the damage is
-- contained to that specific system and database, reducing the risk of
-- lateral movement into other databases, applications, or services.

-- =========================================
-- Create database administrator role
-- =========================================

CREATE USER siwaka_dishes_db_admin
WITH PASSWORD 'siwaka_dishes_db_admin';

-- =========================================
-- Create application runtime role
-- Used by the Information System for CRUD
-- =========================================

CREATE USER siwaka_dishes_app_runtime
WITH PASSWORD 'siwaka_dishes_app_runtime';

-- =========================================
-- Create analytics/reporting role
-- Used for dashboards and data analytics in BI
-- =========================================

CREATE USER siwaka_dishes_analytics
WITH PASSWORD 'siwaka_dishes_analytics';

-- =========================================
-- Create backup/recovery role
-- =========================================

CREATE USER siwaka_dishes_backup
WITH PASSWORD 'siwaka_dishes_backup';

-- =========================================
-- Create database
-- =========================================

CREATE DATABASE siwaka_dishes
OWNER siwaka_dishes_db_admin;

-- =========================================
-- Connect to database
--
-- IMPORTANT:
-- Tables should be created while connected as
-- siwaka_dishes_db_admin, otherwise the default
-- privileges below may not apply as expected.
--
-- Tables will normally be created inside the
-- public schema.
-- Example:
-- public.branch
-- =========================================

-- psql -U siwaka_dishes_db_admin -d siwaka_dishes -h localhost


-- \c siwaka_dishes
-- public.branch

-- =========================================
-- Secure the database and the public schema
-- =========================================

REVOKE ALL ON DATABASE siwaka_dishes FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- =========================================
-- Transfer schema ownership
-- =========================================

ALTER SCHEMA public OWNER TO siwaka_dishes_db_admin;

-- =========================================
-- Allow runtime, analytics, and backup users
-- to access the schema
-- =========================================

GRANT USAGE ON SCHEMA public
TO siwaka_dishes_app_runtime;

GRANT USAGE ON SCHEMA public
TO siwaka_dishes_analytics;

GRANT USAGE ON SCHEMA public
TO siwaka_dishes_backup;

-- =========================================
-- Runtime user permissions (CRUD)
-- =========================================

GRANT
    SELECT,
    INSERT,
    UPDATE,
    DELETE
ON ALL TABLES IN SCHEMA public
TO siwaka_dishes_app_runtime;

-- =========================================
-- Runtime sequence permissions
-- Needed for SERIAL / IDENTITY columns
-- =========================================

GRANT
    USAGE,
    SELECT
ON ALL SEQUENCES IN SCHEMA public
TO siwaka_dishes_app_runtime;

-- =========================================
-- Analytics user permissions
-- Read-only access
-- =========================================

GRANT
    SELECT
ON ALL TABLES IN SCHEMA public
TO siwaka_dishes_analytics;

-- =========================================
-- Allow read-only access to all tables
-- =========================================

GRANT
    SELECT
ON ALL TABLES IN SCHEMA public
TO siwaka_dishes_backup;

-- =========================================
-- Future-proof runtime permissions
-- New tables inherit CRUD permissions
-- =========================================

ALTER DEFAULT PRIVILEGES
FOR ROLE siwaka_dishes_db_admin
IN SCHEMA public
GRANT
    SELECT,
    INSERT,
    UPDATE,
    DELETE
ON TABLES TO siwaka_dishes_app_runtime;

ALTER DEFAULT PRIVILEGES
FOR ROLE siwaka_dishes_db_admin
IN SCHEMA public
GRANT
    USAGE,
    SELECT
ON SEQUENCES TO siwaka_dishes_app_runtime;

-- =========================================
-- Future-proof analytics permissions
-- New tables inherit read-only access
-- =========================================

ALTER DEFAULT PRIVILEGES
FOR ROLE siwaka_dishes_db_admin
IN SCHEMA public
GRANT
    SELECT
ON TABLES TO siwaka_dishes_analytics;

-- =========================================
-- Future-proof backup permissions
-- =========================================

ALTER DEFAULT PRIVILEGES
FOR ROLE siwaka_dishes_db_admin
IN SCHEMA public
GRANT
    SELECT
ON TABLES TO siwaka_dishes_backup;

/* =========================================================

-- If you need to change passwords later:

ALTER USER siwaka_dishes_db_admin
WITH PASSWORD 'new_strong_password';

ALTER USER siwaka_dishes_app_runtime
WITH PASSWORD 'new_strong_password';

ALTER USER siwaka_dishes_analytics
WITH PASSWORD 'new_strong_password';

ALTER USER siwaka_dishes_backup
WITH PASSWORD 'new_strong_password';

========================================================= */


/* =========================================================

-- If you need to remove the Information System later:

-- IMPORTANT:
-- You must terminate active connections before dropping
-- the database.

========================================================= */

-- Disconnect active users from the database

/*

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'siwaka_dishes'
  AND pid <> pg_backend_pid();

-- Drop the database

DROP DATABASE IF EXISTS siwaka_dishes;

-- Drop the users/roles

DROP USER IF EXISTS siwaka_dishes_backup;

DROP USER IF EXISTS siwaka_dishes_analytics;

DROP USER IF EXISTS siwaka_dishes_app_runtime;

DROP USER IF EXISTS siwaka_dishes_db_admin;

*/

-- We wrap the table creation in a transaction, so that if any step fails, we can roll back to a clean state.

BEGIN;

-- List of tables to create (in the specified order):
-- 1. branch
-- 2. employee
-- 3. customer
-- 4. order_status
-- 5. customer_order
-- 6. product_category
-- 7. product
-- 8. payment_method
-- 9. payment
-- 10. order_detail
-- 11. customer_feedback

-- =========================================
-- Drop tables based on dependency order
-- =========================================

DROP TABLE IF EXISTS customer_feedback CASCADE;
DROP TABLE IF EXISTS order_detail CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS payment_method CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS product_category CASCADE;
DROP TABLE IF EXISTS customer_order CASCADE;
DROP TABLE IF EXISTS order_status CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS branch CASCADE;

-- =========================================
-- Create branch Table
-- =========================================

CREATE TABLE branch (
    branch_code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    sub_county VARCHAR(50) NOT NULL
);

-- =========================================
-- Create employee Table
-- =========================================

CREATE TABLE employee (
    employee_number INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    branch_code INT NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    reports_to INT,

    CONSTRAINT fk_1_branch_to_m_employee
    FOREIGN KEY (branch_code)
    REFERENCES branch(branch_code)
    ON DELETE CASCADE,

    CONSTRAINT fk_1_employee_to_m_employee
    FOREIGN KEY (reports_to)
    REFERENCES employee(employee_number)
    ON DELETE SET NULL
);

-- =========================================
-- Create customer Table
-- =========================================

CREATE TABLE customer (
    customer_number INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    contact_first_name VARCHAR(50) NOT NULL,
    contact_last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    sub_county VARCHAR(50) NOT NULL,
    status SMALLINT NOT NULL
);

-- =========================================
-- Create order_status Table
-- =========================================

CREATE TABLE order_status (
    order_status_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================
-- Create customer_order Table
-- =========================================

CREATE TABLE customer_order (
    order_number INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date TIMESTAMP NOT NULL,
    required_date TIMESTAMP NOT NULL,
    dispatch_date TIMESTAMP,

    order_status_id INT NOT NULL,
    customer_number INT NOT NULL,
    branch_code INT NOT NULL,

    CONSTRAINT fk_1_customer_to_m_customer_order
    FOREIGN KEY (customer_number)
    REFERENCES customer(customer_number)
    ON DELETE CASCADE,

    CONSTRAINT fk_1_order_status_to_m_customer_order
    FOREIGN KEY (order_status_id)
    REFERENCES order_status(order_status_id),

    CONSTRAINT fk_1_branch_to_m_customer_order
    FOREIGN KEY (branch_code)
    REFERENCES branch(branch_code)
);

-- =========================================
-- Create product_category Table
-- =========================================

CREATE TABLE product_category (
    product_category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_description TEXT
);

-- =========================================
-- Create product Table
-- =========================================

CREATE TABLE product (
    product_code VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT NOT NULL,

    quantity_in_stock INT NOT NULL
    CHECK (quantity_in_stock >= 0),

    cost_of_production DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,

    product_category_id INT,

    CONSTRAINT fk_1_product_category_to_m_product
    FOREIGN KEY (product_category_id)
    REFERENCES product_category(product_category_id)
    ON DELETE SET NULL
);

-- =========================================
-- Create payment_method Table
-- =========================================

CREATE TABLE payment_method (
    payment_method_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_method VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================
-- Create payment Table
-- =========================================

CREATE TABLE payment (
    payment_number INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_number INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
    CHECK (amount >= 0),

    payment_method_id INT NOT NULL,

    CONSTRAINT fk_1_customer_order_to_m_payment
    FOREIGN KEY (order_number)
    REFERENCES customer_order(order_number)
    ON DELETE CASCADE,

    CONSTRAINT fk_1_payment_method_to_m_payment
    FOREIGN KEY (payment_method_id)
    REFERENCES payment_method(payment_method_id)
);

-- =========================================
-- Create order_detail Table
-- =========================================

CREATE TABLE order_detail (
    order_detail_number INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_number INT NOT NULL,
    product_code VARCHAR(20) NOT NULL,

    quantity_ordered INT NOT NULL
    CHECK (quantity_ordered > 0),

    price_each DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_1_customer_order_to_m_order_details
    FOREIGN KEY (order_number)
    REFERENCES customer_order(order_number)
    ON DELETE CASCADE,

    CONSTRAINT fk_1_product_to_m_order_details
    FOREIGN KEY (product_code)
    REFERENCES product(product_code)
);

-- =========================================
-- Create customer_feedback Table
-- =========================================

CREATE TABLE customer_feedback (
    customer_feedback_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    food_quality INT,
    service_quality INT,
    price_to_value INT,
    ambiance INT,

    order_number INT NOT NULL,

    comment TEXT,

    CONSTRAINT fk_1_customer_order_to_m_customer_feedback
    FOREIGN KEY (order_number)
    REFERENCES customer_order(order_number)
);

COMMIT;