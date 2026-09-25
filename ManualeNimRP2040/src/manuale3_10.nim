#---- esempio 1 ----
import picostdlib
import picostdlib/hardware/i2c
import sequtils

stdioInitAll()
sleepMs(2000)
#setupI2c(i2c1, 18.Gpio, 19.Gpio, 50_000, true)
let i2cBlok = i2c1 #5
discard i2cBlok.init(50_000)
14.Gpio.setFunction(I2C)
14.Gpio.pullUp()#disablePulls()
15.Gpio.setFunction(I2C)
15.Gpio.pullUp()
var numero:seq[uint8]  = @[48,49,50,51] #manuale


var dato: seq[byte]
let parola = "ciao"
var seq_par = toseq(parola)

for l in seq_par:
  echo l
  dato.add(l.ord.byte)

let dato_add = dato[0].addr
let dato_len = uint8(len(dato))
while true:
    discard writeBlocking(i2cBlok, 0x50.I2cAddress, dato_add, dato_len, true)
    sleepMs(5)

# ------ esempio 2 ---------
import picostdlib
import picostdlib/hardware/i2c

sleepMs(2000)
i2cSetupNim(i2c1, 15.Gpio, 14.Gpio, 50_000, true)

var dato: array[0..0, byte] = [75]

while true:
  discard i2cWriteBlockingNim(i2c1, 0x50.I2cAddress, dato, true)
  sleepMs(5)

# ---- esempio 3 --------
import picostdlib
import picostdlib/hardware/i2c
import std/[strformat]
stdioInitAll()

i2cSetupNim(i2c1, 15.Gpio, 14.Gpio, 50_000, true)
sleepMs(2000)

var arrayScrittura: array[0..3, byte] = [0, 0 ,75, 12]
#var arrayLettura: array[0..1, byte]

# ---------- Scrittura sulla Eeprom --------------
echo(fmt"Scrivo sella eeprom {arrayScrittura[2]}")

discard i2cWriteBlockingNim(i2c1, 0x50.I2cAddress, arrayScrittura, true)
sleepMs(100)

# ---------- Lettura sulla Eeprom --------------
var arrayLettura = i2cReadBlockingNim(i2c1, 0x50.I2cAddress, 4, true)
sleepMs(5)

print(fmt"Leggo sulla eeprom {arrayLettura}")
