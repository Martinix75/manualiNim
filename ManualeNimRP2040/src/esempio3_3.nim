import picostdlib

setupGpio(led1, 0, Out)
setupGpio(pulsante1, 13, In)
setupGpio(pulsante2, 15, In); pulsante2.pullUp()

var flag: bool = false

while true:
  if pulsante1.get() == 0.Value or flag == true:
    led1.put(High)
    sleepMs(300)
    led1.put(Low)
    flag = true
    sleepMs(700)
  if pulsante2.get() == Low:
    led1.put(Low)
    flag = false
