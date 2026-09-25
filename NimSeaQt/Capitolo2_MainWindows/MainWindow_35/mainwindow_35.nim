#import std/[strformat, options]
import seaqt/[qapplication, qmainwindow,  qwidget, qicon, qlabel, qboxlayout, qfiledialog, qstatusbar]
import seaqt/[qaction, qtoolbar, qmenu, qmenubar, qkeysequence, qmessagebox, qfiledialog, qpixmap]
import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qwi_1: QWidget 
    #but_1: QPushButton
    lab_1, lab_2: QLabel
    #lie_1: QLineEdit
    lay_1: QVBoxLayout
    fil_1 : QFileDialog
    sba_1 : QStatusBar
    menu_x: QMenuBar
    menu_f, menu_c, menu_a, sottoMenu: QMenu #non strettamente necessario qui
    bar_x: QToolBar
    #mem: int = 0

  Voci = object
    act: QAction 
    str: string = ""
    
proc creaAzione(nome: string;  icona=""; tip=""; short=""): QAction
proc creaMenu[T: QMenu|QToolBar](a: T, b: openarray[Voci])
#proc test() {.raises: [].}
proc info(c: Form) {.raises: [].}
proc config(c: Form) {.raises: [].}
proc openFile(c: Form) {.raises: [].}

proc finestra() =
  discard QApplication.create()
  let form = Form()
  form.mwin = QMainwindow.create()
  
  form.mwin.setWindowTitle("Main Window")
  form.mwin.setWindowIcon(QIcon.create("resources/panoratux.png"))
  form.mwin.resize(400, 300)
  
  form.qwi_1 = QWidget.create()
  form.lab_1 = QLabel.create()
  form.lab_1.setMinimumSize(200, 200) #setta minima sezione
  let pix = QPixmap.create("resources/panoratux.png")
  form.lab_1.setPixmap(pix.scaled(200, 200, 1))
  
  form.lay_1 = QVBoxLayout.create()
  form.lay_1.addWidget(form.lab_1)
  form.qwi_1.setLayout(form.lay_1)
  
  form.lab_2 = QLabel.create()
  form.sba_1 = QStatusBar.create(form.mwin)
  form.mwin.setStatusBar(form.sba_1) #fonsamentale x averla in basso!!
  #form.sba_1.setSizeGripEnabled(true)
  form.sba_1.addPermanentWidget(form.lab_2)
  form.sba_1.showMessage("Pronto..", 5000)
  
  let azione1 = creaAzione("Apri","resources/apri.png", "Apri un file","ctrl+a")
  let azione2 = creaAzione("Chiudi", "resources/chiudi.png", "Chiudi", "ctrl+q")
  let azione3 = creaAzione("imposta Qualcosa..", "resources/set.png", "Imposta qualcosa di bho..", "ctrl+s")
  let azione4 = creaAzione("Aiuto", "resources/help.png", "Info QT", "ctrl+h")
  let azione5 = creaAzione("Sotto Menù..")
  
  let toolBar = form.mwin.addToolBar("")
  creaMenu(toolBar, [Voci(act: azione1), Voci(act: azione2), Voci(str: "sep")])
  creaMenu(toolBar, [Voci(act: azione3), Voci(act: azione5), Voci(str: "sep"),Voci(act: azione4)])
  
  form.menu_x = form.mwin.menuBar() #aggiungo la barra dei menu
  form.menu_f = QMenu.create("File") #creo il menu vero e proprio da inserire nella barra.
  form.menu_c = QMenu.create("Configura") #creo il menu vero e proprio da inserire nella barra.
  form.sottoMenu =  QMenu.create("Colore")
  form.menu_a = QMenu.create("Aiuto") #creo il menu vero e proprio da inserire nella barra.
  
  discard form.menu_x.addMenu(form.menu_f) #inserisco il menu_f nella barra dei menu.
  creaMenu(form.menu_f, [Voci(act: azione1), Voci(str: "sep"), Voci(act: azione2)])
  
  
  discard form.menu_x.addMenu(form.menu_c) #inserisco il menu_f nella barra dei menu.
  creaMenu(form.menu_c, [Voci(act: azione3)])
  discard form.menu_c.addMenu(form.sottoMenu)
  creaMenu(form.sottoMenu, [Voci(act: azione5)])
  
  discard form.menu_x.addMenu(form.menu_a) #inserisco il menu_f nella barra dei menu.
  creaMenu(form.menu_a, [Voci(act: azione4)])
  
  connect(azione1, onTriggered, openFile, form)
  connect(azione2, onTriggered, quit)
  connect(azione4, onTriggered, info, form)
  connect(azione5, onTriggered, config, form)
  
  form.mwin.setCentralWidget(form.qwi_1)
  form.mwin.show()
  quit QApplication.exec().int


finestra()

proc creaAzione(nome: string;  icona=""; tip=""; short=""): QAction =
  echo("Creo azione..")
  let azione = QAction.create(nome)
  if icona != "": 
    azione.setIcon(QIcon.create(icona))
  if tip != "":
    azione.setToolTip(tip) # tooltip = testo di aiuto quando vai sopra un widget
    azione.setStatusTip(tip) #mostra un testo nella barra di stato.
  if short != "":
    azione.setShortcut(QKeysequence.create(short)) #scorciatoia da tastiera
  result = azione
  
proc creaMenu[T: QMenu|QToolBar](a: T, b: openarray[Voci]) =
  echo("Menu...")
  for x in b:
    if x.str == "":
      a.addAction(x.act)
    else:
      discard a.addSeparator()

proc info(c: Form) =
  QMessageBox.aboutQt(c.mwin, "")

proc config(c: Form) =
  let testo = "Programma Demo!"
  discard QMessageBox.information(c.mwin, "Configurazioni", testo ,0x40)
  
proc openFile(c: Form) =
  echo("invocatomi.....")
  let filex = QFileDialog.getOpenFileName(c.mwin, "Selezione un File", "", "Immagini(*.png)")
  echo("Percorso --> ", filex)
  let pix = QPixmap.create(filex)
  c.lab_1.setPixmap(pix.scaled(200, 200 ,1))
  

#setshortcut invece imposta la scorciatoia da tastiera
