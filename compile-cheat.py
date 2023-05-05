import dataclasses
import keystone
import sys


@dataclasses.dataclass
class Group:
    name: str
    addr: int
    asm: str


file = sys.argv[1]
asm = open(file).readlines()
current_group: Group | None = None
groups = {}
common = ""
for line in asm:
    if line.startswith("##"):
        elems = line.strip().split(" ")
        name = elems[0][2:]
        addr = elems[1]
        current_group = Group(name, int(addr, base=0), "")
        groups[current_group.name] = current_group
        common += f".equ {name}, {addr}\n"
        continue
    if current_group:
        current_group.asm += line
    else:
        common += line

cheat_str = ""
# Use big endian mode to be correct for the gateway cheat, 3ds is little endian
ks = keystone.Ks(keystone.KS_ARCH_ARM, keystone.KS_MODE_ARM | keystone.KS_MODE_BIG_ENDIAN)
for group in groups.values():
    print(common + group.asm)
    cheat_bytes, _ = ks.asm(common + group.asm, addr=group.addr, as_bytes=True)
    if not isinstance(cheat_bytes,bytes):
        raise ValueError
    if len(cheat_bytes) > 4:
        cheat_str += f"E{group.addr:07X} {len(cheat_bytes):08X}"
        i = 8
    else:
        cheat_str += f"{group.addr:08X}"
        i = 4

    for b in cheat_bytes:
        if i % 8 == 0:
            cheat_str += "\n"
        elif i % 4 == 0:
            cheat_str += " "
        i += 1
        cheat_str += f"{b:02X}"
    while i % 8:
        if i % 4 == 0:
            cheat_str += " "
        cheat_str += "00"
        i += 1
    cheat_str += "\n"
print(cheat_str)
