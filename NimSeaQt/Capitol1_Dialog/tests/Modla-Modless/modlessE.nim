import std/strutils
import seaqt/[qapplication, qdialog, qboxlayout, qpushbutton, qlabel, qspinbox]
import qtconnect

type
  Windo = ref object #ci deve essere per ragruppare i widget e sopratutto tenerli vivi.
    dlg: QDialog
    spi: QSpinBox
    btnOk, btnCancel: QPushButton
    
proc applica() {.raises: [].}

var dialogs: seq[Windo] #truccazzo per tenere viva la finetra modless

proc modlessA*(): Windo =
  let w = Windo(dlg: QDialog.create())
  w.dlg.setWindowTitle("Modelless")

  w.spi = QSpinBox.create(w.dlg)
  w.btnOk = QPushButton.create("OK", w.dlg)
  w.btnCancel = QPushButton.create("Rifiuta", w.dlg)

  let layMain = QVBoxLayout.create()
  let layBtns = QHBoxLayout.create()
  layBtns.addWidget(w.btnOk)
  layBtns.addWidget(w.btnCancel)
  layMain.addWidget(w.spi)
  layMain.addLayout(layBtns)
  w.dlg.setLayout(layMain)
  connect(w.btnOk, onClicked, applica)

  dialogs.add(w)  # tieni vivo il ref inserisce il qdilog in uan sequenza che noin viene distrutta

  w.dlg.show()

proc applica() =
  echo("Applico")
