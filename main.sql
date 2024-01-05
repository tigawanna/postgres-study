--  list all tables in a postggres db
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
