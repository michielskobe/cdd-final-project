import serial.tools.list_ports
import serial
import random
import time
ports = list(serial.tools.list_ports.comports())
for p in ports:
    print(p)

ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=10)
runs = 0
correct = 0

for i in range(10):
    runs += 1

    OPERAND_WIDTH = 512

    N_BYTES = int(OPERAND_WIDTH/8)

    A = random.randrange(2**(OPERAND_WIDTH-1), 2**OPERAND_WIDTH-1)
    B = random.randrange(2**(OPERAND_WIDTH-1), 2**OPERAND_WIDTH-1)

    res = A + B

    print("A     = ", hex(A))
    print("B     = ", hex(B))
    print("A + B = ", hex(res))

    A_bytes = bytearray.fromhex(format(A, 'x'))
    B_bytes = bytearray.fromhex(format(B, 'x'))

    print("Start sending operand A")
    for op_byte in A_bytes:
        hex_byte = ("{0:02x}".format(op_byte))
        ser.write(bytearray.fromhex(hex_byte))
        time.sleep(0.001)

    print("Start sending operand B")
    for op_byte in B_bytes:
        hex_byte = ("{0:02x}".format(op_byte))
        ser.write(bytearray.fromhex(hex_byte))
        time.sleep(0.001)

    print("Waiting for solution from FPGA")
    res_rcvd = ser.read(N_BYTES+1) 

    res2 = int.from_bytes(res_rcvd, "big")

    if res2==res:
        print("Result received correctly!")
        print("Expected   = ", hex(res))
        print("Received   = ", hex(res2))
        correct += 1
    else:
        print("Result INCORRECT!")
        print("Expected   = ", hex(res))
        print("Received   = ", hex(res2))

print(correct, " out of ", runs, " runs were correct!")
ser.close()
