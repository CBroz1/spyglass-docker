CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'tutorial';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
