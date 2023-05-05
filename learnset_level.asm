##poke 0x5b9d00
.word 0

##inithook 0x441654
b initdetour

##initdetour 0x5b9d10
push {r4,r5,r6,r7,r8,r9,lr}
ldr r4, =poke
str r1, [r4]
b inithook+4


##hook 0x4417d8
b detour

##detour 0x5b9d40
.equ skip_addr, 0x4418c4
.equ get_level, 0x3238c0

push {r0, r1, r2, r3, r4, lr}
mov r4, r0
ldr r0, =poke
ldr r0, [r0]
bl get_level
cmp r0, r4
blt skip
b trampoline

skip:
pop {r0, r1, r2, r3, r4, lr}
b skip_addr

trampoline:
pop {r0, r1, r2, r3, r4, lr}
cmp r0, #2
b hook+4
