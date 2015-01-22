Train System
================

by Mike Goren and Alex Kaufman

Train System is a website that uses a database and Sinatra to allow users to view stations, lines, and connections between them. Administrators can add, delete, and modify stations, lines, and connections.

Installation
------------

Install Train System by first cloning the repository.  
```
$ git clone http://github.com/mgoren/train_system.git
```

Install all of the required gems:
```
$ bundle install
```

Start the database:
```
$ postgres
```

Create the databases and tables:
```
# psql
```

```
username=# CREATE DATABASE train_system;
```

```
username=# \c train_system;
```

```
todo=# CREATE TABLE lines (id serial PRIMARY KEY, name varchar);
```

```
todo=# CREATE TABLE stations (id serial PRIMARY KEY, name varchar);
```

```
todo=# CREATE TABLE stops (id serial PRIMARY KEY, line_id int, station_id int);
```

```
todo=# CREATE DATABASE train_system_test WITH TEMPLATE train_system;
```

Start the webserver:
```
$ ruby app.rb
```

In your web browser, go to http://localhost:4567

License
-------

GNU GPL v2. Copyright 2015 Mike Goren and Alex Kaufman
