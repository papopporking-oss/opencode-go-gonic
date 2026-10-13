
-- 1. erp_users
CREATE TABLE public.erp_users (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    username varchar(100) NOT NULL,
    email varchar(255) NOT NULL,
    password_hash varchar(255) NOT NULL,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'active',

    CONSTRAINT erp_users_pkey PRIMARY KEY (id),
    CONSTRAINT erp_users_email_key UNIQUE (email),
    CONSTRAINT erp_users_username_key UNIQUE (username)
);


-- 2. erp_roles
CREATE TABLE public.erp_roles (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    role_name varchar(100) NOT NULL,
    description text,
    status varchar(20) NOT NULL DEFAULT 'active',

    CONSTRAINT erp_roles_pkey PRIMARY KEY (id),
    CONSTRAINT erp_roles_role_name_key UNIQUE (role_name)
);


-- 3. erp_user_roles
CREATE TABLE public.erp_user_roles (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    user_id bigint NOT NULL,
    role_id bigint NOT NULL,

    CONSTRAINT erp_user_roles_pkey PRIMARY KEY (id),
    CONSTRAINT erp_user_roles_unique UNIQUE (user_id, role_id)
);


-- 4. erp_customers
CREATE TABLE public.erp_customers (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    customer_code varchar(50) NOT NULL,
    customer_name varchar(255) NOT NULL,
    email varchar(255),
    phone varchar(50),
    address text,
    status varchar(20) NOT NULL DEFAULT 'active',

    CONSTRAINT erp_customers_pkey PRIMARY KEY (id),
    CONSTRAINT erp_customers_code_key UNIQUE (customer_code)
);


-- 5. erp_products
CREATE TABLE public.erp_products (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    product_code varchar(50) NOT NULL,
    product_name varchar(255) NOT NULL,
    description text,
    price numeric(15,2) NOT NULL,
    stock_quantity int8 NOT NULL DEFAULT 0,
    status varchar(20) NOT NULL DEFAULT 'active',

    CONSTRAINT erp_products_pkey PRIMARY KEY (id),
    CONSTRAINT erp_products_code_key UNIQUE (product_code)
);


-- 6. erp_orders
CREATE TABLE public.erp_orders (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    order_number varchar(50) NOT NULL,
    customer_id bigint NOT NULL,
    order_date timestamptz NOT NULL DEFAULT now(),
    total_amount numeric(15,2) NOT NULL DEFAULT 0,
    status varchar(30) NOT NULL DEFAULT 'pending',

    CONSTRAINT erp_orders_pkey PRIMARY KEY (id),
    CONSTRAINT erp_orders_number_key UNIQUE (order_number)
);


-- 7. erp_order_items
CREATE TABLE public.erp_order_items (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity int8 NOT NULL,
    unit_price numeric(15,2) NOT NULL,
    total_price numeric(15,2) NOT NULL,

    CONSTRAINT erp_order_items_pkey PRIMARY KEY (id)
);


-- 8. erp_payments
CREATE TABLE public.erp_payments (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    order_id bigint NOT NULL,
    payment_reference varchar(100) NOT NULL,
    payment_method varchar(30) NOT NULL,
    amount numeric(15,2) NOT NULL,
    payment_date timestamptz NOT NULL DEFAULT now(),
    status varchar(30) NOT NULL DEFAULT 'pending',

    CONSTRAINT erp_payments_pkey PRIMARY KEY (id),
    CONSTRAINT erp_payments_reference_key UNIQUE (payment_reference)
);


-- 9. erp_transactions
CREATE TABLE public.erp_transactions (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    transaction_code varchar(100) NOT NULL,
    transaction_type varchar(50) NOT NULL,
    reference_type varchar(50),
    reference_id bigint,
    amount numeric(15,2) NOT NULL DEFAULT 0,
    status varchar(30) NOT NULL DEFAULT 'success',

    CONSTRAINT erp_transactions_pkey PRIMARY KEY (id),
    CONSTRAINT erp_transactions_code_key UNIQUE (transaction_code)
);


