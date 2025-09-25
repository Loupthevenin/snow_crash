Avec la commande **ls**, on trouve un fichier binaire **level13**.

```bash
level13@SnowCrash:~$ ls -l
total 8
-rwsr-sr-x 1 flag13 level13 7303 Aug 30  2015 level13
```

En décompilant le binaire via le site [dogbolt](https://dogbolt.org).

```c
char * ft_des(char *param_1)
{
  char cVar1;
  char *pcVar2;
  uint uVar3;
  char *pcVar4;
  byte bVar5;
  uint local_20;
  int local_1c;
  int local_18;
  int local_14;
  
  bVar5 = 0;
  pcVar2 = strdup(param_1);
  local_1c = 0;
  local_20 = 0;
  do {
    uVar3 = 0xffffffff;
    pcVar4 = pcVar2;
    do {
      if (uVar3 == 0) break;
      uVar3 = uVar3 - 1;
      cVar1 = *pcVar4;
      pcVar4 = pcVar4 + (uint)bVar5 * -2 + 1;
    } while (cVar1 != '\0');
    if (~uVar3 - 1 <= local_20) {
      return pcVar2;
    }
    if (local_1c == 6) {
      local_1c = 0;
    }
    if ((local_20 & 1) == 0) {
      if ((local_20 & 1) == 0) {
        for (local_14 = 0; local_14 < "0123456"[local_1c]; local_14 = local_14 + 1) {
          pcVar2[local_20] = pcVar2[local_20] + -1;
          if (pcVar2[local_20] == '\x1f') {
            pcVar2[local_20] = '~';
          }
        }
      }
    }
    else {
      for (local_18 = 0; local_18 < "0123456"[local_1c]; local_18 = local_18 + 1) {
        pcVar2[local_20] = pcVar2[local_20] + '\x01';
        if (pcVar2[local_20] == '\x7f') {
          pcVar2[local_20] = ' ';
        }
      }
    }
    local_20 = local_20 + 1;
    local_1c = local_1c + 1;
  } while( true );
}

void main(void)
{
  __uid_t _Var1;
  undefined4 uVar2;
  
  _Var1 = getuid();
  if (_Var1 != 4242) {
    _Var1 = getuid();
    printf("UID %d started us but we we expect %d\n",_Var1,4242);
    exit(1);
  }
  uVar2 = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
  printf("your token is %s\n",uVar2);
  return;
}
```

Ce programme affichera le token seulement si l'UID de l'utilisateur est 4242.

Mais en regardant dans la liste des utilisateurs, on se rend compte qu'il n'y a pas d'utilisateur avec l'id 4242.

```bash
level13@SnowCrash:~$ su -c "cat /etc/passwd | grep 4242 | wc -l" - level01
Password: 
0
```

On pourrait essayer de décoder et comprendre le fonctionnement de la fonction `ft_des`, mais on peut aussi copier-coller la fonction dans son propre main.

```c
typedef unsigned int uint;
typedef char byte;
#define true 1

char * ft_des(char *param_1) { ... }

int main(void)
{
    printf("%s\n", ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I"));
    return 0;
}
```

```bash
snow-crash git:(main) ✗ cc ./level13/resources/ft_des.c -o ./level13/resources/ft_des
snow-crash git:(main) ✗ ./level13/resources/ft_des
2A31L79asukciNyi8uppkEuSx
```
