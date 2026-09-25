#[
Smart connect macro che deduce automaticamente il tipo del widget
by MArtinix75 2025
version 0.6.0
]#
import std/[macros, tables, strutils ,typeinfo]

# Versione ottimizzata della procedura - più chiara e efficiente
proc ecexioniXX(widgetTypeName: string): bool = 
  # Widget che NON usano il wrapper del tipo slot (es: QSliderValueChangedSlot)
  # ma chiamano direttamente il segnale con la procedura
  const ecezioniX = ["Slider", "Widget", "Button"] # Costante per performance
  result = widgetTypeName in ecezioniX

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

proc extractType(at: auto): string =
  echo "Debug - Widget type raw: ", at.treeRepr
  let typeRepr = $at.treeRepr
  
  # Cerca il pattern "Q..." nel treeRepr invece di assumere posizione fissa
  let parts = typeRepr.split(" ")
  
  for part in parts:
    if part.startsWith("\"Q") and part.endsWith("\""):
      # Trova la parte che contiene il tipo Qt
      let cleanPart = part[1..^2] # Rimuove le virgolette
      
      if cleanPart.startsWith("QAbstract"):
        # Casi come QAbstractButton -> Button
        result = cleanPart[9..^1] # Rimuove "QAbstract"
        echo "Debug - Tipo estratto (QAbstract): ", result
        return
      elif cleanPart.startsWith("Q"):
        # Casi normali come QLineEdit -> LineEdit  
        result = cleanPart[1..^1] # Rimuove solo "Q"
        echo "Debug - Tipo estratto (Q): ", result
        return
  
  # Se non trova niente, fallback al metodo originale
  echo "Warning - Fallback al metodo originale"
  if parts.len > 5:
    if parts[5].startsWith("\"QAbstract"):
      result = parts[5][10..^3]
    else:
      result = parts[5][2..^3]
  else:
    result = "Unknown"
  
# Versione intelligente senza argomenti aggiuntivi  
macro connect*(widgetCall: untyped; widgetSignal: untyped; callFunction: untyped) =
  let signalParameterTypes = getSignalParameterTypes()
  let signalStr = $widgetSignal
  
  # Prova a ottenere il tipo del widget
  let widgetType = widgetCall.getType()
  let widgetTypeName = extractType(widgetType)
  
  # Controlla se è un segnale speciale
  if signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == false:
    # Widget normale - usa il wrapper del tipo slot
    echo "Debug - Widget type name: ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    echo "Debug - Generated slot type: ", $slotType
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`()))
      
  elif signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == true:
    # Widget con eccezione - NON usa il wrapper del tipo slot
    echo "Debug - Widget type name (eccezione): ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    
    echo "Debug - Usando connessione diretta (senza slot type wrapper)"
    
    # Genera il codice per segnali speciali (con parametri) ma senza wrapper
    result = quote do:
      `widgetCall`.`widgetSignal`((proc(qtArg: `paramType`) {.closure.} = `callFunction`()))
    
  else:
    # Genera il codice per segnali classici (senza parametri)  
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`())

#-----------------------------------------------------------------------------------------------------------
# Versione intelligente con argomento aggiuntivo
macro connect*[T](widgetCall: untyped; widgetSignal: untyped; callFunction: untyped; functionArg: T) =
  let signalParameterTypes = getSignalParameterTypes()
  let signalStr = $widgetSignal
  
  # Prova a ottenere il tipo del widget
  let widgetType = widgetCall.getType()
  let widgetTypeName = extractType(widgetType)
  
  # Controlla se è un segnale speciale
  if signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == false:
    # Widget normale - usa il wrapper del tipo slot
    echo "Debug - Widget type name: ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    let slotType = buildSlotName(widgetTypeName, signalStr)
    
    echo "Debug - Generated slot type: ", $slotType
    
    # Genera il codice per segnali speciali (con parametri)
    result = quote do:
      `widgetCall`.`widgetSignal`(`slotType`(proc(qtArg: `paramType`) {.closure.} = `callFunction`(`functionArg`)))
      
  elif signalStr in signalParameterTypes and ecexioniXX(widgetTypeName) == true:
    # Widget con eccezione - NON usa il wrapper del tipo slot
    echo "Debug - Widget type name (eccezione): ", widgetTypeName
    
    let paramType = signalParameterTypes[signalStr]
    
    echo "Debug - Usando connessione diretta (senza slot type wrapper)"
    
    # Genera il codice per segnali speciali (con parametri) ma senza wrapper
    result = quote do:
      `widgetCall`.`widgetSignal`((proc(qtArg: `paramType`) {.closure.} = `callFunction`(`functionArg`)))
    
  else:
    # Genera il codice per segnali classici (senza parametri)  
    result = quote do:
      `widgetCall`.`widgetSignal`(proc() {.closure.} = `callFunction`(`functionArg`))
