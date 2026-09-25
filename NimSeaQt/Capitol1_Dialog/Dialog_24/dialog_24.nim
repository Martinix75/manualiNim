import seaqt/[qapplication, qdialog, qpushbutton, qlabel, qboxlayout]
import qtconnect6_1

proc cambiaTesto(tasto: string) {.raises: [].}

discard QApplication.create()
let dwin = QDialog.create()
let lay_1 = QHBoxLayout.create()

let bot_1 = QPushButton.create("Bottone 1")
let bot_2 = QPushButton.create("Bottone 2")
let bot_3 = QPushButton.create("Bottone 3")
let lab_1 = QLabel.create("Pronto")
lab_1.setAlignment(4)
lab_1.setStyleSheet("font-size: 14px; font-weight: bold")

lay_1.addWidget(bot_1)
lay_1.addWidget(bot_2)
lay_1.addWidget(bot_3)
lay_1.addWidget(lab_1)

connect(bot_1, onClicked, cambiaTesto, "Bottone 1")
connect(bot_2, onClicked, cambiaTesto, "Bottone 2")
connect(bot_3, onClicked, cambiaTesto, "Bottone 3")

dwin.setLayout(lay_1)
dwin.resize(400,100)  
dwin.show()
quit QApplication.exec().int

proc cambiaTesto(tasto: string) =
  lab_1.setText(tasto)
