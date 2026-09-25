import picostdlib

setupGpio(led1, 0, Out)
setupGpio(pulsante1, 13, In); pulsante1.pullUp()
setupGpio(pulsante2, 15, In); pulsante2.pullUp()
stdioInitAll()
var 
  #flag: bool = false
  pulsanteRilasciato: bool = true
  tempoAttuale: uint32 = 0
  tempoOn: uint32 = 3000000
  tempoOff: uint64 = 6000000
sleepUs(3000000)
print("init....")
while true:
  if pulsante1.get() == Low:# or flag == true:
    print("P1 premuto Ok")
    if pulsanteRilasciato == true:
      tempoAttuale = timeUs32()
      pulsanteRilasciato = false
      print("Preso tempo OK")
    if timeUs32()-tempoAttuale > tempoOn:
      print("On led")
      led1.put(High)
      pulsanteRilasciato = true

 
  if pulsante2.get() == Low:
    print("P2 premuto Ok")
    if pulsanteRilasciato == true:
      tempoAttuale = timeUs32()
      pulsanteRilasciato = false
      print("Preso tempo OK")
    if timeUs64()-tempoAttuale > tempoOff:
      print("Off Led")
      led1.put(Low)
      pulsanteRilasciato = true
  
  if pulsante1.get() == High and pulsante2.get() == High:
    tempoAttuale = timeUs32()

