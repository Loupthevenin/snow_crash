# First test

```bash
level00@SnowCrash:~$ ll
total 12
dr-xr-x---+ 1 level00 level00  100 Mar  5  2016 ./
d--x--x--x  1 root    users    340 Aug 30  2015 ../
-r-xr-x---+ 1 level00 level00  220 Apr  3  2012 .bash_logout*
-r-xr-x---+ 1 level00 level00 3518 Aug 30  2015 .bashrc*
-r-xr-x---+ 1 level00 level00  675 Apr  3  2012 .profile*
```

# Second test

`find / -user "flag00"`

```bash
level00@SnowCrash:~$ find / -user flag00 2>/dev/null
/usr/sbin/john
/rofs/usr/sbin/john
level00@SnowCrash:~$ cat /usr/sbin/john
cdiiddwpgswtgt
```

# Dcode

https://www.dcode.fr/identification-chiffrement
-> https://www.dcode.fr/chiffre-ragbaby
-> https://www.dcode.fr/chiffre-affine

# Chiffre affine

méthode de cryptographie -> chiffrement par substitution mono-alphabétique : la lettre d'origine n'est remplacée que par une unique autre lettre.