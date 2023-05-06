##savefile_return 0x1048bc
b set_save


##set_save 0x5b9a40
mov r1, r0
ldr r1, [r1, #0x24]
ldr r1, [r1, #0x4]
add r1, #0x69000
add r1, #0xa1b
str r1, #0x64

trampoline:
bx lr

@ ##removepoints 0x453ad4
@ mov r0, #1
@ bx lr

@ ##addpoint 0x453a48
@ mov r3, #100