-- =========================================================
-- First view
-- =========================================================
--
-- This script creates a view named view_payment_data
-- that consolidates payment information.
--
-- Tables involved:
-- payment
-- payment_method
-- customer_order
-- order_status
-- customer
-- branch
--
-- =========================================================

CREATE OR REPLACE VIEW view_payment_data AS
SELECT
       payment.payment_number           AS payment_payment_number,
       customer_order.order_number      AS customer_order_order_number,
       payment.payment_date             AS payment_payment_date,
       payment.amount                   AS payment_amount,
       payment_method.payment_method    AS payment_payment_method,
       order_status.status              AS order_status_status,
       customer_order.customer_number   AS customer_order_customer_number,
       customer_order.branch_code       AS customer_order_branch_code
FROM payment
         INNER JOIN customer_order
                    ON payment.order_number = customer_order.order_number

         INNER JOIN customer
                    ON customer_order.customer_number = customer.customer_number

         INNER JOIN order_status
                    ON customer_order.order_status_id = order_status.order_status_id

         INNER JOIN payment_method
                    ON payment.payment_method_id = payment_method.payment_method_id

         INNER JOIN branch
                    ON customer_order.branch_code = branch.branch_code

ORDER BY payment.payment_date;


-- =========================================================
-- Second view
-- =========================================================
--
-- This script creates a view named
-- view_customer_feedback_data
--
-- The view consolidates:
-- -> customer data
-- -> order data
-- -> feedback data
-- -> product data
-- -> branch data
--
-- Tables involved:
-- customer
-- customer_order
-- customer_feedback
-- order_detail
-- product
-- product_category
-- order_status
-- branch
--
-- =========================================================

CREATE OR REPLACE VIEW view_customer_feedback_data AS
SELECT
       customer.customer_number                         AS customer_customer_number,
       customer.customer_name                           AS customer_customer_name,
       customer.contact_first_name                      AS customer_contact_first_name,
       customer.contact_last_name                       AS customer_contact_last_name,
       customer.phone                                   AS customer_phone,
       customer.address_line1                           AS customer_address_line1,
       customer.address_line2                           AS customer_address_line2,
       customer.postal_code                             AS customer_postal_code,
       customer.county                                  AS customer_county,
       customer.sub_county                              AS customer_sub_county,
       customer.status                                  AS customer_status,

       customer_order.order_number                      AS customer_order_order_number,
       customer_order.order_date                        AS customer_order_order_date,
       customer_order.required_date                     AS customer_order_required_date,
       customer_order.dispatch_date                     AS customer_order_dispatch_date,
       customer_order.order_status_id                   AS customer_order_order_status_id,
       customer_order.customer_number                   AS customer_order_customer_number,

       customer_feedback.customer_feedback_id           AS customer_feedback_customer_feedback_id,
       customer_feedback.food_quality                   AS customer_feedback_food_quality,
       customer_feedback.service_quality                AS customer_feedback_service_quality,
       customer_feedback.price_to_value                 AS customer_feedback_price_to_value,
       customer_feedback.ambiance                       AS customer_feedback_ambiance,
       customer_feedback.comment                        AS customer_feedback_comment,

       order_detail.product_code                        AS order_detail_product_code,
       order_detail.quantity_ordered                    AS order_detail_quantity_ordered,
       order_detail.price_each                          AS order_detail_price_each,

       product.product_name                             AS product_product_name,
       product.product_description                      AS product_product_description,
       product.quantity_in_stock                        AS product_quantity_in_stock,
       product.cost_of_production                       AS product_cost_of_production,
       product.selling_price                            AS product_selling_price,

       product_category.product_category_id             AS product_category_product_category_id,
       product_category.category_name                   AS product_category_category_name,
       product_category.category_description            AS product_category_category_description,

       order_status.order_status_id                     AS order_status_order_status_id,
       order_status.status                              AS order_status_status,

       branch.branch_code                               AS branch_branch_code,
       branch.phone                                     AS branch_phone,
       branch.address_line1                             AS branch_address_line1,
       branch.address_line2                             AS branch_address_line2,
       branch.postal_code                               AS branch_postal_code,
       branch.county                                    AS branch_county,
       branch.sub_county                                AS branch_sub_county