-- 10. erp_audit_logs
CREATE TABLE public.erp_audit_logs (
    id bigserial NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    user_id bigint,
    action varchar(50) NOT NULL,
    table_name varchar(100) NOT NULL,
    record_id bigint,
    old_data jsonb,
    new_data jsonb,
    ip_address inet,

    CONSTRAINT erp_audit_logs_pkey PRIMARY KEY (id)
);

-- SAMPLE DATA

-- 1. erp_users
INSERT INTO public.erp_users
(username, email, password_hash, first_name, last_name, status)
VALUES
('admin', 'admin@erp.local', 'hash_admin', 'System', 'Admin', 'active'),
('john.doe', 'john.doe@erp.local', 'hash_001', 'John', 'Doe', 'active'),
('jane.smith', 'jane.smith@erp.local', 'hash_002', 'Jane', 'Smith', 'active'),
('mike.wilson', 'mike.wilson@erp.local', 'hash_003', 'Mike', 'Wilson', 'active'),
('sarah.jones', 'sarah.jones@erp.local', 'hash_004', 'Sarah', 'Jones', 'active'),
('david.brown', 'david.brown@erp.local', 'hash_005', 'David', 'Brown', 'active'),
('emily.davis', 'emily.davis@erp.local', 'hash_006', 'Emily', 'Davis', 'active'),
('robert.miller', 'robert.miller@erp.local', 'hash_007', 'Robert', 'Miller', 'active'),
('lisa.taylor', 'lisa.taylor@erp.local', 'hash_008', 'Lisa', 'Taylor', 'active'),
('tom.anderson', 'tom.anderson@erp.local', 'hash_009', 'Tom', 'Anderson', 'inactive');


-- 2. erp_roles
INSERT INTO public.erp_roles
(role_name, description, status)
VALUES
('ADMIN', 'System administrator', 'active'),
('MANAGER', 'ERP manager', 'active'),
('SALES', 'Sales staff', 'active'),
('ACCOUNTING', 'Accounting staff', 'active'),
('WAREHOUSE', 'Warehouse staff', 'active'),
('PURCHASING', 'Purchasing staff', 'active'),
('HR', 'Human resources staff', 'active'),
('SUPPORT', 'Customer support staff', 'active'),
('AUDITOR', 'System auditor', 'active'),
('VIEWER', 'Read-only user', 'active');


