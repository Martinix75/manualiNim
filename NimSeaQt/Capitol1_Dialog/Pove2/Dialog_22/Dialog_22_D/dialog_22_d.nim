import seaqt/[qapplication, qdialog, qpushbutton, qlabel, qgridlayout, qcombobox]

discard QApplication.create()

let
  dwin = QDialog.create()
  bot_1 = QPushButton.create("Si")
  bot_2 = QPushButton.create("No")
  bot_3 = QPushButton.create("Forse")
  com_1 = QComboBox.create()
  lay_c = QGridLayout.create()

com_1.addItem("Qt5")
com_1.addItem("Qt6")
com_1.addItem("Nim")

lay_c.addWidget(bot_1, 1 ,0)
lay_c.addWidget(bot_2, 1 ,1)
lay_c.addWidget(bot_3, 1 ,2)
lay_c.addWidget(com_1, 0, 0, 1 ,3)
dwin.setLayout(lay_c)

dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int
