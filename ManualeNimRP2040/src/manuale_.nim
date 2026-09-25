import picostdlib/[gpio, i2c, time, stdio]
from strutils import split
import picousb 
import ad5245

stdioInitAll()

setupI2c(blokk = i2c1, psda = 2.Gpio, pscl = 3.Gpio, freq = 50_000, true)#max 400khz
let digitPot = newAd5245(blokk = i2c1, address = 0x2C, resValue = 5000)
let usb = PicoUsb()
sleep(2000)

var
  usbVal: string
  splitList: seq[string]

while  true:
  if usb.isReady == true:
    usbVal = usb.readLine()
    splitList = split(usbVal, '#')
    case splitList[0] 
    of "setvalue":
      digitPot.setValue(uint8(usb.toInt(splitList[1])))
    of "setvoltage":
      #tempNumF = parseFloat(splitList[1])
      print("Vset--> " & $splitList[1])
      digitPot.setVoltage(usb.toFloat(splitList[1]), voltA=3.3)
      print("Il valore settato e': " & $digitPot.getValue())
    else:
      print("Errore!!")
      
