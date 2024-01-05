 ## Postgres cheat sheet

**Database Management:**

- **Create a database:**
```sql
CREATE DATABASE my_database;
```

- **Connect to a database:**
```sql
\c my_database
```

- **List databases:**
```sql
\l
```

- **Drop a database:**
```sql
DROP DATABASE my_database;
```

**Table Management:**

- **Create a table:**
```sql
CREATE TABLE my_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER
);
```

- **List tables:**
```sql
\dt
```

- **Describe a table's structure:**
```sql
\d my_table
```

- **Insert data into a table:**
```sql
INSERT INTO my_table (name, age) VALUES ('Alice', 30);
```

- **Update data in a table:**
```sql
UPDATE my_table SET age = 35 WHERE name = 'Alice';
```

- **Delete data from a table:**
```sql
DELETE FROM my_table WHERE name = 'Alice';
```

**User Management:**

- **Create a user:**
```sql
CREATE USER my_user WITH PASSWORD 'my_password';
```

- **Grant privileges to a user:**
```sql
GRANT SELECT, INSERT, UPDATE ON my_table TO my_user;
```

**Basic Operations on Tables:**

- **Retrieve all data from a table:**
```sql
SELECT * FROM my_table;
```

- **Retrieve specific columns:**
```sql
SELECT name, age FROM my_table;
```

- **Filter results using a WHERE clause:**
```sql
SELECT * FROM my_table WHERE age > 25;
```

- **Order results:**
```sql
SELECT * FROM my_table ORDER BY age DESC;
```

**Full Text Search:**

- **Install the full text search extension (once per database):**
```sql
CREATE EXTENSION pg_trgm;
```

- **Perform a full text search:**
```sql
SELECT * FROM my_table WHERE name @@ 'search_term';
```




**Advanced CRUD Operations:**

* **Insert multiple rows:**

```sql
INSERT INTO my_table (name, age) VALUES ('Alice', 30), ('Bob', 25);
```

* **Update with joins:**

```sql
UPDATE my_table t
SET age = age + 1
FROM users u
WHERE t.user_id = u.id
AND u.name = 'Alice';
```

* **Delete with WHERE clause conditions:**

```sql
DELETE FROM my_table WHERE age < 18 OR name LIKE '%admin%';
```

**Data Manipulation and Aggregation:**

* **Filter results with multiple conditions:**

```sql
SELECT * FROM my_table WHERE age > 25 AND country = 'USA';
```

* **Order results by multiple columns:**

```sql
SELECT * FROM my_table ORDER BY age DESC, name ASC;
```

* **Group data and calculate statistics:**

```sql
SELECT country, COUNT(*) AS users_count
FROM my_table
GROUP BY country;
```

* **Use subqueries for complex comparisons:**

```sql
SELECT * FROM my_table
WHERE id IN (SELECT order_id FROM orders WHERE customer_id = 123);
```

**Advanced Features:**

* **Create and use functions:**

```sql
CREATE FUNCTION add_two_numbers(a INTEGER, b INTEGER) RETURNS INTEGER AS $$
BEGIN
  RETURN a + b;
END;
$$ LANGUAGE plpgsql;

SELECT add_two_numbers(10, 5);
```

* **Implement views for data abstraction:**

```sql
CREATE VIEW active_users AS
SELECT * FROM users WHERE status = 'active';

SELECT * FROM active_users;
```

* **Utilize triggers for automatic actions:**

```sql
CREATE TRIGGER update_last_login
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
  UPDATE users SET last_login = NOW() WHERE id = NEW.id;
END;
```




**Relations**



Postgres allows you to connect tables in various ways, forming relationships between data entities. Understanding these relationships is crucial for designing efficient and flexible databases. Here's a breakdown of different types with an emphasis on Many-to-Many (M-M) relationships:

**Types of Relations:**

- **One-to-One (1:1):** One row in one table can be associated with at most one row in another table. Example: a customer having only one address.

- **One-to-Many (1:N):** One row in one table can be associated with many rows in another table. Example: a customer having multiple orders.

- **Many-to-One (N:1):** Many rows in one table can be associated with one row in another table. Example: multiple products belonging to one category.

- **Many-to-Many (M:N):** Many rows in one table can be associated with many rows in another table. This typically requires a separate "join" table.

**Creating M-M Relationships:**

To implement M-M relationships, you need three tables:

* **Two primary tables:** These hold the main data entities (e.g., users and products).
* **Join table:** This table links rows from the primary tables (e.g., user_product links). It usually has foreign keys referencing both primary tables.

**Example:** An online store where users can add multiple products to their cart.

- **Table users:** `id` (primary key), `name`, `email`
- **Table products:** `id` (primary key), `name`, `description`
- **Table user_cart:** `user_id` (foreign key to users.id), `product_id` (foreign key to products.id), `quantity`

**Operations with M-M Relationships:**

* **Add a product to a user's cart:**

```sql
INSERT INTO user_cart (user_id, product_id, quantity) VALUES (1, 3, 2);
```

* **Get all products in a user's cart:**

```sql
SELECT p.* FROM user_cart uc
JOIN products p ON uc.product_id = p.id
WHERE uc.user_id = 1;
```

* **Remove a product from a user's cart:**

```sql
DELETE FROM user_cart WHERE user_id = 1 AND product_id = 3;
```

**Benefits of M-M Relationships:**

* **Flexibility:** Easily scale to accommodate additional entities on either side of the relationship.
* **Data normalization:** Avoids data redundancy and improves database efficiency.
* **Modular design:** Simplifies database schema and makes it easier to manage relationships.

