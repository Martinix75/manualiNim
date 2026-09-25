import std/strformat
import seaqt/[qapplication, qmainwindow, qpushbutton, qlineedit, qwidget, qboxlayout, qicon]
import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qwi_1: QWidget #al centro ci deve stare un vidget non un layer
    but_1: QPushButton
    lie_1: QLineEdit
    lay_1: QVBoxLayout
    mem: int = 0

proc cambia(c: Form) {.raises: [].}

proc finestra() =
  discard QApplication.create()
  let form = Form()
  form.mwin = QMainWindow.create()
  
  form.but_1 = QPushButton.create("Premi Qui")
  form.but_1.setIcon(QIcon.create("resources/ledrosso.png"))
  form.lie_1 = QLineEdit.create("Prima App MainWindow")
  form.lie_1.setAlignment(0x4)
  form.lay_1 = QVBoxLayout.create()
  form.qwi_1 = QWidget.create()
  
  form.lay_1.addWidget(form.lie_1)
  form.lay_1.addWidget(form.but_1)
  form.qwi_1.setLayout(form.lay_1)
  
  connect(form.but_1, onClicked, cambia, form)
  
  form.mwin.setCentralWidget(form.qwi_1)
  form.mwin.setWindowTitle("Main Window")
  form.mwin.setWindowIcon(QIcon.create("resources/panoratux.png"))
  form.mwin.resize(400, 300)
  form.mwin.show()
  quit QApplication.exec().int


finestra()

proc cambia(c: Form) =
  echo("Cambio")
  c.mem.inc()
  c.lie_1.setText(fmt "Premuto Pulsante: {c.mem} volte")
  c.but_1.setIcon(QIcon.create("resources/ledverde.png"))
  
