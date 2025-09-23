import sys

try:
    with open(sys.argv[1], "rb") as f:
        data = f.read()

    token = bytes((byte - i) % 256 for i, byte in enumerate(data))

    print(token.decode('latin1')[:-1])

except Exception as e:
    print("Error:", e)
