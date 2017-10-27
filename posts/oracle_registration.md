When the listener will not connect, try this:

```sql
sqlplus / as sysdba

alter system set LOCAL_LISTENER='(DESCRIPTION_LIST =  (DESCRIPTION = (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))))';

alter system register;

alter system set listener_networks='(( NAME=net1)(LOCAL_LISTENER=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT =1573)))))' scope=both;
alter system register;
```

On windows, start cmd as administrator, then type `lsnrctl start`. It will prompt you for the oracle password from the OS, and create 
a default listener in Services.
