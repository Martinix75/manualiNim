import seaqt/[qapplication, qdialog, qdial, qspinbox, qboxlayout, qpushbutton]
import std/[strformat]
import qtsignal

# Funzioni di test
proc dialChanged() {.raises: [].}
proc spinChanged() {.raises:[].}
proc buttonClicked() {.raises: [].}

discard QApplication.create()
let dwin = QDialog.create()
let layc = QVBoxLayout.create()

let dial = QDial.create()
dial.setRange(0, 100)

let spin = QSpinBox.create()
spin.setRange(0, 100)

let btn = QPushButton.create(fmt"Valore = {dial.value()}")

# Con parametro - valueChanged passa un cint
dial.connect(onValueChanged, dialChanged, cint)
spin.connect(onValueChanged, spinChanged, cint)
# Senza parametro - clicked non passa nulla
btn.connect(onClicked, buttonClicked)

layc.addWidget(dial)
layc.addWidget(spin)
layc.addWidget(btn)
dwin.setLayout(layc)
dwin.resize(300, 200)
dwin.show()
quit QApplication.exec().int

# Implementazioni
proc dialChanged() =
    spin.setValue(dial.value())
    btn.setText(fmt("Valore = {dial.value()}"))
    #echo "Dial -> Spin: ", dial.value()

proc buttonClicked() =
    dial.setValue(dial.value()+1)
    btn.setText(fmt("Valore = {dial.value()}"))
    spin.setValue(spin.value()+1)
    #echo "Reset!"

proc spinChanged() =
    dial.setValue(spin.value())
    btn.setText(fmt("Valore = {dial.value()}"))
