# Premier test

Comme on ne sait pas ce qu'il faut faire pour l'instant, on va juste chercher des fichiers qui contiendraient des indices.

```bash
level00@SnowCrash:~$ ls -la
total 12
dr-xr-x---+ 1 level00 level00  100 Mar  5  2016 .
d--x--x--x  1 root    users    340 Aug 30  2015 ..
-r-xr-x---+ 1 level00 level00  220 Apr  3  2012 .bash_logout
-r-xr-x---+ 1 level00 level00 3518 Aug 30  2015 .bashrc
-r-xr-x---+ 1 level00 level00  675 Apr  3  2012 .profile
```

Malheureusement il n'y a rien dans le home, de plus on ne peut pas créer de fichier ou modifier ce déjà existant.

```bash
level00@SnowCrash:~$ touch a
touch: cannot touch `a': Permission denied
level00@SnowCrash:~$ mv .profile script.sh
mv: cannot move `.profile' to `script.sh': Permission denied
level00@SnowCrash:~$ echo "echo XX" >> .bashrc
-bash: .bashrc: Permission denied
```

# Second test

On va rechercher dans tout le système les fichiers auxquels on a accès à l'aide de la commande `find / -user "USER"`.

(`grep -v "^/proc/"` sert juste à enlever tous les résultats qui sont dans `/proc/`)

```bash
level00@SnowCrash:~$ find / -user "level00" 2>/dev/null | grep -v "^/proc/"
/dev/pts/0
```

Puisqu'on n'a rien, on réessaie avec l'utilisateur **flag00**.

```bash
level00@SnowCrash:~$ find / -user "flag00" 2>/dev/null
/usr/sbin/john
/rofs/usr/sbin/john
level00@SnowCrash:~$ cat /usr/sbin/john
cdiiddwpgswtgt
```

# Dcode

Cela semble avoir été chiffré, donc on va sur [dcode](https://www.dcode.fr) pour pouvoir déchiffrer le mot de passe.

La méthode de chiffrement utilisée ressemble au chiffrement de César.

En le déchiffrant, on obtient le résultat : `nottoohardhere`

# Getflag

On n'a plus qu'à récupérer le flag sur l'utilisateur **flag00** avec ce mot de passe.

```bash
level00@SnowCrash:~$ su flag00
Password: 
Don't forget to launch getflag !
flag00@SnowCrash:~$ getflag
Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias
```
