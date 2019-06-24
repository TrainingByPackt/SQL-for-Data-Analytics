CREATE FUNCTION avg_qty() RETURNS TRIGGER AS $_avg$
DECLARE _avg numeric;
BEGIN
    SELECT AVG(qty) INTO _avg FROM order_info;
    INSERT INTO avg_qty_log (order_id, avg_qty) VALUES (NEW.order_id, _avg);
    RETURN NEW;
END; $_avg$
LANGUAGE PLPGSQL;
