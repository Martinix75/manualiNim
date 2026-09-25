#[
Smart connect macro che deduce automaticamente il tipo del widget
by MArtinix75 2025
version 0.4.0
]#
import std/[macros, tables, strutils]

# Funzione per costruire automaticamente il nome dello slot
proc buildSlotName(widgetTypeName: string, signalName: string): NimNode =
  # Rimuove "on" dall'inizio del segnale
  let cleanSignal = if signalName.startsWith("on"): signalName[2..^1] else: signalName
  # Costruisce: WidgetType + Signal + "Slot"
  let slotName = "Q" & widgetTypeName & cleanSignal & "Slot"
  result = ident(slotName)

# Mappa dei segnali speciali e i loro tipi di parametro
proc getSignalParameterTypes(): Table[string, NimNode] =
  result = {
    "onTextChanged": nnkBracketExpr.newTree(ident"openArray", ident"char"),
    "onStateChanged": ident"cint",
    "onValueChanged": ident"cint",
    "onCurrentTextChanged": nnkBracketExpr.newTree(ident"openArray", ident"char"),
    "onCurrentIndexChanged": ident"cint"
    # Aggiungi qui altri segnali con i loro tipi
  }.toTable

# Versione intelligente senza argomenti aggiuntivi  
macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  let signalParameterTypes = getSignalParameterTypes()
  let signalStr = $widgetSignal
  
  # Prova a ottenere il tipo del widget
  let widgetType = widgetCall.getType()
  echo "Debug - Widget type raw: ", widgetType.treeRepr
  let j = widgetType.treeRepr
  let b = j.split(" ")
  echo("test2: ", b[5][10..^3])
  let c = b[5][10..^3]
  
  # Controlla se è un segnale speciale
  if signalStr in signalParameterTypes:
    # Prova a estrarre il nome del tipo
    let widgetTypeName = c  # Questo potrebbe non funzionare direttamente
    echo "Debug - Widget type name: ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    echo "Debug - Generated slot type: ", $slotType
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`()))
  else:
    # Genera il codice per segnali classici (senza parametri)  
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`())

# Versione intelligente con argomento aggiuntivo
macro connect*[T](widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: T) =
  let signalParameterTypes = getSignalParameterTypes()
  let signalStr = $widgetSignal
  
  # Prova a ottenere il tipo del widget
  let widgetType = widgetCall.getType()
  
  # Controlla se è un segnale speciale
  if signalStr in signalParameterTypes:
    let widgetTypeName = $widgetType
    let paramType = signalParameterTypes[signalStr]  
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`(`functionArg`)))
  else:
    # Genera il codice per segnali classici (senza parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`(`functionArg`))

# Test per vedere cosa stampa
when isMainModule:
  # Uncomment per testare quando hai i tipi SeaQt disponibili:
  # var dial: QDial
  # dial.connect(onValueChanged, handleDialValue)
  echo "Macro compilata - testa con widget reali!"
