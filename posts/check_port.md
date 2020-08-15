Check a port without telnet

```
$ nc -zv 10.135.5.219 8888
Connection to 10.135.5.219 8888 port [tcp/ddi-tcp-1] succeeded!

$ cat < /dev/tcp/10.135.5.219/22
SSH-2.0-OpenSSH_5.3

$curl telnet://10.135.5.219:8888
(hangs)
```
