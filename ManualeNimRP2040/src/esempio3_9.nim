import picostdlib
import picostdlib/pico/multicore
import std/[math]

stdioInitAll()
sleepMs(2000)
echo "Inizializzazione completata..."
sleepMs(200) #va messo un leggero ritardo anche qui!!!

proc core1() {.cdecl.} =
  sleepms(50)
  #echo("core 1 ok..")
  var
    numero0: uint32 = 0 #va assolutamente inizializato
    list0 = newSeq[uint32](0)
    sumList0:uint32 = 0 #va assolutamente inizializato
  
  if multicoreFifoRvalid() == true:
    numero0 = multicoreFifoPopBlocking()
    multicoreFifoDrain()
    #echo("Arrivato a Core1 --> ", numero0)
    for j in countUp(uint32(1), numero0):
      list0.add(j)
      sleepMs(50)
    sumList0 = sum(list0)
    echo("Somma Lista0 = ", sumList0)
    
    if multicoreFifoRvalid() == false:
      multicoreFifoPushBlocking(sumList0)

let
  lenList0: uint32 = 150
  lenList1:uint32 = 25
  
multicoreLaunchCore1(core1)
if multicoreFifoRvalid() == false:
  multicoreFifoPushBlocking(lenList0)

var
  list1 = newSeq[uint32](0)
  sumList1: uint32 = 0 #va assolutamente inizializato
  
echo("Creo Sequenza Core0..")
for l in countUp(uint32(1), lenList1):
  list1.add(uint32(sqrt(float(l))))
  sleepMs(20)
sumList1 = sum(list1)
echo("Somma Lista1 = ", sumList1)
multicoreFifoDrain()

while true:
  #echo("Core 0 ok...")
  #echo("Arrivato a Core0 --> ", numero1)
  sleepMs(400)
  if multicoreFifoRvalid() == true:
    let datoCore1:uint32  = multicoreFifoPopBlocking()
    echo("Somma Totale -->", datoCore1 + sumList1)
    break
echo("--- Fine Processo Ok ---")


# --------- esempio 1 ----------------
#[
import picostdlib
import picostdlib/pico/multicore

setupGpio(led1, 0, Out)
setupGpio(led2, 1, Out)
stdioInitAll()

proc lampeggio2() {.cdecl.} =
  while true:
    print("Lampeggio su Core1") #core1 Non stampa su usb!
    led2.put(High)
    sleepMs(150)
    led2.put(Low)
    sleepMs(500)

multicoreResetCore1()
multicoreLaunchCore1(lampeggio2)

while true:
  print("Lampeggio su Core0")
  led1.put(High)
  sleepMs(300)
  led1.put(Low)
  sleepMs(700)
]#

#---- esempio 2 ok per gcc14, nin2.20, pilisb 0.4.0 
#[import picostdlib
import picostdlib/pico/multicore

stdioInitAll()
sleepMs(2000)
echo "Inizializzazione completata..."

proc core1() {.cdecl.} =
  var counter1: int = 0
  var strValue: string
  while true:
    inc counter1
    sleepMs(1)
    echo(Core 1: ", counter1# & strValue)
    sleepMs(873)

echo(Avvio Core 1...")
multicoreLaunchCore1(core1)

var counter0: int = 0 #notare la dichiarazione specifica int (senza non va)
var strValue: string
while true:
  inc counter0
  sleepMs(2)
  echo("Core 0: " , counter0 #& strValue)
  sleepMs(1654)]#

da notre che count0 e 1 se non vengono dichiarati espliciti int potrebbe non funzionare
