words = [l.strip().replace("0x", "") for l in open("words.txt") if l.strip()]
with open("fsm_program.mem", "w") as f:
    for w in words:
        w = w.zfill(8)
        b = [w[6:8], w[4:6], w[2:4], w[0:2]]   # little-endian byte order
        f.write(" ".join(b).upper() + "\n")