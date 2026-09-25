import seaqt/[qapplication, qdialog, qdial, qspinbox, qboxlayout]


discard QApplication.create()

let  dwin = QDialog.create()
let  dia_1 = QDial.create()
dia_1.setRange(0, 100)
dia_1.setValue(0)

let spi_1 = QSpinBox.create()
spi_1.setRange(0,100)
spi_1.setValue(0)

let lay_1 = QVBoxLayout.create()
lay_1.addWidget(dia_1)
lay_1.addWidget(spi_1)

dia_1.onValueChanged(
  proc(arg: cint) =
    spi_1.setValue(dia_1.value()))

spi_1.onValueChanged(
  proc(arg: cint) =
    dia_1.setValue(spi_1.value()))

dwin.setLayout(lay_1)
dwin.resize(300,150)
dwin.show()
quit QApplication.exec().int
