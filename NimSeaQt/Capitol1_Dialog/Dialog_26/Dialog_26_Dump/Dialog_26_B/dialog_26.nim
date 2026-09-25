import seaqt/[qapplication, qdialog, qboxlayout, qgridlayout, qpushbutton, qlabel, qcombobox, qspinbox, qcheckbox]
import qtconnect4_3
import std/[strformat]

type
  Form = ref object
    dwin: QDialog # = QDialog.create()
    lab_1: QLabel
    porta: cint =  1
    dtr: bool = false
    baud: string = "9600"
  Dump = ref object
    form: Form
    dmwin: QDialog

proc dumpModal(self: Form) {.raises: [].}
proc aggiorna(form: Form) {.raises: [].}

proc finestra() =
  discard QApplication.create()
  let form = Form(dwin: QDialog.create(), lab_1: QLabel.create("test")) #, dmwin: QDialog.create())
  let 
    mlay_1 = QVBoxLayout.create()
    mbot_1 = QPushButton.create("Setta Seriale")
  form.lab_1.setTextFormat(1)
  mlay_1.addWidget(mbot_1)
  mlay_1.addWidget(form.lab_1)
  connect(mbot_1, onClicked, dumpModal, form)
  
  form.dwin.setLayout(mlay_1)
  form.dwin.resize(300, 200)
  form.dwin.show()
  form.aggiorna()
  quit QApplication.exec().int

proc aggiorna(form: Form) =
  echo("Aggiorna..")
  let valore = if form.dtr == false: "OFF" else: "ON"
  echo("Porta --> ", form.porta)
  echo("Baud --> ", form.baud)
  echo("DTR --> ", form.dtr)
  form.lab_1.setText(fmt"Porta = {form.porta} <br> Baud = {form.baud} <br> DTR = {valore}")

proc dumpModal(self: Form)=
  let modal = Dump(dmwin: QDialog.create(), form: self)
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
  dmcob_1.setCurrentText(modal.form.baud)
  dmchk_1.setChecked(modal.form.dtr)
  dmspx_1.setRange(1, 5)
  dmspx_1.setValue(modal.form.porta)
  
  dmlay_1.addWidget(dmlab_1, 0, 0)
  dmlay_1.addWidget(dmspx_1, 0, 1)
  dmlay_1.addWidget(dmlab_2, 1, 0)
  dmlay_1.addWidget(dmcob_1, 1, 1)
  dmlay_1.setColumnMinimumWidth(2, 40)
  dmlay_1.addWidget(dmchk_1, 1, 3)
  dmlay_1.addWidget(dmbut_1, 2, 0)
  dmlay_1.addWidget(dmbut_2, 2, 1)
  
  connect(dmbut_1, onClicked, modal.dmwin.accept)
  connect(dmbut_2, onClicked, modal.dmwin.reject)
  
  modal.dmwin.setWindowTitle("Dump Modal")
  modal.dmwin.setLayout(dmlay_1)
  modal.dmwin.resize(300, 200)
  if modal.dmwin.exec() == 1:
    echo("ok..")
    modal.form.porta = dmspx_1.value()
    modal.form.dtr = dmchk_1.isChecked()
    modal.form.baud = dmcob_1.currentText()
    modal.form.aggiorna()



finestra()