FROM customer

         LEFT OUTER JOIN customer_order
                         ON customer_order.customer_number =
                            customer.customer_number

         LEFT OUTER JOIN customer_feedback
                         ON customer_order.order_number =
                            customer_feedback.order_number

         INNER JOIN order_detail
                    ON customer_order.order_number =
                       order_detail.order_number

         INNER JOIN product
                    ON order_detail.product_code =
                       product.product_code

         INNER JOIN product_category
                    ON product.product_category_id =
                       product_category.product_category_id

         LEFT OUTER JOIN order_status
                         ON customer_order.order_status_id =
                            order_status.order_status_id

         INNER JOIN branch
                    ON customer_order.branch_code =
                       branch.branch_code;


-- =========================================================
-- 3. Branch data
-- =========================================================

SELECT
       branch_code   AS branch_branch_code,
       phone         AS branch_phone,
       address_line1 AS branch_address_line1,
       address_line2 AS branch_address_line2,
       postal_code   AS branch_postal_code,
       county        AS branch_county,
       sub_county    AS branch_sub_county
FROM branch;


-- =========================================================
-- 4. Customer data
-- =========================================================

SELECT
       customer_number AS customer_customer_number,
       customer_name   AS customer_customer_name,
       CASE
           WHEN POSITION('[Business]' IN customer_name) > 0
           THEN 'Business'
           ELSE 'Individual'
       END AS customer_customer_type,

       contact_first_name AS customer_contact_first_name,
       contact_last_name  AS customer_contact_last_name,
       phone              AS customer_phone,
       address_line1      AS customer_address_line1,
       address_line2      AS customer_address_line2,
       postal_code        AS customer_postal_code,
       county             AS customer_county,
       sub_county         AS customer_sub_county,

       CONCAT(county, ', Kenya') AS customer_customer_location,

       status AS customer_status,

       CASE
           WHEN status = 1
           THEN 'Active'
           ELSE 'Dormant'
       END AS customer_status_text

FROM customer;


-- =========================================================
-- 5. Third view
-- =========================================================
--
-- This script creates a view named
-- view_revenue_per_month_per_branch
--
-- The view calculates:
-- -> total revenue
-- -> number of orders
-- -> average payment amount
--
-- grouped by:
-- -> month
-- -> branch
--
-- =========================================================

CREATE OR REPLACE VIEW view_revenue_per_month_per_branch AS
SELECT
       TO_CHAR(payment.payment_date, 'YYYY-MM') AS month,

       branch.county AS branch_county,

       SUM(payment.amount) AS total_revenue,

       COUNT(DISTINCT customer_order.order_number)
       AS number_of_orders,

       AVG(payment.amount) AS avg_payment_amount

FROM payment

         INNER JOIN customer_order
                    ON payment.order_number =
                       customer_order.order_number

         INNER JOIN order_status
                    ON customer_order.order_status_id =
                       order_status.order_status_id

         INNER JOIN branch
                    ON customer_order.branch_code =
                       branch.branch_code

WHERE order_status.order_status_id IN (2, 3, 4)

GROUP BY
         month,
         branch.county

ORDER BY month;


-- =========================================================
-- 6. Fourth view
-- =========================================================
--
-- This view calculates product-level profit analysis.
--
-- =========================================================

CREATE OR REPLACE VIEW view_profit_per_product AS
SELECT
       TO_CHAR(payment.payment_date, 'YYYY-MM-DD')
       AS payment_date,

       customer_order.order_number
       AS order_number,

       customer.customer_name
       AS customer_name,

       branch.sub_county
       AS branch_sub_county,

       branch.county
       AS branch_county,

       product.product_name
       AS product_name,

       product_category.category_name
       AS category_name,

       order_detail.quantity_ordered
       AS quantity_ordered,

       product.cost_of_production
       AS cost_of_production_per_unit,

       product.selling_price
       AS selling_price_per_unit,

       (product.selling_price - product.cost_of_production)
       AS profit_per_unit,

       ROUND(
           (
               (product.selling_price - product.cost_of_production)
               /
               product.cost_of_production
           ) * 100,
           2
       ) AS percentage_profit_per_unit

FROM payment

         INNER JOIN customer_order
                    ON payment.order_number =
                       customer_order.order_number

         INNER JOIN customer
                    ON customer_order.customer_number =
                       customer.customer_number

         INNER JOIN order_status
                    ON customer_order.order_status_id =
                       order_status.order_status_id

         INNER JOIN order_detail
                    ON customer_order.order_number =
                       order_detail.order_number

         INNER JOIN product
                    ON order_detail.product_code =
                       product.product_code

         INNER JOIN product_category
                    ON product.product_category_id =
                       product_category.product_category_id

         INNER JOIN branch
                    ON customer_order.branch_code =
                       branch.branch_code

WHERE order_status.order_status_id IN (2, 3, 4)

ORDER BY
         payment_date,
         order_number;