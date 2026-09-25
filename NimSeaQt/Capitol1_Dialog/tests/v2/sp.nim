import std/[tables, strutils]
import seaqt/[qapplication, qdialog, qgridlayout, qlabel, qlineedit, qspinbox, qcheckbox, qdialogbuttonbox, qpushbutton, qboxlayout]
import std/macros
import qtconnect

#[macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  let slotType = case $widgetSignal:
    of "onTextChanged": ident"QLineEdittextChangedSlot"
    of "onClicked": ident"QPushButtonclickedSlot"
    of "onValueChanged": ident"QSpinBoxvalueChangedSlot"
    else: ident"QLineEdittextChangedSlot" # fallback

  result = quote do:
    `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: openArray[char]) {.closure.} = `callFunction`())) ]#


type
  Form = ref object
    lie: QLineEdit
    lab: QLabel
    bot: QPushButton

proc test(a: Form)  {.raises:[].}
proc test2(a: Form)  {.raises:[].}

proc finestra() =
  discard QApplication.create()
  let
    form = Form()
    dwin = QDialog.create
    #lie = QLineEdit.create
    #lab = QLabel.create("Ciao: ")
    lay = QVBoxLayout.create()
  form.lie = QLineEdit.create
  form.lab = QLabel.create("Ciao: ")
  form.bot = QPushButton.create("Reset")

  # connessione corretta
  #lie.onTextChanged(QLineEdittextChangedSlot(proc(param1: openArray[char]) {.closure.} = test(param1)))
  connect(form.lie, onTextChanged, test, form)
  #connect(form.bot, onClicked, test2, form)

  lay.addWidget(form.lie)
  lay.addWidget(form.bot)
  lay.addWidget(form.lab)
  dwin.setLayout(lay)
  dwin.resize(200, 150)
  dwin.show()


  quit QApplication.exec().int

finestra() #questa funziona...

proc test(a: Form) =
  echo "VV -> "
  a.lab.setText(a.lie.text())


proc test2(a: Form) =
  echo("Reset")


