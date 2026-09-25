#[implification of the Signal/Slot mechanism for Nim-Sea-Qt. With the possibility of passing topics to the function called.
by MArtinix75 2025
version 0.4.0
]#
import std/[macros,tables]
    
proc getSpecialSignals(): Table[string, (NimNode, NimNode)] =
  result = {
    "onTextChanged": (ident"QLineEdittextChangedSlot", nnkBracketExpr.newTree(ident"openArray", ident"char")),
    "onStateChanged": (ident"QCheckBoxstateChangedSlot", ident"cint"),
    "onValueChanged": (ident"QSpinBoxvalueChangedSlot", ident"cint")
  }.toTable



macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  let specialSignals = getSpecialSignals()
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
      
      

macro connect*[T](widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: T) = #con argomento a funzione
  let specialSignals = getSpecialSignals()
  let signalStr = $widgetSignal

  # Controlla se è un segnale speciale
  if signalStr in specialSignals:
    let (slotType, paramType) = specialSignals[signalStr]

    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`(`functionArg`)))

  else:
    # Genera il codice per segnali classici (senza parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`(`functionArg`))
