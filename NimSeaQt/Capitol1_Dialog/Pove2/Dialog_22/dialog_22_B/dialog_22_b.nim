import seaqt/[qapplication, qdialog, qboxlayout, qpushbutton, qlabel]

discard QApplication.create()

let
  dwin = QDialog.create()
  bot_1 = QPushButton.create("Si")
  bot_2 = QPushButton.create("No")
  bot_3 = QPushButton.create("Forse")
  lab_1 = QLabel.create("Label 1")
  lab_2 = QLabel.create("Label 2")
  lab_3 = QLabel.create("Label 3")
  lay_c = QVBoxLayout.create()
  lay_1 = QHBoxLayout.create()
  lay_2 = QHBoxLayout.create()
  lay_3 = QHBoxLayout.create()

lay_1.addWidget(lab_1)
lay_1.addWidget(bot_1)
lay_2.addWidget(lab_2)
lay_2.addWidget(bot_2)
lay_3.addWidget(lab_3)
lay_3.addWidget(bot_3)

lay_c.addLayout(lay_1)
lay_c.addLayout(lay_2)
lay_c.addLayout(lay_3)
dwin.setLayout(lay_c)

dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int
