Pour ce dernier niveau, on ne nous donne rien.

```bash
level14@SnowCrash:~$ ls -la
total 12
dr-x------ 1 level14 level14  100 Mar  5  2016 .
d--x--x--x 1 root    users    340 Aug 30  2015 ..
-r-x------ 1 level14 level14  220 Apr  3  2012 .bash_logout
-r-x------ 1 level14 level14 3518 Aug 30  2015 .bashrc
-r-x------ 1 level14 level14  675 Apr  3  2012 .profile
level14@SnowCrash:~$ find / -user flag14 2>/dev/null
level14@SnowCrash:~$ find / -user level14 2>/dev/null | grep -v "^/proc"
/dev/pts/0
```

Mais dans le niveau précédent, on nous a donné la fonction `ft_des`, du coup si le programme `getflag` utilise cette même fonction alors on pourrait trouver le flag à partir des données du binaire de `getflag`.

De plus, on a les droits de lecture sur le programme, donc on peut le copier et l'extraire de la VM.

```bash
level14@SnowCrash:~$ ls -l /bin/getflag
-rwxr-xr-x 1 root root 11833 Aug 30  2015 /bin/getflag
```

Après une décompilation sur [dogbolt](https://dogbolt.org), on remarque que c'est bien la fonction `ft_des` qui est utilisée.

On peut aussi le vérifier avec la commande `strings`.

```bash
level14@SnowCrash:~$ strings /bin/getflag | grep ft_des
ft_des
level14@SnowCrash:~$ strings /bin/getflag | grep "boe]\!ai0FB@.:|L6l@A?>qJ}I"
boe]!ai0FB@.:|L6l@A?>qJ}I
```

Maintenant qu'on a confirmé l'utilisation de la fonction `ft_des`, il nous faut la string à donner en argument.

En refaisant un `strings /bin/getflag`, on remarque cette partie :
```
libc
Check flag.Here is your token : 
You are root are you that dumb ?
I`fA>_88eEd:=`85h0D8HE>,D
7`4Ci4=^d=J,?>i;6,7d416,7
<>B16\AD<C6,G_<1>^7ci>l4B
B8b:6,3fj7:,;bh>D@>8i:6@D
?4d@:,C>8C60G>8:h:Gb4?l,A
G8H.6,=4k5J0<cd/D@>>B:>:4
H8B8h_20B4J43><8>\ED<;j@3
78H:J4<4<9i_I4k0J^5>B1j`9
bci`mC{)jxkn<"uD~6%g7FK`7
Dc6m~;}f8Cj#xFkel;#&ycfbK
74H9D^3ed7k05445J0E4e;Da4
70hCi,E44Df[A4B/J@3f<=:`D
8_Dw"4#?+3i]q&;p6 gtw88EC
boe]!ai0FB@.:|L6l@A?>qJ}I
g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|
Nope there is no token here for you sorry. Try again :)
00000000 00:00 0
LD_PRELOAD detected through memory maps exit ..
```

Qui contient tout pile 15 chaînes de caractères random, donc la 14e qui est celle utilisée dans le level 13.

On a donc logiquement juste à prendre la dernière qui est celle juste après la 14e.

```bash
snow-crash git:(main) ✗ cc ./level14/resources/ft_des.c -o ./level14/resources/ft_des
snow-crash git:(main) ✗ ./level14/resources/ft_des                                
level00 -> x24ti5gi3x0ol2eh4esiuxias
level01 -> f2av5il02puano7naaf6adaaf
level02 -> kooda2puivaav1idi4f57q8iq
level03 -> qi0maab88jeaj46qoumi7maus
level04 -> ne2searoevaevoem4ov4ar8ap
level05 -> viuaaale9huek52boumoomioc
level06 -> wiok45aaoguiboiki2tuin6ub
level07 -> fiumuikeil55xe9cu4dood66h
level08 -> 25749xKZ8L7DkSCwJkT9dyv6f
level09 -> s5cAJpM8ev6XHw998pRWG728z
level10 -> feulo4b72j7edeahuete3no7c
level11 -> fa6v5ateaw21peobuub8ipe6s
level12 -> g1qKMiRpXf53AWhDaU7FEkczr
level13 -> 2A31L79asukciNyi8uppkEuSx
level14 -> 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
```

```bash
level14@SnowCrash:~$ su flag14
Password: 
Congratulation. Type getflag to get the key and send it to me the owner of this livecd :)
flag14@SnowCrash:~$ getflag
Check flag.Here is your token : 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
```