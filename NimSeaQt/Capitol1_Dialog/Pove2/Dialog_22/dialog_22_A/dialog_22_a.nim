import seaqt/[qapplication, qdialog, qboxlayout, qpushbutton]

discard QApplication.create()

let
  dwin = QDialog.create()
  bot_1 = QPushButton.create("Si")
  bot_2 = QPushButton.create("No")
  bot_3 = QPushButton.create("Forse")
  lay_c = QVBoxLayout.create()

lay_c.addWidget(bot_1)
lay_c.addWidget(bot_2)
lay_c.addWidget(bot_3)
dwin.setLayout(lay_c)
dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int
