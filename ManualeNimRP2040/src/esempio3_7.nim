import picostdlib
import std/[math]

#[ # --------- esempio 1 ---------
setupGpio(led1, 0, Out)
setupGpio(pulsante1, 17, In); pulsante1.pullUp()
#setupGpio(pulsante2, 20.Gpio, false); pulsante2.pullUp()
stdioInitAll()
    
proc accendiLed(pin: Gpio, events: uint32)  {.cdecl.} =
  led1.put(High)
  print("Led Acceso")

setIrqEnabledWithCallback(17.Gpio, {GpioIrqLevel.EdgeRise}, true, accendiLed)

while true:
  print("inizio..")
  led1.put(Low)
  var lista:seq[int]
  var somma:int
  for numero in 0..50:
    lista.add(numero^2)
    print("Valore Istantaneo: " & $(numero^2))
    sleepMs(250)
  somma = lista.sum()
  print("Valore Finale: " & $somma)
  ]#

# --------- esempio 2 ---------
import picostdlib
import picostdlib/hardware/[gpio]
import picostdlib/pico/[stdio]
sleepMs(1000)
stdioInitAll()

setupGpio(led, 0 ,Out)
setupGpio(irq_1, 14, In); irq_1.pullDown()
setupGpio(irq_2, 15, In); irq_2.pullDown()

proc interrupt_generico(pin: Gpio; events: uint32) {.cdecl.} =
  echo("Interrupt: ", events, "  da Pin: ", $pin)
  case pin:
    of 14.Gpio:
      led.put(High)
    of 15.Gpio:
      led.put(Low)
    else:
      led.put(Low)

setIrqEnabledWithCallback(14.Gpio, {EdgeRise}, true, interrupt_generico)
setIrqEnabledWithCallback(15.Gpio, {EdgeRise}, true, interrupt_generico)

var number: Natural = 1
while true:
  echo("Loop: ", number)
  inc number
  sleepMs(5000)
