import std/[tables, strutils]
import seaqt/[qapplication, qdialog, qgridlayout, qlabel, qlineedit, qspinbox, qcheckbox, qdialogbuttonbox, qpushbutton, qboxlayout]
import std/[macros, tables]
#import qtconnect

#[macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  let slotType = case $widgetSignal:
    of "onTextChanged": ident"QLineEdittextChangedSlot"
    of "onClicked": ident"QPushButtonclickedSlot"
    of "onValueChanged": ident"QSpinBoxvalueChangedSlot"
    else: ident"QLineEdittextChangedSlot" # fallback

  result = quote do:
    `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: openArray[char]) {.closure.} = `callFunction`())) ]#
#[macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  # Lista dei segnali "speciali" che richiedono parametri
  let specialSignals = [
    "onTextChanged",
    "onValueChanged",
    "onCurrentTextChanged",
    "onEditingFinished"
    # Aggiungi qui altri segnali speciali che necessitano di parametri
  ]

  let signalStr = $widgetSignal

  # Controlla se è un segnale speciale
  if signalStr in specialSignals:
    # Determina il tipo di slot appropriato
    let slotType = case signalStr:
      of "onTextChanged": ident"QLineEdittextChangedSlot"
      of "onValueChanged": ident"QSpinBoxvalueChangedSlot"
      of "onCurrentTextChanged": ident"QComboBoxcurrentTextChangedSlot"
      of "onEditingFinished": ident"QLineEditEditingFinishedSlot"
      else: ident"QLineEdittextChangedSlot" # fallback per sicurezza

    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: openArray[char]) {.closure.} = `callFunction`()))

  else:
    # Genera il codice per segnali classici (senza parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`()) ]#

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  # Definizione dei segnali speciali con slot type e parameter type
  let specialSignals = {
    "onTextChanged": (ident"QLineEdittextChangedSlot",
                     nnkBracketExpr.newTree(ident"openArray", ident"char")),
    "onValueChanged": (ident"QSpinBoxvalueChangedSlot", ident"int"),
    "onCurrentTextChanged": (ident"QComboBoxcurrentTextChangedSlot",
                           nnkBracketExpr.newTree(ident"openArray", ident"char")),
    "onEditingFinished": (ident"QLineEditEditingFinishedSlot", ident"void"),
    "onCurrentIndexChanged": (ident"QComboBoxcurrentIndexChangedSlot", ident"int"),
    "onItemSelectionChanged": (ident"QListWidgetitemSelectionChangedSlot", ident"void"),
    "onDoubleValueChanged": (ident"QDoubleSpinBoxvalueChangedSlot", ident"float64")
    # Aggiungi qui altri segnali speciali: "signal": (slotType, parameterType)
  }.toTable

  let signalStr = $widgetSignal

  # Controlla se è un segnale speciale
  if signalStr in specialSignals:
    let (slotType, paramType) = specialSignals[signalStr]

    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`()))

  else:
    # Genera il codice per segnali classici (senza parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`())


type
  Form = ref object
    lie: QLineEdit
    lab: QLabel
    bot: QPushButton

proc test(a: Form)  {.raises:[].}
proc test2()  {.raises:[].}

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
  connect(form.lie, onTextChanged, test2)
  connect(form.bot, onClicked, test2)

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


proc test2() =
  echo("Reset")


