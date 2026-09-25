#[implification of the Signal/Slot mechanism for Nim-Sea-Qt. With the possibility of passing topics to the function called.
by MArtinix75 2025
version 0.2.1
]#
import std/[macros,tables]

#[macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`())

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`()) ]#
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


#----------- overload functin args -----------------------------------------------------------------
macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: int) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: int) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: float) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: float) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: string) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: string) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))
macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: seq[int]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: seq[int]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: seq[float]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: seq[float]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))
        
macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: seq[string]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: seq[string]) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))

# ------------- test --------------
macro connect*[T](widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: T) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc() {.closure.} =
            `callFunction`(`functionArg`))

macro connect*[T](widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; qtArg: untyped; functionArg: T) =
    result = quote do:
        `widgetCall`.`widgetSignal`(
            proc(qtArg: `qtArg`) {.closure.} =
            `callFunction`(`functionArg`))
