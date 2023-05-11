.3ds

get_save_file equ 0x1048b4
day_milliseconds equ 1000 * 3600 * 24

.open "code.bin", 0x100000
.org 0x37e644
hook:
  b set_scan_points

.org 0x1772ec
  b time_hook

.org 0x5B9A40
added_time:
  .skip 4

set_scan_points:
  push {r0, r1, r2, r3, lr}
  cmp r0, #0xc
  bne @@trampoline

  bl get_save_file
  ldr r0, [r0, #0x24]
  ldr r0, [r0, #0x4]
  add r0, #0x69000
  add r0, #0xa10
  mov r1, #0x64
  strb r1, [r0, #0xb]

  ; add time
  ldr r1, =added_time
  ldr r1, [r1]
  ldr r2, =day_milliseconds
  add r2, r1
  ldr r1, =added_time
  str r2, [r1]

  @@trampoline:
  pop {r0, r1, r2, r3, lr}
  push {r3, r4, r5, r6, r7, lr} ; original instruction
  b hook + 4
  .pool

time_hook:
  ldr r1, [r4]
  ldr r2, =added_time
  ldr r2, [r2]
  add r1, r2
  str r1, [r4]
  pop {r4, r5, pc}
  .pool

.close
