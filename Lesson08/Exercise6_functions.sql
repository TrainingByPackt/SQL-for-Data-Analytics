DROP FUNCTION get_stock;
CREATE FUNCTION get_stock(TEXT) RETURNS integer AS $stock_val$
DECLARE stock_val integer;
BEGIN
    SELECT stock INTO stock_val FROM products WHERE product_code=$1;
RETURN stock_val;
END; $stock_val$
LANGUAGE PLPGSQL;

DROP FUNCTION update_stock;
CREATE FUNCTION update_stock() RETURNS integer AS $stock_qty$
DECLARE
    stock_qty integer;
    _order_id integer;
    _prod_code TEXT;
BEGIN
    SELECT max(order_id) INTO _order_id FROM order_info; 
    SELECT qty INTO stock_qty FROM order_info WHERE order_id= _order_id;
    SELECT product_code INTO _prod_code FROM order_info WHERE order_id=_order_id;
    stock_qty := get_stock(_prod_code) - stock_qty;
    UPDATE products SET stock = stock_qty WHERE product_code=_prod_code; 
RETURN stock_qty;
END; $stock_qty$
LANGUAGE PLPGSQL;

DROP FUNCTION insert_order;
CREATE FUNCTION insert_order(integer, TEXT, integer) RETURNS integer AS $new_order_id$
DECLARE
   new_order_id integer;
BEGIN
    SELECT MAX(order_id) INTO new_order_id FROM order_info;
    new_order_id := new_order_id + 1;
    INSERT INTO order_info (order_id, customer_id, product_code, qty) VALUES
        (new_order_id, $1, $2, $3);
RETURN new_order_id;
END; $new_order_id$
LANGUAGE PLPGSQL;
