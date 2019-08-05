-- Launch two separate interpreters by running psql sqlda

C:\> psql sqlda

-- In the first terminal execute the sleep command with a parameter of 1000 seconds

sqlda=# SELECT pg_sleep(1000);

-- In the second terminal, select the pid and query columns from the pg_stat_activity table where the state is active

sqlda=# SELECT pid, query FROM pg_stat_activity WHERE state = 'active';

-- In the second terminal, pass the pid (process ID) of the query pg_sleep to the pg_cancel_backend command to terminate the pg_sleep query with a graceful cleanup

sqlda=# SELECT pg_cancel_backend(14131);

-- Observe the first terminal and notice that the sleep command is no longer executing as indicated by the return message