.3ds

.open "code.bin", 0x100000
.org 0x4c4a74
  get_hook:
    b get_detour

.org 0x45842c
  remove_hook:
    b remove_detour

.org 0x5b9d80
  get_detour:
    ldr r0, [r1, #0x4]
    cmp r0, 0x5d
    bne @@trampoline
    mov r0, 41

    @@trampoline:
    b get_hook + 4

  remove_detour:
    db 0xd4, 0x00, 0xc1, 0xe1
    cmp r0, 0x5d
    bne @@trampoline
    mov r0, 41
    
    @@trampoline:
    b remove_hook + 4
.close