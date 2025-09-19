# Cherche le mot passe

La commande `find / -user flag01 2>/dev/null` n'affiche rien cette fois-ci.

Il faut donc trouver autre chose.

En fouillant dans les mots de passe :

```bash
cat /etc/passwd
```

On aperçoit `flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash`.

On a trouvé le hash du mot de passe de l'utilisateur **flag01**, mais il n'est pas utilisable en tant que tel.

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
