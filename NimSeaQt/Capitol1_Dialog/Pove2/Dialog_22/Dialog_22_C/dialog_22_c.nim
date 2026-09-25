import seaqt/[qapplication, qdialog, qpushbutton, qlabel, qgridlayout]

discard QApplication.create()

let
  dwin = QDialog.create()
  bot_1 = QPushButton.create("Si")
  bot_2 = QPushButton.create("No")
  bot_3 = QPushButton.create("Forse")
  lab_1 = QLabel.create("Label 1")
  lab_2 = QLabel.create("Label 2")
  lab_3 = QLabel.create("Label 3")
  lay_c = QGridLayout.create()

lay_c.addwidget(lab_1, 0, 0)
lay_c.addWidget(bot_1, 0, 1)
lay_c.addwidget(lab_2, 0, 2)
lay_c.addWidget(bot_2, 0, 3)
lay_c.addwidget(lab_3, 1, 2)
lay_c.addWidget(bot_3, 1, 3)

dwin.setLayout(lay_c)

dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int
