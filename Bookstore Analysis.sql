-- Create Tables
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\Downloads\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\Downloads\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\Downloads\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Quran" genre:

Select * From Books
Where Genre='Quran';

-- 2) Find books published after the year 1950:

Select * From Books
Where published_year>1950;

-- 3) List all customers from the Pakistan:

Select * From Customers
Where Country='Pakistan';

-- 4) Show orders placed in October 2023:

Select * From Orders
Where order_date Between '2023-10-01' And '2023-10-31';

-- 5) Retrieve the total stock of books available:

Select Sum(stock) As Total_Stock
From Books;

-- 6) Find the details of five most expensive book:

Select * from Books
Order By price Desc Limit 5;

-- 7) Show all customers who ordered more than 3 quantity of a book:

Select * From Orders
Where quantity>3;

-- 8) Retrieve all orders where the total amount exceeds $50:

Select * From Orders
Where total_amount>50;

-- 9) List all genres available in the Books table:

Select Distinct genre
From Books;

-- 10) Find the book with the lowest stock:

Select * from Books
Order By stock
Limit 1;

-- 11) Calculate the total revenue generated from all orders:

Select Sum(total_amount) As total_revenue
From Orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

Select * from Orders;
Select b.genre,Sum(o.quantity) As Total_Books_Sold
From Orders o
Join Books b ON b.book_id=o.book_id
Group By(genre);

-- 2) Find the average price of books in the "Hadith" genre:

Select Avg(price) As Average_Price
From Books
Where genre='Hadith';

-- 3) List customers who have placed at least 3 orders:

Select c.name,o.customer_id,Count(o.order_id) As Order_Count
From Orders o
Join Customers c ON o.customer_id=c.customer_id
Group By o.customer_id, c.name
Having Count(order_id)>=3;

-- 4) Find the most frequently ordered book:

Select b.title,o.book_id,Count(o.order_id) As Count_Order
From Orders o
Join Books b ON b.book_id=o.book_id
Group By o.book_id,b.title
Order By Count_Order Limit 2;

-- 5) Show the top 7 most expensive books of 'Islamic' Genre :

Select title,genre,price From Books
Where Genre='Islamic'
Order By price Limit 7;

-- 6) Retrieve the total quantity of books sold by each author:

Select b.author,Sum(o.quantity) As Total_Books_Sold
From Orders o
Join Books b ON b.book_id=o.book_id
Group By b.author;

-- 7) List the cities where customers who spent over $200 are located:

Select Distinct(c.city),total_amount
From Customers c
Join Orders o ON O.customer_id=c.customer_id
Where o.total_amount>200;

-- 8) Find the two customer who spent the most on orders:

Select c.name,c.customer_id,Sum(o.total_amount) As Total_Spent
From Orders o
Join Customers c ON C.customer_id=o.customer_id
Group By c.name,c.customer_id
Order By Total_Spent Desc Limit 2;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT
    b.book_id,
    b.title,
    b.stock AS Initial_Stock,
    COALESCE(SUM(o.quantity), 0) AS Total_Ordered,
    b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.book_id = o.book_id
GROUP BY
    b.book_id,
    b.title,
	b.stock
ORDER BY b.book_id;