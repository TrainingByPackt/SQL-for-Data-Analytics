-- Launch two separate SQL interpreters

C:\> psql sqlda

-- In the first terminal execute the sleep command with a parameter of 1000 seconds

sqlda=# SELECT pg_sleep(1000);

-- In the second terminal identify the pid of the sleep query

sqlda=# SELECT pid, query FROM pg_stat_activity WHERE state = 'active';

-- Using the pid value, force the sleep command to terminate using the pg_terminate_background command

sqlda=# SELECT pg_terminate_backend(14131);

-- Verify in the first terminal that the sleep command has been terminated. Notice the message returned by the interpreter

sqlda=# SELECT pg_sleep(1000);

