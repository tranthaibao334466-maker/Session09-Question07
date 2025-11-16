-- Tạo bảng Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

INSERT INTO Customers (customer_id, name, email) VALUES
(1, 'Alice Nguyen', 'alice@example.com'),
(2, 'Bao Tran', 'bao@example.com');

-- Tạo bảng Orders (Giả định)
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REDFERENCES Customers(customer_id),
    amount NUMERIC(10, 2),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE add_order(
    p_customer_id INT,
    p_amount NUMERIC
)
LANGUAGE plpgsql 
AS $$
BEGIN
    IF (SELECT 1 FROM Customers WHERE customer_id = p_customer_id) IS NULL THEN
        RAISE EXCEPTION 'Khách hàng (customer_id: %) không tồn tại. Không thể thêm đơn hàng.', p_customer_id;
    END IF;
    INSERT INTO Orders (customer_id, amount, order_date)
    VALUES (p_customer_id, p_amount, NOW());
    RAISE NOTICE 'Đã thêm đơn hàng thành công cho customer_id: %', p_customer_id;
END;
$$;

CALL add_order(1, 199.99);

SELECT * FROM Orders;

CALL add_order(99, 50.00);