-- 3. erp_user_roles
INSERT INTO public.erp_user_roles
(user_id, role_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- 4. erp_customers
INSERT INTO public.erp_customers
(customer_code, customer_name, email, phone, address, status)
VALUES
('CUS-0001', 'ABC Corporation', 'contact@abc.com', '02-100-1001', 'Bangkok, Thailand', 'active'),
('CUS-0002', 'XYZ Trading', 'contact@xyz.com', '02-100-1002', 'Nonthaburi, Thailand', 'active'),
('CUS-0003', 'Thai Tech Co., Ltd.', 'contact@thaitech.com', '02-100-1003', 'Pathum Thani, Thailand', 'active'),
('CUS-0004', 'Global Foods', 'contact@globalfoods.com', '02-100-1004', 'Samut Prakan, Thailand', 'active'),
('CUS-0005', 'Smart Office', 'contact@smartoffice.com', '02-100-1005', 'Bangkok, Thailand', 'active'),
('CUS-0006', 'Digital Solutions', 'contact@digitalsolutions.com', '02-100-1006', 'Chiang Mai, Thailand', 'active'),
('CUS-0007', 'Future Electronics', 'contact@futureelectronics.com', '02-100-1007', 'Chonburi, Thailand', 'active'),
('CUS-0008', 'Prime Retail', 'contact@primeretail.com', '02-100-1008', 'Bangkok, Thailand', 'active'),
('CUS-0009', 'Asia Logistics', 'contact@asialogistics.com', '02-100-1009', 'Samut Sakhon, Thailand', 'active'),
('CUS-0010', 'Next Generation', 'contact@nextgen.com', '02-100-1010', 'Phuket, Thailand', 'inactive');


-- 5. erp_products
INSERT INTO public.erp_products
(product_code, product_name, description, price, stock_quantity, status)
VALUES
('PRD-0001', 'Laptop Pro 14', 'Business laptop 14 inch', 45000.00, 25, 'active'),
('PRD-0002', 'Wireless Mouse', 'Wireless optical mouse', 850.00, 100, 'active'),
('PRD-0003', 'Mechanical Keyboard', 'Mechanical keyboard', 2500.00, 75, 'active'),
('PRD-0004', '27 Inch Monitor', '27 inch business monitor', 8900.00, 40, 'active'),
('PRD-0005', 'USB-C Hub', 'USB-C multi-port hub', 1500.00, 120, 'active'),
('PRD-0006', 'Office Chair', 'Ergonomic office chair', 6500.00, 30, 'active'),
('PRD-0007', 'Desk 120cm', 'Office desk 120cm', 4800.00, 20, 'active'),
('PRD-0008', 'Network Switch', '24-port network switch', 7200.00, 15, 'active'),
('PRD-0009', 'Laser Printer', 'Business laser printer', 12500.00, 12, 'active'),
('PRD-0010', 'Barcode Scanner', 'USB barcode scanner', 3200.00, 35, 'active');


-- 6. erp_orders
INSERT INTO public.erp_orders
(order_number, customer_id, order_date, total_amount, status)
VALUES
('ORD-2026-0001', 1, '2026-01-05 10:00:00+07', 45850.00, 'completed'),
('ORD-2026-0002', 2, '2026-01-08 11:30:00+07', 2500.00, 'completed'),
('ORD-2026-0003', 3, '2026-01-12 09:15:00+07', 8900.00, 'completed'),
('ORD-2026-0004', 4, '2026-01-15 14:00:00+07', 13000.00, 'paid'),
('ORD-2026-0005', 5, '2026-01-18 15:30:00+07', 6500.00, 'paid'),
('ORD-2026-0006', 6, '2026-01-20 10:45:00+07', 9600.00, 'processing'),
('ORD-2026-0007', 7, '2026-01-22 13:00:00+07', 7200.00, 'processing'),
('ORD-2026-0008', 8, '2026-01-25 09:00:00+07', 12500.00, 'pending'),
('ORD-2026-0009', 9, '2026-01-27 16:00:00+07', 3200.00, 'pending'),
('ORD-2026-0010', 10, '2026-01-30 11:00:00+07', 1500.00, 'cancelled');


-- 7. erp_order_items
INSERT INTO public.erp_order_items
(order_id, product_id, quantity, unit_price, total_price)
VALUES
(1, 1, 1, 45000.00, 45000.00),
(1, 2, 1, 850.00, 850.00),
(2, 3, 1, 2500.00, 2500.00),
(3, 4, 1, 8900.00, 8900.00),
(4, 5, 2, 1500.00, 3000.00),
(4, 9, 1, 10000.00, 10000.00),
(5, 6, 1, 6500.00, 6500.00),
(6, 7, 2, 4800.00, 9600.00),
(7, 8, 1, 7200.00, 7200.00),
(8, 9, 1, 12500.00, 12500.00);


-- 8. erp_payments
INSERT INTO public.erp_payments
(order_id, payment_reference, payment_method, amount, payment_date, status)
VALUES
(1, 'PAY-2026-0001', 'credit_card', 45850.00, '2026-01-05 10:30:00+07', 'success'),
(2, 'PAY-2026-0002', 'bank_transfer', 2500.00, '2026-01-08 12:00:00+07', 'success'),
(3, 'PAY-2026-0003', 'bank_transfer', 8900.00, '2026-01-12 10:00:00+07', 'success'),
(4, 'PAY-2026-0004', 'credit_card', 13000.00, '2026-01-15 14:30:00+07', 'success'),
(5, 'PAY-2026-0005', 'cash', 6500.00, '2026-01-18 16:00:00+07', 'success'),
(6, 'PAY-2026-0006', 'bank_transfer', 9600.00, '2026-01-20 11:00:00+07', 'success'),
(7, 'PAY-2026-0007', 'bank_transfer', 7200.00, '2026-01-22 13:30:00+07', 'success'),
(8, 'PAY-2026-0008', 'credit_card', 12500.00, '2026-01-25 09:30:00+07', 'pending'),
(9, 'PAY-2026-0009', 'cash', 3200.00, '2026-01-27 16:30:00+07', 'pending'),
(10, 'PAY-2026-0010', 'bank_transfer', 1500.00, '2026-01-30 11:30:00+07', 'refunded');


-- 9. erp_transactions
INSERT INTO public.erp_transactions
(transaction_code, transaction_type, reference_type, reference_id, amount, status)
VALUES
('TXN-2026-0001', 'PAYMENT', 'ORDER', 1, 45850.00, 'success'),
('TXN-2026-0002', 'PAYMENT', 'ORDER', 2, 2500.00, 'success'),
('TXN-2026-0003', 'PAYMENT', 'ORDER', 3, 8900.00, 'success'),
('TXN-2026-0004', 'PAYMENT', 'ORDER', 4, 13000.00, 'success'),
('TXN-2026-0005', 'PAYMENT', 'ORDER', 5, 6500.00, 'success'),
('TXN-2026-0006', 'PAYMENT', 'ORDER', 6, 9600.00, 'success'),
('TXN-2026-0007', 'PAYMENT', 'ORDER', 7, 7200.00, 'success'),
('TXN-2026-0008', 'PAYMENT', 'ORDER', 8, 12500.00, 'pending'),
('TXN-2026-0009', 'PAYMENT', 'ORDER', 9, 3200.00, 'pending'),
('TXN-2026-0010', 'REFUND', 'ORDER', 10, 1500.00, 'success');


-- 10. erp_audit_logs
INSERT INTO public.erp_audit_logs
(user_id, action, table_name, record_id, old_data, new_data, ip_address)
VALUES
(1, 'CREATE', 'erp_users', 1, NULL,
 '{"username":"admin","status":"active"}', '127.0.0.1'),

(1, 'CREATE', 'erp_roles', 1, NULL,
 '{"role_name":"ADMIN","status":"active"}', '127.0.0.1'),

(2, 'CREATE', 'erp_customers', 1, NULL,
 '{"customer_code":"CUS-0001"}', '192.168.1.10'),

(3, 'CREATE', 'erp_products', 1, NULL,
 '{"product_code":"PRD-0001","price":45000}', '192.168.1.11'),

(3, 'CREATE', 'erp_orders', 1, NULL,
 '{"order_number":"ORD-2026-0001","status":"pending"}',
 '192.168.1.11'),

(3, 'UPDATE', 'erp_orders', 1,
 '{"status":"pending"}',
 '{"status":"completed"}',
 '192.168.1.11'),

(4, 'CREATE', 'erp_payments', 1, NULL,
 '{"payment_reference":"PAY-2026-0001","amount":45850}',
 '192.168.1.12'),

(5, 'UPDATE', 'erp_products', 1,
 '{"stock_quantity":26}',
 '{"stock_quantity":25}',
 '192.168.1.13'),

(1, 'UPDATE', 'erp_users', 10,
 '{"status":"active"}',
 '{"status":"inactive"}',
 '127.0.0.1'),

(9, 'CREATE', 'erp_audit_logs', 1, NULL,
 '{"action":"CREATE","table_name":"erp_users"}',
 '192.168.1.20');