.3ds

cafe_id_min equ 0x14aa
cafe_id_max equ 0x14b7
relearner_id equ 0x157c

.open "code.bin", 0x100000
.org 0x5b9fa0
  detour:
    push {r2}

    ; Check Pokecenter Cafe
    ldr r2, =cafe_id_min
    cmp r1, r2
    blt @@trampoline
    ldr r2, =cafe_id_max
    cmp r1, r2
    bgt @@trampoline
    b @@override_move_relearner

    @@override_move_relearner:
    ldr r1, =relearner_id

    @@trampoline:
    pop {r2}
    push {r4, r5, r6, r7, r8, r9, r10, r11, lr}
    b hook+4
  .pool

.org 0x39a044
  hook:
  b detour
.close