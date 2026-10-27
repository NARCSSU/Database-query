CREATE DATABASE Library;

USE Library;

-- 读者表
CREATE TABLE Reader (
	reader_id CHAR ( 6 ) NOT NULL,
	NAME CHAR ( 10 ) NOT NULL,
	category_id CHAR ( 2 ) NOT NULL,
	unit VARCHAR ( 20 ) NULL,
	validity CHAR ( 10 ) NULL,
	PRIMARY KEY (reader_id)
);

--读者类型表
CREATE TABLE ReaderType (
	category_id CHAR ( 2 ) NOT NULL,
	category_name CHAR ( 10 ) NOT NULL,
	max_borrow_num INT NULL,
	max_borrow_days INT NULL, 
	PRIMARY KEY (category_id)
);
 
--库存表
CREATE TABLE Inventory (
	barcode CHAR ( 20 ) NOT NULL,
	book_id CHAR ( 10 ) NOT NULL,
	location VARCHAR ( 20 ) NOT NULL,
	stock_status CHAR ( 10 ) NULL,
	PRIMARY KEY (barcode)
);

--图书表
CREATE TABLE Book (
	book_id CHAR ( 10 ) NOT NULL,
	book_name VARCHAR ( 20 ) NOT NULL,
	category CHAR (10) NOT NULL,
	author CHAR (10) NOT NULL,
	publisher VARCHAR (20) NOT NULL,
	unit_price FLOAT (5,2) NULL,
	quantity INT NULL,
	PRIMARY KEY (book_id)
);

--借阅表
CREATE TABLE Borrow (
	borrow_id INT NOT NULL,
	barcode CHAR (20) NOT NULL,
	reader_id CHAR (6) NOT NULL,
	borrow_date DATE NULL,
	return_date DATE NULL,
	borrow_status CHAR (6) NULL,
	PRIMARY KEY (borrow_id)
);


-- ==========================================
-- 1. 为 Reader(读者表) 添加外键
-- ==========================================
ALTER TABLE Reader                          -- 修改 Reader 表结构
    ADD CONSTRAINT fk_reader_readertype     -- 添加一个约束，并给这个约束起个名字叫 fk_reader_readertype (fk代表外键)
    FOREIGN KEY (category_id)               -- 指定 Reader 表中的 category_id (类别号) 作为外键
    REFERENCES ReaderType(category_id)      -- 引用(关联) ReaderType 表中的 category_id (类别号) 列
    ON UPDATE CASCADE                       -- 级联更新：如果修改了 ReaderType 里的类别号，这里也会自动跟着改
    ON DELETE CASCADE;                      -- 级联删除：如果删除了 ReaderType 里的某个类别，这里对应的读者也会被自动删除 (符合题目“随之变化”)


-- ==========================================
-- 2. 为 Borrow(借阅表) 添加读者的外键
-- ==========================================
ALTER TABLE Borrow                          -- 修改 Borrow 表结构
    ADD CONSTRAINT fk_borrow_reader         -- 添加约束，命名为 fk_borrow_reader
    FOREIGN KEY (reader_id)                 -- 指定 Borrow 表中的 reader_id (读者编号) 作为外键
    REFERENCES Reader(reader_id);           -- 引用 Reader 表的 reader_id。
                                            -- 【注意】这里没写 ON DELETE/UPDATE，默认就是 RESTRICT(限制)。
                                            -- 意思是：只要借阅表里有这个读者的记录，就不准删除或修改读者表里的该读者。(完美符合题目“不得删除或修改”)


-- ==========================================
-- 3. 为 Borrow(借阅表) 添加库存的外键
-- ==========================================
ALTER TABLE Borrow                          -- 修改 Borrow 表结构
    ADD CONSTRAINT fk_borrow_inventory      -- 添加约束，命名为 fk_borrow_inventory
    FOREIGN KEY (barcode)                   -- 指定 Borrow 表中的 barcode (条码) 作为外键
    REFERENCES Inventory(barcode)           -- 引用 Inventory 表的 barcode 列
    ON UPDATE CASCADE                       -- 级联更新：库存表的条码变了，借阅表跟着变
    ON DELETE CASCADE;                      -- 级联删除：库存表删除了某本书，借阅表里这本书的记录也删掉 (符合题目“随之变化”)


-- ==========================================
-- 4. 为 ReaderType(读者类型表) 添加检查约束 (限制数量)
-- ==========================================
ALTER TABLE ReaderType                      -- 修改 ReaderType 表结构
    ADD CONSTRAINT chk_readertype_maxnum    -- 添加约束，命名为 chk_readertype_maxnum (chk代表检查)
    CHECK (max_borrow_num >= 0 AND max_borrow_num <= 30);  -- 检查(限制)条件：max_borrow_num 必须大于等于0，且小于等于30


-- ==========================================
-- 5. 为 Inventory(库存表) 添加检查约束 (限制状态)
-- ==========================================
ALTER TABLE Inventory                       -- 修改 Inventory 表结构
    ADD CONSTRAINT chk_inventory_status     -- 添加约束，命名为 chk_inventory_status
    CHECK (stock_status IN ('在馆','借出','丢失'));       -- 检查条件：stock_status 的值只能是括号里这3个词中的某一个