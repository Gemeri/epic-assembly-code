## epic-assembly-code
**Super epic scripts coded in assembly. More to come!**

All programed using ml64 on visual studio with windows. Gotta have MASM installed and kernel32

or just run the already compiled executable

## greet_user.asm

Are you bored sad and lonely? Is the only way to cure that loneliness being greeted by an assembly script? Well look no further! greet_user.asm will not only ask for your name, but greet you to!!!

assemble script:

```
ml64 /c /Fo greet_user.obj greet_user.asm
```

Create exe:

```
link /SUBSYSTEM:CONSOLE /OUT:greet_user.exe greet_user.obj kernel32.lib /ENTRY:main
```

Run exe:
```
./greet_user
```

## hello.asm

Good ol' classic "Hello World" but in assembly

assemble script:

```
ml64 /c hello.asm
```

Create exe:

```
link /subsystem:console /defaultlib:ucrt.lib /defaultlib:vcruntime.lib /defaultlib:legacy_stdio_definitions.lib /entry:main hello.obj
```

Run exe:
```
./hello
```

## minimal.asm

Just opens and immediatly dies, not sure what else im supposed to say

assemble script:

```
ml64 /c /Fo minimal.obj minimal.asm
```

Create exe:

```
link /SUBSYSTEM:CONSOLE /OUT:minimal.exe minimal.obj kernel32.lib /ENTRY:main
```

Run exe:
```
./minimal
```

## word_uzzer.asm

Have you always wondered how would words be if they were uzzed? Well you’ve come to the right place. Here you can input a word and see it uzzed! if the input is more than 1 word then it'll just die

assemble script:

```
ml64 /c /Zi word_uzzer.asm
```

Create exe:

```
link /ENTRY:main /SUBSYSTEM:CONSOLE /OUT:word_uzzer.exe word_uzzer.obj kernel32.lib
```

Run exe:
```
./word_uzzer
```
