import std/strformat
import seaqt/[qapplication, qmainwindow, qpushbutton, qlineedit, qwidget, qboxlayout, qicon, qaction, qtoolbar, qmessagebox]
import qtconnect

type
  Form = ref object
    #qapp: QApplication
    mwin: QMainWindow
    qwi_1: QWidget #al centro ci deve stare un vidget non un layer
    but_1: QPushButton
    lie_1: QLineEdit
    lay_1: QVBoxLayout
    bar_x: QToolBar
    #menu_a, menu_c, menu_f, sottoMenu: QMenu #non strettamente necessario qui
    azione1, azione2, azione3: QAction #
    azione4, azione5: Qaction
    mem: int = 0

proc cambia(c: Form) {.raises: [].}
proc azione(c: Form; ex: string) {.raises: [].}
proc info(c: Form) {.raises:[].}
proc config(c: Form) {.raises:[].}

proc finestra() =
  discard QApplication.create()
  let form = Form()
  #form.qapp = QApplication.create()
  form.mwin = QMainWindow.create()
  
  form.but_1 = QPushButton.create("Premi Qui")
  form.but_1.setIcon(QIcon.create("resources/ledrosso.png"))
  form.lie_1 = QLineEdit.create("Prima App MainWindow")
  form.lie_1.setAlignment(0x4)
  form.lay_1 = QVBoxLayout.create()
  form.qwi_1 = QWidget.create()
  form.bar_x = QToolBar.create() #crea la barrastrumenti VUOTA!!
  
  form.lay_1.addWidget(form.lie_1)
  form.lay_1.addWidget(form.but_1)
  form.qwi_1.setLayout(form.lay_1)
  
  connect(form.but_1, onClicked, cambia, form)
  
  form.azione1 = QAction.create("Apri")
  form.azione2 = QAction.create("Chiudi")
  form.azione3 = QAction.create("Imposta Qualcosa..")
  form.azione4 = QAction.create("Aiuto")
  form.azione5 = QAction.create("Sotto Menu..")
  form.azione1.setIcon(QIcon.create("resources/apri.png"))
  form.azione1.setObjectName("AzioneApri")

  form.azione2.setIcon(QIcon.create("resources/chiudi.png"))
  form.azione3.setIcon(QIcon.create("resources/set.png"))
  form.azione4.setIcon(QIcon.create("resources/help.png"))
  form.azione5.setIcon(QIcon.create("resources/connetti.png"))

  let toolBar = form.mwin.addToolBar("x")
  toolBar.addAction(form.azione1)
  toolBar.addAction(form.azione2)
  discard toolBar.addSeparator()
  toolBar.addAction(form.azione5)
  discard toolBar.addSeparator()
  toolBar.addAction(form.azione4)
  
  connect(form.azione1, onTriggered, azione, form, "Apertura File")
  connect(form.azione2, onTriggered, quit)
  connect(form.azione3, onTriggered, azione, form, "Imposta Qualcosa..")
  connect(form.azione4, onTriggered, info, form)
  connect(form.azione5, onTriggered, config, form)
  
  form.mwin.setCentralWidget(form.qwi_1) #setto il widget centrale con il Qwidget personale.
  form.mwin.setWindowTitle("MainWindow Menu & Chiamate")
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


proc azione(c: Form; ex: string) =
  echo("Prova triggered")
  c.lie_1.setText(fmt"Hai Clicckato su {ex}")

proc info(c: Form) =
  echo("info")
  QMessageBox.aboutQt(c.mwin, "")# !! ATTENZIONE!! c.win va dentro le parentesi come parent per sentrare la finestra e NON prima di QMessagebox!!!

proc config(c: Form) =
  echo("configurazione..")
  let testo = "Seriale Non Trovata\nConnetti un dispositivo."
  discard QMessageBox.information(c.mwin, "Info Seriale", testo, 0x40)
