.3ds

.open "code.bin", 0x100000
.org 0x441654
  inithook:
  b initdetour

.org 0x4417d8
  checkhook:
  b checkdetour


.org 0x5b9d00
  poke_ptr:
    .skip 4

  initdetour:
    push {r4, r5, r6, r7, r8, r9, lr}
    ldr r4, =poke_ptr
    str r1, [r4]
    b inithook + 4

  checkdetour:
    @@skip_addr equ 0x4418c4
    @@get_level equ 0x3238c0

    push {r0, r1, r2, r3, r4, lr}
    mov r4, r0
    ldr r0, =poke_ptr
    ldr r0, [r0]
    bl @@get_level
    cmp r0, r4
    blt @@skip
    b @@trampoline

    @@skip:
    pop {r0, r1, r2, r3, r4, lr}
    b @@skip_addr

    @@trampoline:
    pop {r0, r1, r2, r3, r4, lr}
    cmp r0, #2
    b checkhook+4
  .pool
.close
