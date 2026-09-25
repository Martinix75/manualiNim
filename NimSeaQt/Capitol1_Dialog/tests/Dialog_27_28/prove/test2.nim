import std/[random, tables, math, strutils, algorithm]
import seaqt/[qapplication, qdialog, qtablewidget, qtablewidgetitem, qpushbutton, qboxlayout, qdialogbuttonbox]
import qtconnect

type  
  Form = ref object
    dwin: QDialog
    dtab_1: QTableWidget
    numeriTab: Table[array[2, int],float]
    formati: Table[string, string] = {"separatore": "'", "decimali": ".","numDec": "2", "redNeg": "unchecked"}.toTable
    #item: QTableWidgetItem
    xMax: cint = 7
    yMax: cint = 10
    items: seq[QTableWidgetItem]

proc aggiornaTabella(xz: Form) #aggiorna i dati della tabella
proc creaNumeriTabella(vj: Form) #crea i numri da mettre in tabella rnd
    
proc finestra() =
  discard QApplication.create()
  let 
    form = Form(dtab_1: QTableWidget.create(), numeriTab: initTable[array[2, int], float](), dwin: Qdialog.create())
    lay_1 = QVBoxLayout.create()
    lay_2 = QHBoxLayout.create()
    bot_1 = QPushButton.create("Modal")
    bot_2 = QPushButton.create("Modless")

  lay_2.addWidget(bot_1)
  lay_2.addWidget(bot_2)
  lay_1.addWidget(form.dtab_1)
  lay_1.addLayout(lay_2)
  
  form.dwin.setLayout(lay_1)
  form.dwin.resize(755, 415)
  form.creanumeriTabella()
  form.aggiornaTabella()
  form.dwin.show()
  form.dwin.setWindowTitle("Tabella")
  quit QApplication.exec().int

finestra()

#[proc aggiornatabella(xz: Form) =
  echo("Aggiorno Tabella..")
  var 
    contatore = 0
    strTemp: string
    
  #xz.dtab_1.clear()
  xz.dtab_1.setColumnCount(xz.xMax)
  xz.dtab_1.setRowCount(xz.yMax)
  xz.dtab_1.setHorizontalHeaderLabels(@["A","B","C","D","E","F","G"])
  for x in countUp(0, xz.yMax - 1):
    for y in countUp(0, xz.xMax - 1):
      let splitNum = splitdecimal(xz.numeriTab[[x,y]]) #splitta il numero in due parte intere e parte decimale
      let segno = if xz.numeriTab[[x,y]] < 0: "-" else: "" #se abbiamo un numero negativo metti in memoria "-" stringa.
      let interoStr = $(abs(splitNum[0])) #prende il primo elemento fa valore assolute, poi converte in stringa.
      let decimale =  abs(splitNum[1]) #prende il decimale e ricava valore assoluto (se è meno viene postoa bche sul decimale).
      let decimaleStr = $round(decimale, parseInt($xz.formati["numDec"])) #arrotonda "decimale" alle cifre imposte da numDec.
      for txt in countDown(len(interoStr)-1, 0): #prende la lunghezza di intero stringa-1 e conta a ritroso
        if contatore == 3: #se la variabile contatore scend a 3 ovvero divisione migliaia del numero..
          strTemp = strTemp & xz.formati["separatore"] & interoStr[txt] #ricostruisce la stringa con il separatore alla 3 cifra.
          contatore = 0
        else: #se diverso da 3...
          strTemp = strTemp & interoStr[txt] #ricostruisce la stringa ma senza aggiunre il separatore.
          contatore.inc() #incrementa di 1 la variabile contatore.
      echo("tt--> ",strTemp)
      let invertStr = reversed(strTemp)
      echo("ff --> ", invertStr)
      let interoJStr = join(invertStr,"")
      echo("xx --<", interoJStr)
      let strFinale = segno & interoJStr & $xz.formati["decimali"] & decimaleStr[2..^1]
      echo("kk -->", strFinale)
      let item = QTableWidgetItem.create("Xyu")
      xz.dtab_1.setItem(x.cint, y.cint, item)
      xz.items.add(item)
      contatore = 0
      strTemp=""]#

proc aggiornatabella(xz: Form) =
  echo("Aggiorno Tabella..")
  var 
    contatore = 0
    strTemp: string
    #items: seq[QTableWidgetItem]
    
  xz.dtab_1.clear()
  xz.dtab_1.setColumnCount(xz.xMax)
  xz.dtab_1.setRowCount(xz.yMax)
  xz.dtab_1.setHorizontalHeaderLabels(@["A","B","C","D","E","F","G"])
  for x in countUp(0, xz.yMax - 1):
    for y in countUp(0, xz.xMax - 1):
      let item = QTableWidgetItem.create("ciao")
      xz.dtab_1.setItem(x.cint, y.cint, item)
      xz.items.add(item)
      
proc creaNumeriTabella(vj: Form) =
  echo("Creo Numeri in tabella random..")
  randomize()
  for x in countUp(0, vj.yMax - 1):
    for y in countUp(0, vj.xMax - 1):
      vj.numeriTab[[x, y]] = (10000*rand(1.0)) - 5000
      echo(vj.numeriTab)
