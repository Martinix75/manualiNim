#[
Smart connect macro che deduce automaticamente il tipo del widget
by MArtinix75 2025
version 0.4.3
]#
import std/[macros, tables, strutils]

proc ecexioniXX(widgetTypeName: string): bool =
  let ecezioniX = ("Slider")
  if widgetTypeName in ecezioniX:
    result = true
  else:
    result = false

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
  var c: string
  echo(b)
  if  b[5].startsWith("\"QAbstract"):
     c = b[5][10..^3] #ricava il wiget senza a "Q".
  else:
    c = b[5]
  let widgetTypeName = c  # Questo potrebbe non funzionare direttamente
  echo("C è-->", c)
  
  # Controlla se è un segnale speciale
  if signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == false:
    # Prova a estrarre il nome del tipo
    #let widgetTypeName = c  # Questo potrebbe non funzionare direttamente
    echo "Debug - Widget type name: ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    echo "Debug - Generated slot type: ", $slotType
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`()))
      
  elif signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == true:
    # Prova a estrarre il nome del tipo
    #let widgetTypeName = c  # Questo potrebbe non funzionare direttamente
    echo "Debug - Widget type name: ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    echo "Debug - Generated slot type: ", $slotType
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`((proc(qtArg: `paramType`) {.closure.} = `callFunction`()))
    
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
