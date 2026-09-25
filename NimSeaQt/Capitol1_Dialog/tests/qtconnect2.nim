import std/[macros, tables]

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

