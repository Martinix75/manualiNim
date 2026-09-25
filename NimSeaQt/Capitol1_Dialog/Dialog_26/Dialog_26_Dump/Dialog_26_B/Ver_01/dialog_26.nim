import seaqt/[qapplication, qdialog, qboxlayout, qgridlayout, qpushbutton, qlabel, qcombobox, qspinbox, qcheckbox]
import qtconnect
import std/[strformat]

type  
  Madre = ref object
    dwin, dmwin: QDialog # = QDialog.create()
    lab_1: QLabel
    porta: cint =  1
    dtr: bool = false
    baud: string = "9600"

proc dumpModal(self: Madre) {.raises: [].}
proc aggiorna(self: Madre) {.raises: [].}
proc main(self: Madre) {.raises: [].}

proc winInit() =
  discard QApplication.create()
  let x = Madre(dwin: QDialog.create(), lab_1: QLabel.create("test"), dmwin: QDialog.create())
  x.main()

proc main(self: Madre) =
  let 
    mlay_1 = QVBoxLayout.create()
    mbot_1 = QPushButton.create("Setta Seriale")

  mlay_1.addWidget(mbot_1)
  mlay_1.addWidget(self.lab_1)
  
  connect(mbot_1, onClicked, dumpModal, self)
  
  self.dwin.setLayout(mlay_1)
  self.dwin.resize(300, 200)
  self.dwin.show()
  self.aggiorna()
  quit QApplication.exec().int

proc dumpModal(self: Madre) =
  echo("modal")
  let
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
  dmcob_1.setCurrentText(self.baud)
  dmchk_1.setChecked(self.dtr)
  dmspx_1.setRange(1, 5)
  dmspx_1.setValue(self.porta)
  
  dmlay_1.addWidget(dmlab_1, 0, 0)
  dmlay_1.addWidget(dmspx_1, 0, 1)
  dmlay_1.addWidget(dmlab_2, 1, 0)
  dmlay_1.addWidget(dmcob_1, 1, 1)
  dmlay_1.setColumnMinimumWidth(2, 40)
  dmlay_1.addWidget(dmchk_1, 1, 3)
  dmlay_1.addWidget(dmbut_1, 2, 0)
  dmlay_1.addWidget(dmbut_2, 2, 1)
  
  connect(dmbut_1, onClicked, self.dmwin.accept)
  connect(dmbut_2, onClicked, self.dmwin.reject)
  
  self.dmwin.setWindowTitle("Dump Modal")
  self.dmwin.setLayout(dmlay_1)
  self.dmwin.resize(300, 200)
  if self.dmwin.exec() == 1:
    echo("ok..")
    self.porta = dmspx_1.value()
    self.dtr = dmchk_1.isChecked()
    self.baud = dmcob_1.currentText()
    self.aggiorna()

proc aggiorna(self: Madre) =
  echo("Aggiorna..")
  let valore = if self.dtr == false: "OFF" else: "ON"
  self.lab_1.settext(fmt"Porta = {self.porta} <br> Baud = {self.baud} <br> DTR = {valore}")

winInit()
