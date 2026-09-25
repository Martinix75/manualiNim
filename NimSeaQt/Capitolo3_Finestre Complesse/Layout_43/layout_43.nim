import seaqt/[qapplication, qmainwindow, qwidget, qpushbutton, qlineedit, qcombobox, qframe, qgridlayout, qboxlayout, qlabel]
import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qwi_1: QWidget
    lab_1, lab_2, lab_3, lab_4, lab_5: QLabel
    qbx_1, qbx_2, qbx_3, qbx_4, qbx_5: QComboBox
    bot_1: QPushButton
    frm_1: QFrame
    altezzaFinestra: int32    # ← aggiunto
    
proc opzioni(c: Form) {.raises: [].}

proc finestra() =
  discard QApplication.create()
  let form = Form()
  form.mwin = QMainWindow.create()
  form.qwi_1 = QWidget.create()
  form.lab_1 = QLabel.create("Porta Seriale")
  form.lab_2 = QLabel.create("Baud")
  form.lab_3 = QLabel.create("Parità")
  form.lab_4 = QLabel.create("Bit Stop")
  form.lab_5 = QLabel.create("Flow Control")
  form.qbx_1 = QComboBox.create()
  form.qbx_1.addItems(["ACM0", "tty0", "tty1", "tty2", "COM1"])
  form.qbx_2 = QComboBox.create()
  form.qbx_2.addItems(["9600", "19200", "38400", "115200"])
  form.qbx_3 = QComboBox.create()
  form.qbx_3.addItems(["None", "Pari", "Dispari"])
  form.qbx_4 = QComboBox.create()
  form.qbx_4.addItems(["1", "2"])
  form.qbx_5 = QComboBox.create()
  form.qbx_5.addItems(["None", "Hardware", "Software"])
  form.bot_1 = QPushButton.create("Più Opzioni")
  
  let gridl_1 = QGridLayout.create()
  gridl_1.addWidget(form.lab_1, 0, 0)
  gridl_1.addWidget(form.qbx_1, 0 ,1)
  gridl_1.addWidget(form.lab_2, 1, 0)
  gridl_1.addWidget(form.qbx_2, 1 ,1)
  gridl_1.addWidget(form.bot_1, 2, 0)
  
  form.frm_1 = QFrame.create() #creo il frame che poi si nasconde viualizza x piu opzioni.
  form.frm_1.setFrameStyle(2) #metto cuan cornice.
  form.frm_1.setVisible(false) #rendo il frame invisibile di default.
  let grid_2 = QGridLayout.create() #creo la tabella che poi va dentro al Frame.
  grid_2.addWidget(form.lab_3, 0, 0) #classica aggiunta di widgets...
  grid_2.addWidget(form.qbx_3, 0, 1)
  grid_2.addWidget(form.lab_4, 1, 0)
  grid_2.addWidget(form.qbx_4, 1, 1)
  grid_2.addWidget(form.lab_5, 2, 0)
  grid_2.addWidget(form.qbx_5, 2, 1)
  form.frm_1.setLayout(grid_2) #ora inserisco la tabella nel frame!!!
  
  let vgri_1 = QVBoxLayout.create() #tabella principale che va sul widget centarale.
  vgri_1.addLayout(gridl_1) #aggiungo la tabella con i widget sempre visibili.
  vgri_1.addStretch() #aaggiungo un compressore di widget.
  vgri_1.addWidget(form.frm_1) #aggiungo in tabella il Frame (nascosto x ora)
  #vgri_1.setSizeConstraint(2) #teas per ridimensionamenti automatico ma non funge!!!
  
  connect(form.bot_1, onClicked, opzioni, form) #se premo abilito o disabilito i widget opzionali.
  
  form.qwi_1.setLayout(vgri_1)
  form.mwin.setCentralWidget(form.qwi_1)
  form.mwin.setWindowTitle("Più Opzioni")
  form.mwin.resize(300, 100)
  form.mwin.show()
  form.altezzaFinestra = form.mwin.height()   # ← altezza reale calcolata da Qt
  quit QApplication.exec().int

finestra()


proc opzioni(c: Form) =
  if c.frm_1.isVisible:
    c.frm_1.setVisible(false) #fa sparire i widget opzionali
    c.mwin.setFixedSize(300, c.altezzaFinestra)   # ← usa l'altezza reale, non 100
  else:
    c.mwin.setMinimumSize(0, 0)
    c.mwin.setMaximumSize(16777215, 16777215)
    c.frm_1.setVisible(true) #fa apparire i widget opzionali
    c.mwin.adjustSize()
    c.mwin.resize(300, c.mwin.height())
