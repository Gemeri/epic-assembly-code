## epic-assembly-code
**Super epic scripts coded in assembly. More to come!**

All programed using ml64 on visual studio with windows. Gotta have MASM installed and kernel32

or just run the already compiled executable

## greet_user.asm

Are you bored sad and lonely? Is the only way to cure that loneliness being greeted by an assembly script? Well look no further! greet_user.asm will not only ask for your name, but greet you to!!!

assemble script:

```
ml64.exe /c /Fo greet_user.obj greet_user.asm
```

Create exe:

```
link.exe /SUBSYSTEM:CONSOLE /OUT:greet_user.exe greet_user.obj kernel32.lib /ENTRY:main
```

Run exe:
```
./greet_user.exe
```

