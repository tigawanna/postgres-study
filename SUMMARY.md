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


Absolutely! Let's dive deeper into specific areas of Postgres with more cheat sheets, building on our initial cheat sheet:

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




**Additional Tips:**

- End SQL statements with semicolons (`;`).
- Use double quotes for string values (`"example"`).
- Use backslashes (`\`) to escape special characters.
- For more complex operations, consult the official PostgreSQL documentation.
- Consider using a graphical user interface (GUI) tool for easier interaction with PostgreSQL.
