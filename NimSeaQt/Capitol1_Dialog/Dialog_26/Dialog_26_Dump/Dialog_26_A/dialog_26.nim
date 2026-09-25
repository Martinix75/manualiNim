import seaqt/[qapplication, qdialog, qboxlayout, qgridlayout, qpushbutton, qlabel, qcombobox, qspinbox, qcheckbox]
import qtconnect
import std/[strformat]

proc dumpModal() {.raises: [].}
proc aggiorna() {.raises: [].}

discard QApplication.create()
var
  porta = 1
  dtr = false 
  baud = "9600"
let 
  dwin = QDialog.create()
  lay_1 = QVBoxLayout.create()
  bot_1 = QPushButton.create("Setta Seriale")
  lab_1 = QLabel.create()
  
lab_1.setTextFormat(1)

lay_1.addWidget(bot_1)
lay_1.addWidget(lab_1)

connect(bot_1, onClicked, dumpModal)

dwin.setLayout(lay_1)
dwin.resize(300,200)
dwin.show()
dwin.setWindowTitle("Set Seriale")
aggiorna()
quit QApplication.exec().int

proc dumpModal() =
  echo("modal")
  let
    dmwin = QDialog.create()
    dmlay_1 = QGridLayout.create()
    dmlab_1 = QLabel.create("Porta")
    dmlab_2 = QLabel.create("Baud")
    dmcob_1 = QComboBox.create()
    dmchk_1 = QCheckBox.create("DTR")
    dmspx_1 = QSpinbox.create()
    dmbut_1 = QPushButton.create("Accetta")
    dmbut_2 = QPushButton.create("Rifiuta")
  dmcob_1.addItem("9600")
  dmcob_1.addItem("19200")
  dmcob_1.addItem("115200")
  dmcob_1.setCurrentText(baud)
  dmchk_1.setChecked(dtr)
  dmspx_1.setRange(1, 5)
  dmspx_1.setValue(porta.cint)
  
  dmlay_1.addWidget(dmlab_1, 0, 0)
  dmlay_1.addWidget(dmspx_1, 0, 1)
  dmlay_1.addWidget(dmlab_2, 1, 0)
  dmlay_1.addWidget(dmcob_1, 1, 1)
  dmlay_1.setColumnMinimumWidth(2, 40)
  dmlay_1.addWidget(dmchk_1, 1, 3)
  dmlay_1.addWidget(dmbut_1, 2, 0)
  dmlay_1.addWidget(dmbut_2, 2, 1)
  
  connect(dmbut_1, onClicked, dmwin.accept)
  connect(dmbut_2, onClicked, dmwin.reject)
  
  dmwin.setWindowTitle("Dump Modal")
  dmwin.setLayout(dmlay_1)
  dmwin.resize(300, 200)
  if dmwin.exec() == 1:
    porta = dmspx_1.value()
    dtr = dmchk_1.isChecked()
    baud = dmcob_1.currentText()
    aggiorna()

proc aggiorna() =
  echo("Aggiorna..")
  let valore = if dtr == false: "OFF" else: "ON"
  lab_1.settext(fmt"Porta = {porta} <br> Baud = {baud} <br> DTR = {valore}")
