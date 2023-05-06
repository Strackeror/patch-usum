.3ds

.create "1048BC.bin", 0x1048BC
b set_save
.close


.create "5B9A40.bin", 0x5B9A40
set_save:
mov r1, r0
ldr r1, [r1, #0x24]
ldr r1, [r1, #0x4]
add r1, #0x69000
add r1, #0xa10
mov r2, #0x64
strb r2, [r1, #0xb]

// return
bx lr
.close
