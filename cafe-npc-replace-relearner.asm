.3ds

.open "code.bin", 0x100000
.org 0x5b9fa0
  detour:
    push {r2}

    ; Check Pokecenter Cafe
    mov r2, #0x1400
    add r2, #0xaa
    cmp r1, r2
    blt @@trampoline
    mov r2, 0x1400
    add r2, 0xb7
    cmp r1, r2
    bgt @@trampoline
    b @@override_move_relearner

    @@override_move_relearner:
    mov r1, #0x1500
    add r1, #0x7c

    @@trampoline:
    pop {r2}
    push {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    b hook+4

.org 0x39a044
  hook:
  b detour
.close