**Additional Notes:**

* Consider using unique constraints on the join table's foreign key combination to prevent duplicate entries.
* You can customize the join table by adding additional columns if needed (e.g., purchase date).


**JOIN vs SYUBQUERY**



**Subqueries:**

* **Definition:** A query nested within another query.
* **Purpose:** Retrieve data from one table based on conditions that depend on data in another table.
* **Syntax:** Enclosed within parentheses within the main query's WHERE or FROM clause.
* **Example:**

```sql
SELECT * FROM customers WHERE customer_id IN (SELECT customer_id FROM orders WHERE order_date > '2024-01-01');
```

**Joins:**

* **Definition:** Combine data from multiple tables based on shared columns.
* **Purpose:** Create a result set with columns from both tables, often used to aggregate data or filter based on relationships.
* **Syntax:** Use keywords like `JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL JOIN`.
* **Example:**

```sql
SELECT customers.name, orders.order_date
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id;
```

**Key Differences:**

| Feature       | Subquery                              | Join                                       |
|----------------|---------------------------------------|---------------------------------------------|
| Structure      | Nested query                           | Combines tables side-by-side               |
| Purpose       | Filtering or providing values for main query | Creating a result set with data from multiple tables |
| Execution     | Often executed multiple times         | Typically executed once                     |
| Performance    | Can be slower for large datasets       | Generally faster, especially with indexes  |
| Readability    | Can be less readable for complex queries | More explicit and easier to visualize       |

**When to Use Each:**

* **Subqueries:**
    - Filtering based on values from another table
    - Performing complex comparisons
    - Retrieving data from multiple tables without explicitly joining them
* **Joins:**
    - Combining columns from multiple tables
    - Retrieving data based on relationships between tables
    - Performing aggregations across multiple tables

**Best Practices:**

* Use joins for most cases involving multiple tables, as they often offer better performance and readability.
* Consider subqueries for specific filtering tasks or when direct joins aren't feasible.
* Be mindful of query complexity and potential performance implications, especially with large datasets.
* Use clear aliases for tables and columns to enhance readability.
* Test your queries thoroughly to ensure they produce the expected results.


## Joins and Relations in PostgreSQL: A Deeper Dive

Joins and relations are the backbone of effective data management in Postgres. Understanding their interplay empowers you to design efficient and flexible databases. Here's a deeper look:

**What are Relations?**

Relations, in the context of databases, define how tables are connected. They establish associations between entities, allowing you to retrieve and manipulate data across multiple tables. Postgres supports various types of relations:

* **One-to-One (1:1):** One row in one table uniquely associates with one row in another. Think "customer" having only one "primary address."
* **One-to-Many (1:N):** One row in one table associates with many rows in another. For example, a "customer" can have many "orders."
* **Many-to-One (N:1):** Many rows in one table associate with one row in another. Imagine multiple "products" belonging to the same "category."
* **Many-to-Many (M:N):** Many rows in one table associate with many rows in another. This typically requires a dedicated "join" table. An online store with users adding various products to their cart exemplifies this.

**How do Joins Work?**

Joins let you bring together data from multiple tables based on shared columns. They act as bridges between related entities, creating a combined result set. Postgres offers various join types for specific scenarios:

* **Inner Join (default):** Only rows with matching values in the join columns are included in the result. Suitable for filtering based on relationships.
* **Left Join:** All rows from the left table are included, even if there's no match in the right table. Useful for checking for missing relationships.
* **Right Join:** All rows from the right table are included, even if there's no match in the left table. Similar to left join, but flipped.
* **Full Join:** Includes all rows from both tables, regardless of whether there's a match. Helpful for analyzing complete sets of data.

**Understanding Joins with Examples:**

1. **Customer Orders:**

Imagine tables `customers` (id, name) and `orders` (id, customer_id, product). Let's find all orders placed by a customer named "Alice":

```sql
SELECT * FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE c.name = 'Alice';
```

This uses an inner join to filter orders based on the matching customer_id between the tables.

2. **Missing Products:**

Suppose you have "products" (id, name) and "cart_items" (id, product_id, quantity) tables. To discover any products in the cart missing from your inventory, you can use a left join:

```sql
SELECT p.*
FROM products p
LEFT JOIN cart_items ci ON p.id = ci.product_id
WHERE ci.product_id IS NULL;
```

This left join includes all products, even those not in the cart (null joins), highlighting missing inventory.

**Benefits of Relations and Joins:**

* **Data organization:** Enables logical grouping of related data, ensuring consistency and integrity.
* **Flexibility:** Facilitates retrieving and manipulating data across multiple tables with ease.
* **Efficient queries:** Optimized join operations for faster data retrieval and processing.
* **Scalability:** Adapts to growing data by adding more related entities without restructuring the core schema.

**Next Steps:**

This is just a starting point. To fully master joins and relations in Postgres, consider:

* Exploring different join types and their applications.
* Practicing writing queries involving joins for various scenarios.
* Learning optimization techniques for complex joins and subqueries.
* Consulting the official Postgres documentation for in-depth explanations and examples.



**Additional Tips:**

- End SQL statements with semicolons (`;`).
- Use double quotes for string values (`"example"`).
- Use backslashes (`\`) to escape special characters.
- For more complex operations, consult the official PostgreSQL documentation.
- Consider using a graphical user interface (GUI) tool for easier interaction with PostgreSQL.
