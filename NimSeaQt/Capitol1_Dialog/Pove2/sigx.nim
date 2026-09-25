## Demo of the enhanced connect macro for SeaQt
##
## This example shows how to use the new connect() macro to create
## signal-slot connections with clean, Qt-like syntax.

import seaqt/[qapplication, qdialog, qdial, qspinbox, qboxlayout, qpushbutton, qlabel, qicon]
#import seaqt/core/signals  # Import the connect macro
import qtconnect6_1
#import qtsignal

type
  Qt_Aligmnent = enum
    AlignHCenter = 0x4

proc qFlag(a: Qt_Aligmnent): cint {.inline.}=
  result = ord(a).cint

# Forward declarations - can be anywhere in the file
proc onDialChanged() {.raises: [].}
proc onSpinChanged() {.raises: [].}
proc onResetClicked() {.raises: [].}
proc onDoubleClicked() {.raises: [].}

# Global widgets for easy access in slot functions
var dial: QDial
var spin: QSpinBox
var label: QLabel
var resetBtn: QPushButton

proc main() =
  discard QApplication.create()

  # Create main window
  let window = QDialog.create()
  window.setWindowTitle("Connect Macro Demo")
  window.setWindowIcon(QIcon.create("panoratux.png"))

  let layout = QVBoxLayout.create()

  # Create widgets
  label = QLabel.create("Value: 0")
  label.setAlignment(qFlag(Qt_Aligmnent.AlignHCenter))
  label.setStyleSheet("font-size: 14px; font-weight: bold; background: red; color: rgb(128, 255, 0)")
  label.setFixedHeight(20)

  dial = QDial.create()
  dial.setStyleSheet("background: rgb(200, 255, 0); color: rgb(250,0,1)")
  dial.setRange(0, 100)
  dial.setValue(0)

  spin = QSpinBox.create()
  spin.setAlignment(qFlag(Qt_Aligmnent.AlignHCenter)) #cerca qui i numeri newQFlags(Qt_AlignmentFlag.AlignHCenter)
  spin.setStyleSheet("background: rgb(111, 0, 255); color: black")
  spin.setRange(0, 100)
  spin.setValue(0)

  resetBtn = QPushButton.create("Reset to 50")
  resetBtn.setStyleSheet("background: rgb(195, 0, 255); color: black")

  let doubleBtn = QPushButton.create("Double Current Value")
  doubleBtn.setStyleSheet("background: rgb(0, 255, 242); color: black")

  # Signal connections using the enhanced connect macro

  # Signals with parameters - notice the clean syntax!
  connect(dial, onValueChanged, onDialChanged)
  connect(spin, onValueChanged, onSpinChanged)
  echo("Tipo: ", type(dial))

  # Signals without parameters - even cleaner!
  connect(resetBtn, onClicked, onResetClicked)
  connect(doubleBtn, onClicked, onDoubleClicked)

  # Layout
  layout.addWidget(label)
  layout.addWidget(dial)
  layout.addWidget(spin)
  layout.addWidget(resetBtn)
  layout.addWidget(doubleBtn)

  window.setLayout(layout)
  window.resize(300, 250)
  window.show()

  quit QApplication.exec().int

# Slot implementations - can be defined after usage thanks to forward declarations
proc onDialChanged() =
  let value = dial.value()
  spin.setValue(value)
  label.setText("Value: " & $value & " (from dial)")

proc onSpinChanged() =
  let value = spin.value()
  dial.setValue(value)
  label.setText("Value: " & $value & " (from spinbox)")

proc onResetClicked() =
  dial.setValue(50)
  spin.setValue(50)
  label.setText("Value: 50 (reset)")

proc onDoubleClicked() =
  let currentValue = dial.value()
  let newValue = min(currentValue * 2, 100)  # Cap at maximum
  dial.setValue(newValue)
  spin.setValue(newValue)
  label.setText("Value: " & $newValue & " (doubled)")

when isMainModule:
  main()
