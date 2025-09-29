# Cherche le mot passe

Cette fois-ci, les commandes précédentes ne nous donnent rien d'intéressant.

```bash
level01@SnowCrash:~$ ls -la
total 12
dr-x------ 1 level01 level01  100 Mar  5  2016 .
d--x--x--x 1 root    users    340 Aug 30  2015 ..
-r-x------ 1 level01 level01  220 Apr  3  2012 .bash_logout
-r-x------ 1 level01 level01 3518 Aug 30  2015 .bashrc
-r-x------ 1 level01 level01  675 Apr  3  2012 .profile
level01@SnowCrash:~$ find / -user "flag01" 2>/dev/null
level01@SnowCrash:~$ find / -user "level01" 2>/dev/null | grep -v "^/proc/"
/dev/pts/0
```

Il faut donc trouver autre chose.

En fouillant dans les mots de passe :

```bash
cat /etc/passwd
```

On aperçoit `flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash`.

On a donc trouvé le hash du mot de passe de l'utilisateur **flag01**, mais il n'est pas utilisable en tant que tel.

# John the Ripper

Pour pouvoir le décrypter, on utilise le logiciel **John the Ripper** qui est un cracker de mot de passe.

On crée un conteneur avec **John the Ripper**.

```bash
docker build -t johntheripper .
docker run --rm -it johntheripper
```

Puis on donne en argument un fichier texte contenant les mots de passe qu'on veut décrypter.

```bash
echo "42hDRfypTqqnw" > pass
./john pass
```

On peut voir le résultat :

```bash
abcdefg          (?)
```

# Getflag

On peut maintenant se connecter sur l'utilisateur **flag01** et récupérer le flag.

```bash
level01@SnowCrash:~$ su flag01
Password: 
Don't forget to launch getflag !
flag01@SnowCrash:~$ getflag
Check flag.Here is your token : f2av5il02puano7naaf6adaaf
```
