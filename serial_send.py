import time
import serial.tools.list_ports       # search com port
ports = list(serial.tools.list_ports.comports())
print("available ports...")
for p in ports:
    print(p)
ser = serial.Serial()
i = 0  # change the number to find appropriate port number
ser.port = (p[int(i)])
#ser.port = ('COM7')
ser.baudrate=1000000
ser.open()
print("")
print("selected port..."+ser.port)


#%% time-state
tbytes = 4
sbytes = 4
time_state =[
      [100000000,0b00000011,0b00000010,0b00000011,0b00000010],
      [150000000,0b00000011,0b11000001,0b00000011,0b00000111],
      [105000000,0b00000011,0b11000001,0b00000011,0b00000101],
      [200000000,0b00000001,0b00000100,0b00000011,0b00000110],
      [50000000,0b00000001,0b00000010,0b00000011,0b00000011],
      [100000000,0b00000001,0b00000100,0b00000011,0b00000110],
      [100000000,0b00000011,0b11000001,0b00000011,0b00000001],
      [150000000,0b00000001,0b00000100,0b00000011,0b00000100],
      [80000000,0b00000001,0b00000010,0b00000011,0b00000010],
      [100000000,0b00000001,0b00000100,0b00000011,0b00000100],
      [20000000,0b00000011,0b11000001,0b00000011,0b00000111],
      [100000000,0b00000101,0b00000110,0b00000101,0b00000101],
      [200000000,0b00000011,0b00000100,0b00000011,0b00000001],
      ]

data_length =len(time_state)
data_length_bytes = data_length.to_bytes(2,byteorder='big')

time_bytes = []
for i in range(len(time_state)):
    time_bytes.append(time_state[i][0].to_bytes(tbytes,byteorder='big'))
    

ser.write(bytearray([250])) # initialize
ser.write( bytearray([data_length_bytes[0]]))
ser.write( bytearray([data_length_bytes[1]]))

for i in range(data_length):
    for j in range(tbytes):
        ser.write( bytearray([time_bytes[i][j] ]))
#        print([time_bytes[i][j] ])
#        time.sleep(.01)
    for k in range(sbytes):
        ser.write( bytearray([time_state[i][k+1] ]))
#        print([time_state[i][k+1] ])
#        time.sleep(.01)
    print("")
ser.write(bytearray([255]))
ser.write(bytearray([255]))
print(data_length)


#ser.close()

#%%
ser.write(bytearray([25])) # serial trigger sequence
print(ser.read())

#%%
ser.write(bytearray([26])) # reset and stop the loop
print(ser.read())


#%%
ser.close()


