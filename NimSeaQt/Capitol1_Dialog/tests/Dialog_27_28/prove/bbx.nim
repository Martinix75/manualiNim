import seaqt/[qapplication, qdialog, qdialogbuttonbox, qboxlayout, qlabel]
import qtconnect

proc test1()

proc main() =
  discard QApplication.create()
  let win = QDialog.create()
  let lab = QLabel.create("Tetx Box")
  let lay = QVBoxLayout.create()
  let bbb = QDialogButtonBox.create()
  
  discard bbb.addButton(0x400)
  discard bbb.addButton(0x400000)
  lay.addWidget(lab)
  lay.addWidget(bbb)
  
  connect(bbb, onAccepted, win.accept)
  
  win.setLayout(lay)
  win.resize(300, 150)
  win.show()
  discard QApplication.exec()

main()

proc test1() =
  echo("OK!!")
