#创建数据库 
CREATE DATABASE Petstore;


#创建用户表 
USE Petstore;

CREATE TABLE account (
	userid CHAR ( 6 ) NOT NULL,
	fullname VARCHAR ( 10 ) NOT NULL,
	PASSWORD VARCHAR ( 20 ) NOT NULL,
	sex CHAR ( 2 ) NOT NULL,
	address VARCHAR ( 40 ) NULL,
	email VARCHAR ( 20 ) NULL,
	phone VARCHAR ( 11 ) NOT NULL,
	PRIMARY KEY ( userid ) 
);


#创建商品分类表 
category CREATE TABLE category ( catid CHAR ( 10 ) NOT NULL, catname VARCHAR ( 20 ) NULL, PRIMARY KEY ( catid ) );


#创建商品表 product 

CREATE TABLE product (
	productid CHAR ( 10 ) NOT NULL,
	catid CHAR ( 10 ) NOT NULL,
	NAME VARCHAR ( 30 ) NOT NULL,
	descn text NULL,
	listprice DECIMAL ( 10, 2 ) NULL,
	unitcost DECIMAL ( 10, 2 ) NULL,
	qty INT ( 11 ) NOT NULL,
PRIMARY KEY ( productid ) 
);

#创建订单表 orders
CREATE TABLE orders(
	orderid INT(11) NOT NULL AUTO_INCREMENT,
	userid CHAR(6) NOT NULL,
	orderdate datetime NOT NULL,
	totalprice DECIMAL (10,2) DEFAULT(NULL),
	PRIMARY KEY (orderid)
);

#创建订单明细表 lineitem
CREATE TABLE lineitme(
	orderid int(11) NOT NULL,
	itemid CHAR(10) NOT NULL,
	quantity INT(11) NOT NULL,
	unitprice DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (orderid,itemid)
);


# 建立数据完整性约束
#为 product 表中的 catid 列创建外键
ALTER TABLE product
	ADD FOREIGN KEY (catid)
		REFERENCES category(catid)
			ON DELETE RESTRICT;

#为 orders 表中的 userid 列创建外键
ALTER TABLE orders
	ADD FOREIGN KEY (userid)
		REFERENCES account(userid)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;
			
#为 lineitem 表中的 itemid 列创建外键
ALTER TABLE lineitem 
	ADD FOREIGN KEY (itemid)
		REFERENCES product(productid)
			ON DELETE CASCADE
			ON UPDATE CASCADE;

#为 lineitem 表中的 orderid 列创建外键
ALTER TABLE lineitme
	ADD FOREIGN KEY (orderid)
		REFERENCES orders (orderid)
			ON DELETE CASCADE;
			
#为 account 表中的 sex 列添加 CHECK 完整性约束
ALTER TABLE account
ADD CHECK(sex IN ('男','女'));
