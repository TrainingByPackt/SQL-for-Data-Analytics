DROP FUNCTION update_stock;
CREATE FUNCTION update_stock() RETURNS TRIGGER AS $stock_trigger$
DECLARE
    stock_qty integer;
BEGIN
    stock_qty := get_stock(NEW.product_code) - NEW.qty;
    UPDATE products SET stock = stock_qty WHERE product_code=NEW.product_code; 
    RETURN NEW;
END; $stock_trigger$
LANGUAGE PLPGSQL;

CREATE TRIGGER update_trigger
AFTER INSERT ON order_info
FOR EACH ROW
    EXECUTE PROCEDURE update_stock();
