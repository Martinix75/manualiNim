import seaqt/[qapplication, qdialog]

discard QApplication.create()
let
  
  dwin = QDialog.create()
  
dwin.resize(300,150)  
dwin.show()
quit QApplication.exec().int
