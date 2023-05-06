import os
import subprocess
import sys
import tempfile
from itertools import zip_longest


def grouper(iterable, n, fillvalue=None):
    args = [iter(iterable)] * n
    return zip_longest(*args, fillvalue=fillvalue)


def cheat_hex(data: bytes):
    return "".join(f"{b:02X}" for b in data[::-1])


def cheat_str(addr: int, data: bytes):
    subchunks = [*grouper(data, 4, 0)]
    if len(subchunks) == 1:
        return f"{addr:08X} {cheat_hex(subchunks[0])}"

    chunks = [*grouper(subchunks, 2, (0, 0, 0, 0))]
    return f"E{addr:07X} {len(data):08X}\n" + "\n".join(
        " ".join([cheat_hex(l), cheat_hex(r)]) for (l, r) in chunks
    )

def parse_modified_bytes(armips_file: str):
    lines = tmp.splitlines()
    asm_ranges = []
    current_range: tuple[int, int] = (0, 0)
    for line in lines:
        line = line.strip()
        if len(line) == 0 or line.startswith(";"):
            continue

        addr = int(line[:8], 16)
        instr = line[9 : line.index(";")].strip()
        print(hex(addr), instr)
        if current_range[0] == 0:
            current_range = (addr, addr)
        else:
            current_range = (current_range[0], addr)

        if (
            instr.startswith(".org")
            or instr.startswith(".open")
            or instr.startswith(".skip")
        ):
            if current_range[0] != current_range[1]:
                asm_ranges.append(current_range)
            current_range = (0, 0)
    if current_range[0] != current_range[1]:
        asm_ranges.append(current_range)
    return asm_ranges

exec_path = os.path.abspath("./armips/_Output/armips")
asm_file = os.path.abspath(sys.argv[1])
bin_file_name = sys.argv[2]
bin_file_offset = int(sys.argv[3], 0)

with tempfile.TemporaryDirectory() as tmpd:
    os.chdir(tmpd)
    with open(bin_file_name, "w"):
        pass
    subprocess.check_call([exec_path, asm_file, "-temp", "asm.tmp"])
    tmp = open("asm.tmp", encoding="utf-8-sig").read()
    asm_ranges = parse_modified_bytes(tmp)
    with open(bin_file_name, "rb") as bin:
        for asm_range in asm_ranges:
            bin.seek(asm_range[0] - bin_file_offset)
            b = bin.read(asm_range[1] - asm_range[0])
            print(cheat_str(asm_range[0], b))


