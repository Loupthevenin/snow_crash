Avec la commande **ls**, on trouve un fichier binaire **level09** et un fichier **token**.

```bash
level09@SnowCrash:~$ ls -l
total 12
-rwsr-sr-x 1 flag09 level09 7640 Mar  5  2016 level09
----r--r-- 1 flag09 level09   26 Mar  5  2016 token
```

Cette fois-ci on a les droits de lecture sur le fichier **token**, mais il n'est pas lisible.

```bash
level09@SnowCrash:~$ cat token 
f4kmm6p|=�p�n��DB�Du{��
```

Il semble avoir été encrypté.

En décompilant le binaire via le site [dogbolt](https://dogbolt.org)

On remarque qu'il y a beaucoup de vérifications sur des injections de code qu'on peut réaliser, par exemple à l'aide de **LD_PRELOAD**, et le programme interdit ces injections.

La partie qui nous intéressera sera celle-ci, qui est la partie qui encode le token.
```c
while (true)
{
    var_120 += 1;
    int i = -1;
    int edi_1 = argv[1];

    while (i)
    {
        bool cond = 0 != *edi_1;
        edi_1 += 1;
        i -= 1;

        if (!cond)
            break;
    }

    if (var_120 >= ~i - 1)
        break;

    putchar(*(var_120 + argv[1]) + var_120);
}

result = fputc('\n', stdout);
```

Cette partie incrémente chaque caractère par son index, par exemple : `"0000000" -> "0123456"`

C'est ce que nous donne le binaire.

```bash
level09@SnowCrash:~$ ./level09 0000000
0123456
```

Donc, on peut inverser le processus en faisant une décrémentation par l'index pour retrouver l'original.

Pour cela, on peut faire un script Python.

```python
import sys

try:
    with open(sys.argv[1], "rb") as f:
        data = f.read()

    token = bytes((byte - i) % 256 for i, byte in enumerate(data))

    print(token.decode('latin1')[:-1])

except Exception as e:
    print("Error:", e)
```

```bash
➜  snow-crash git:(main) ✗ scp -P 4242 level09@192.168.XXX.XXX:/home/user/level09/token /tmp/token
➜  snow-crash git:(main) ✗ python level09/resources/decrypter.py /tmp/token 
f3iji1ju5yuevaus41q1afiuq
```

Puis on récupère le flag via l'utilisateur **flag09**.

```bash
su -c getflag - flag09
```
