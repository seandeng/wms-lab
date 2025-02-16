-- 1. 货主表（Storer）
CREATE TABLE Storer (
    storer_key VARCHAR(50) PRIMARY KEY, -- 货主唯一标识
    name VARCHAR(100) NOT NULL,         -- 货主名称
    contact VARCHAR(100),               -- 联系人
    phone VARCHAR(20),                  -- 联系电话
    email VARCHAR(100),                 -- 邮箱地址
    address VARCHAR(255)                -- 货主地址
);

-- 2. 仓库表（Facility）
CREATE TABLE Facility (
    facility_id INT IDENTITY(1,1) PRIMARY KEY, -- 仓库唯一标识
    name VARCHAR(100) NOT NULL,                -- 仓库名称
    location VARCHAR(100),                     -- 仓库位置
    capacity INT,                              -- 仓库容量
    storer_key VARCHAR(50) NOT NULL,           -- 关联货主
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key)
);

-- 3. 产品表（Product）
CREATE TABLE Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,  -- 产品唯一标识
    name VARCHAR(100) NOT NULL,                -- 产品名称
    description TEXT,                          -- 产品描述
    sku VARCHAR(50) UNIQUE,                    -- SKU 编号
    unit VARCHAR(20)                           -- 计量单位
);

-- 4. 库存表（Inventory）
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY, -- 库存唯一标识
    product_id INT NOT NULL,                    -- 产品 ID
    storer_key VARCHAR(50) NOT NULL,            -- 货主
    facility_id INT NOT NULL,                   -- 仓库
    quantity INT NOT NULL,                      -- 库存数量
    lot_number VARCHAR(100),                    -- 批次号
    location VARCHAR(100),                      -- 库位
    status VARCHAR(20) CHECK (status IN ('Available', 'Reserved', 'Damaged')), -- 库存状态
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id)
);

-- 5. 入库表（Inbound）
CREATE TABLE Inbound (
    inbound_id INT IDENTITY(1,1) PRIMARY KEY, -- 入库唯一标识
    storer_key VARCHAR(50) NOT NULL,          -- 货主
    facility_id INT NOT NULL,                 -- 仓库
    product_id INT NOT NULL,                  -- 产品
    quantity INT NOT NULL,                    -- 入库数量
    received_date DATETIME NOT NULL,          -- 入库时间
    lot_number VARCHAR(100),                  -- 批次号
    location VARCHAR(100),                    -- 存放位置
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 6. 出库表（Outbound）
CREATE TABLE Outbound (
    outbound_id INT IDENTITY(1,1) PRIMARY KEY, -- 出库唯一标识
    storer_key VARCHAR(50) NOT NULL,           -- 货主
    facility_id INT NOT NULL,                  -- 仓库
    product_id INT NOT NULL,                   -- 产品
    quantity INT NOT NULL,                     -- 出库数量
    shipped_date DATETIME NOT NULL,            -- 出库时间
    lot_number VARCHAR(100),                   -- 批次号
    location VARCHAR(100),                     -- 出库位置
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 7. 计费规则表（Billing_Rate）
CREATE TABLE Billing_Rate (
    rate_id INT IDENTITY(1,1) PRIMARY KEY,   -- 计费规则唯一标识
    storer_key VARCHAR(50) NOT NULL,         -- 货主
    facility_id INT NOT NULL,                -- 仓库
    charge_type VARCHAR(50) NOT NULL CHECK (charge_type IN ('Storage', 'Inbound', 'Outbound')), -- 费用类型
    unit_price DECIMAL(10,2) NOT NULL,       -- 计费单价
    effective_date DATETIME NOT NULL,        -- 生效日期
    expiry_date DATETIME,                    -- 失效日期（可为空）
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id)
);

-- 8. 账单表（Billing）
CREATE TABLE Billing (
    billing_id INT IDENTITY(1,1) PRIMARY KEY, -- 账单唯一标识
    storer_key VARCHAR(50) NOT NULL,          -- 货主
    facility_id INT NOT NULL,                 -- 仓库
    billing_date DATETIME NOT NULL,           -- 账单日期
    total_amount DECIMAL(10,2) NOT NULL,      -- 总金额
    status VARCHAR(20) CHECK (status IN ('Pending', 'Paid', 'Overdue')), -- 账单状态
    FOREIGN KEY (storer_key) REFERENCES Storer(storer_key),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id)
);

-- 9. 账单明细表（Billing_Detail）
CREATE TABLE Billing_Detail (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,  -- 明细唯一标识
    billing_id INT NOT NULL,                  -- 账单 ID
    charge_type VARCHAR(50) NOT NULL CHECK (charge_type IN ('Storage', 'Inbound', 'Outbound')), -- 费用类型
    quantity INT NOT NULL,                    -- 数量（如存储天数、入库件数等）
    unit_price DECIMAL(10,2) NOT NULL,        -- 单价
    amount DECIMAL(10,2) NOT NULL,            -- 费用金额
    FOREIGN KEY (billing_id) REFERENCES Billing(billing_id)
);