
import std/[random, tables, math, strutils, algorithm]
import seaqt/[qapplication, qdialog, qtablewidget, qtablewidgetitem, qpushbutton, qboxlayout, qdialogbuttonbox, qbrush, qcolor]
import qtconnect6_1
import modal
import modless
import live

type  
  Form = ref object
    dwin: QDialog
    dtab_1: QTableWidget
    numeriTab: Table[array[2, int],float]
    formati: Table[string, string] = {"separatore": "'", "decimali": ".","numDec": "3", "redNeg": "checked"}.toTable
    xMax: cint = 7
    yMax: cint = 10
    items: seq[QTableWidgetItem] #crea un dizionario che matenga i dati anvche dopo la distruzione della prc da gc.

proc aggiornaTabella(xz: Form) {.raises: [].} #aggiorna i dati della tabella
proc creaNumeriTabella(vj: Form) #crea i numri da mettre in tabella rnd
proc modale(mo: Form) {.raises: [].}
proc modless(le: Form) {.raises: [].}
proc live(li: Form) {.raises: [].}

proc finestra() =
  discard QApplication.create()
  let 
     #form = Form(dtab_1: QTableWidget.create(), numeriTab: initTable[array[2, int], float](), dwin: Qdialog.create())
    form = Form()
    lay_1 = QVBoxLayout.create()
    lay_2 = QHBoxLayout.create()
    bot_1 = QPushButton.create("Modal")
    bot_2 = QPushButton.create("Modless")
    bot_3 = QPushButton.create("Live")
  
  form.dtab_1 = QTableWidget.create()
  form.numeriTab = initTable[array[2, int], float]()
  form.dwin = QDialog.create()

  lay_2.addWidget(bot_1)
  lay_2.addWidget(bot_2)
  lay_2.addWidget(bot_3)
  lay_1.addWidget(form.dtab_1)
  lay_1.addLayout(lay_2)

  connect(bot_1, onClicked, modale,form)
  connect(bot_2, onClicked, modless,form)
  connect(bot_3, onClicked, live, form)
  
  form.dwin.setLayout(lay_1)
  form.dwin.resize(755, 415)
  form.creanumeriTabella()
  form.aggiornaTabella()
  form.dwin.show()
  form.dwin.setWindowTitle("Tabella")
  quit QApplication.exec().int

finestra()

proc creaNumeriTabella(vj: Form) =
  echo("Creo Numeri in tabella random..")
  randomize()
  for x in countUp(0, vj.yMax - 1):
    for y in countUp(0, vj.xMax - 1):
      vj.numeriTab[[x, y]] = (10000*rand(1.0)) - 5000
      #echo(vj.numeriTab)

proc aggiornatabella(xz: Form) =
  echo("Aggiorno Tabella..")
  var 
    contatore = 0
    strTemp: string
    
  xz.dtab_1.clear() #cancella la tabella ddai vecchi dati se occorre
  #xz.dtab_1.clear() #cancella il sequenza se occorre.
  xz.dtab_1.setColumnCount(xz.xMax)
  xz.dtab_1.setRowCount(xz.yMax)
  xz.dtab_1.setHorizontalHeaderLabels(@["A","B","C","D","E","F","G"])
  for x in countUp(0, xz.yMax - 1):
    for y in countUp(0, xz.xMax - 1):
      try:
        let arrotonda = $abs(round(xz.numeriTab[[x, y]], parseInt(xz.formati["numDec"]))) #arrotonda il numero con al cifre decimali desiderate.
        let segno = if xz.numeriTab[[x,y]] < 0: "-" else: "" #se numero negarivo memorizza un "-" stringa.
        let splitNum = split(arrotonda, ".") #spacca il numero sul "." diventa uan seq di due numeri intero e decimale.
        for txt in countDown(len(splitNum[0])-1, 0): #prende la lunghezza di intero stringa-1 e conta a ritroso
          strTemp = strTemp & splitNum[0][txt] # metti uno alla volta i caratteri che compongono il numero dall'ultimo carattere'
          if contatore == 2: # se contatore arriva a 3...
            strTemp = strTemp & xz.formati["separatore"]#.. allora mettici il separatore di migliaia.
            contatore = 0 #azzera contatore
          contatore.inc() #se non è a 2 83 elemeti) incrementa di 1
        let invertStr = reversed(strTemp) #inverti la stringa (è memorizzata al contrario (forma uan lista di caratteri.
        let interoJStr = join(invertStr,"") #unisci tutto in uan stringa unica.
        let strFinale = segno & interoJStr & $xz.formati["decimali"] & splitNum[1] #costruisci la stringa finale con gli elemeti calcolati.
        let item = QTableWidgetItem.create(strFinale) #metila negli item della tabella.
        if segno == "-" and xz.formati["redNeg"] == "checked": #se è un numero negativo sfrivlo in rosso
          item.setForeground(QBrush.create(QColor.create(r=255.cint, g=15.cint, b=15.cint))) #cambia il colore del testo in rosso
        xz.dtab_1.setItem(x.cint, y.cint, item) #scrive l'item nella tabella'
        xz.items.add(item) #aggiunge l'item alla sequanza che rimane sempre viva e visibile.
        contatore = 0
        strTemp=""
      except KeyError:
        discard
      except ValueError:
        discard

#[proc modale(mo: Form) =
  echo("Modale Call..")
  mo.formati = modalx(mo.formati)
  #mo.formati = ritorno
  mo.aggiornaTabella() ]#

proc modale(mo: Form) =
  echo("Modale2...")
  let fd = modalx(mo.dwin, mo.formati)
  if fd.dlg.exec() == 1:
      echo("Ritorno")
      mo.formati = fd.tabx
      #echo(fd.mqle_1.text())
      mo.aggiornaTabella()

proc modless(le: Form) =
  echo("Modless Call..")
  let jk = modlessx(le.dwin, le.formati)
  echo("Modles Proc dialog: ", le.formati)
  jk.onDataCh = proc() =
                  echo("Test")
                  le.formati = jk.tabx
                  le.aggiornaTabella()
  jk.dlg.show()
  
proc live(li: Form) =
  echo("Live...")
  let jk = livex(li.dwin, li.formati)
  echo("Live Proc dialog: ", li.formati)
  jk.onDataCh = proc() =
                  echo("Test")
                  li.formati = jk.tabx
                  li.aggiornaTabella()
  jk.dlg.show()
