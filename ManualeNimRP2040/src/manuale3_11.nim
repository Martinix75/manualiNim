#--- SPI ------
# --- esembio raw base -------
import picostdlib
import picostdlib/hardware/spi


sleepMs(2000)
echo("Via...")
#var port = spi1
discard init(spi1, 100_000)

10.Gpio.setFunction(SPI)
11.Gpio.setFunction(SPI)
12.Gpio.setFunction(SPI)
13.Gpio.setFunction(SPI)



let dato: array[2, byte] = [75, 66]
#let ll = csize_t(dato.len*sizeof(dato[0]))
while true:
  discard writeBlocking(spi1,dato[0].addr, dato.len.uint)
  sleepMs(5)

# -------- esempio 1 --------------
import picostdlib
import picostdlib/hardware/spi
#import std/[strformat]
stdioInitAll()

proc spiSetupNim(spi: ptr SpiInst; sck, tx, rx, cs: uint; freq: uint): ptr SpiInst=
  #sugar setup for spi:
  #spi = port spi  spi1 / spi0 (see pinOut Rp 2040).
  ##skc = clock sck pin (see pinOut Rp 2040).
  ##tx = transmit rp --> device (MOSI) (see pinOut Rp 2040).
  ##rx = recive rp <-- device (MISO) (see pinOut Rp 2040).
  ##cs = chip select (see pinOut Rp 2040).
  #freq = transmission frequency (Consult your device datasheet to set it)
  let port = spi
  discard init(port, freq)
  Gpio(sck).setFunction(Spi)
  Gpio(tx).setFunction(Spi)
  Gpio(rx).setFunction(Spi)
  Gpio(cs).setFunction(Spi)
  result = spi

sleepMs(2000)
echo("Via...")
let port=spiSetupNim(spi1, 10, 11, 12, 13, 100_000)
#[var port = spi1
discard init(port, 100_000)

10.Gpio.setFunction(SPI)
11.Gpio.setFunction(SPI)
12.Gpio.setFunction(SPI)
13.Gpio.setFunction(SPI)]#


let dato: array[0..7, byte] = [77,97,114,116,105,110,105,120]
while true:
  #echo("Scrivo su SPI..")
  discard writeBlocking(port, dato[0].addr, dato.len.uint)
  sleepMs(10)

# --- esempio 2 scrittura 2 byte continui ----
import picostdlib
import picostdlib/hardware/spi
#import std/[strformat]
#stdioInitAll()

proc spiSetupNim(spi: ptr SpiInst; sck, tx, rx, cs: uint; freq: uint): ptr SpiInst=
  #sugar setup for spi:
  #spi = port spi  spi1 / spi0 (see pinOut Rp 2040).
  ##skc = clock sck pin (see pinOut Rp 2040).
  ##tx = transmit rp --> device (MOSI) (see pinOut Rp 2040).
  ##rx = recive rp <-- device (MISO) (see pinOut Rp 2040).
  ##cs = chip select (see pinOut Rp 2040).
  #freq = transmission frequency (Consult your device datasheet to set it)
  let port = spi
  discard init(port, freq)
  Gpio(sck).setFunction(Spi)
  Gpio(tx).setFunction(Spi)
  Gpio(rx).setFunction(Spi)
  Gpio(cs).setFunction(Spi)
  result = spi

sleepMs(2000)
echo("Via...")
#let port=spiSetupNim(spi1, 10, 11, 12, 13, 100_000)
var port = spi1
discard init(port, 100_000)

10.Gpio.setFunction(SPI)
11.Gpio.setFunction(SPI)
12.Gpio.setFunction(SPI)
let pin = 13.Gpio; pin.init(); pin.setDir(Out)
#13.Gpio.setFunction(SPI)


let dato: array[0..1, uint16] = [0x0013, 0x0022]
let ll = csize_t(((dato.len)-1)*sizeof(dato[0]))
while true:
  #echo("Scrivo su SPI..")
  pin.put(Low)
  discard write16Blocking(port,dato[0].addr, ll)
  pin.put(High)
  sleepMs(5)
#---- 3 16 bit con fuz pria ----
import picostdlib
import picostdlib/hardware/spi
import spinim
#import std/[strformat]
#stdioInitAll()

import picostdlib/hardware/spi

proc spiSetup16Nim*(spi: ptr SpiInst; sck, tx, rx: uint; freq: uint): ptr SpiInst =
  let port = spi
  discard init(port, freq)
  Gpio(sck).setFunction(Spi)
  Gpio(tx).setFunction(Spi)
  Gpio(rx).setFunction(Spi)
  result = spi

proc spiWrite16BlockingNim*(spi: ptr SpiInst; pin: Gpio; dato: uint16) {.inline.} =
  let byte_high: byte = byte(dato shr 8)
  let byte_low: byte = byte(dato)
  let dato8: array[2, byte] = [byte_high, byte_low]
  pin.put(Low)
  discard writeBlocking(spi, dato8)
  pin.put(High)

let datax: uint16 = 0x1337
let cs = 13.Gpio; cs.init; cs.setDir(Out); cs.pullUp()

let comm = spiSetup16Nim(spi1, 10, 11, 12, 100_000)
while true:
  spiWrite16BlockingNim(comm, cs, datax)
  sleepMs(3)
