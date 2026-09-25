import std/strutils
import seaqt/[qapplication, qdialog, qboxlayout, qpushbutton, qlabel, qspinbox]
import qtconnect
import modlessE

type Win = ref object
      val: int
type
  Windo = ref object #ci deve essere per ragruppare i widget e sopratutto tenerli vivi.
    dlg: QDialog
    spi: QSpinBox
    btnOk, btnCancel: QPushButton

proc modale() {.raises: [].}
#proc modlessx(a: int) {.raises: [].}
proc modlessA() {.raises: [].}

discard QApplication.create()
let dwin = QDialog.create()
let lay_1 = QVBoxlayout.create()
let bot_1 = QPushButton.create("Modale")
let bot_2 = QPushButton.create("Modless")
var lab_1 = QLabel.create()
lab_1.setText("20")
lab_1.setStyleSheet("background: rgb(0, 40, 128)")

lay_1.addWidget(bot_1)
lay_1.addWidget(bot_2)
lay_1.addWidget(lab_1)
var antic = 0
connect(bot_1, onClicked, modale)#, self)
connect(bot_2, onClicked, modlessA)#, self)

dwin.setLayout(lay_1)  
dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int

proc modale() =
  echo("Modale")
  let dwin = QDialog.create()
  let lay_2 = QVBoxlayout.create()
  let lay_3 = QHBoxlayout.create()
  let spi_1 = QSpinbox.create()
  try:
    let a = int32(parseInt($lab_1.text()))
    spi_1.setValue(a)
  except ValueError:
      discard
  let bot_3 = QPushButton.create("ok")
  let bot_4 = QPushButton.create("Chiudi")
  
  lay_3.addWidget(bot_3)
  lay_3.addWidget(bot_4)
  lay_2.addWidget(spi_1)
  lay_2.addLayout(lay_3)
  
  connect(bot_3, onClicked, dwin.accept)
  connect(bot_4, onClicked, dwin.reject)
  
  dwin.setLayout(lay_2)
  dwin.setModal(true)
  dwin.resize(200, 200)
  if dwin.exec == 1:
    lab_1.setText($spi_1.value())

    
proc applica(val: cint) {.raises: [].}

var dialogs: seq[Windo] #truccazzo per tenere viva la finetra modless






proc modlessA() =
  let w = Windo(dlg: QDialog.create())
  w.dlg.setWindowTitle("Modelless")

  w.spi = QSpinBox.create(w.dlg)
  w.btnOk = QPushButton.create("OK", w.dlg)
  w.btnCancel = QPushButton.create("Chiudi", w.dlg)

  let layMain = QVBoxLayout.create()
  let layBtns = QHBoxLayout.create()
  
  try:
    let a = int32(parseInt($lab_1.text()))
    w.spi.setValue(a)
  except ValueError:
      discard
      
  layBtns.addWidget(w.btnOk)
  layBtns.addWidget(w.btnCancel)
  layMain.addWidget(w.spi)
  layMain.addLayout(layBtns)
  w.dlg.setLayout(layMain)
  connect(w.btnOk, onClicked, applica, w.spi.value())
  connect(w.btnCancel, onClicked, w.dlg.reject)
  
  dialogs.add(w)  # tieni vivo il ref inserisce il qdilog in uan sequenza che noin viene distrutta
  w.dlg.resize(200, 200)
  w.dlg.show()

proc applica(val: cint) =
  echo("Applico")
  lab_1.setText($val)


  
