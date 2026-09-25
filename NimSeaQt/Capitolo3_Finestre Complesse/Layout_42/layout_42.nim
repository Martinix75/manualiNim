#esempio di layout con i le Pile (stakc)
#import std/strformat
import seaqt/[qapplication, qmainwindow, qlineedit, qwidget, qlabel, qgridlayout, qboxlayout, qstackedwidget, qcombobox]
import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qwi_1, qwi_2, qwi_3: QWidget
    lab_1, lab_2, lab_3, lab_4, lab_5:QLabel
    comb_1, comb_2, comb_3, comb_4, comb_5: QComboBox
    stack_1: QStackedwidget
    hlay_1: QHBoxLayout
    vlay_1: QVBoxLayout
    glay_1, glay_2: QGridLayout

proc cambioScheda(c: Form) {.raises: [].}
    
proc finestra() =
  discard QApplication.create()
  let 
    form = Form()
  form.mwin = QMainWindow.create()
  form.qwi_1 = QWidget.create()
  form.hlay_1 = QHBoxLayout.create()
  form.glay_1 = QGridLayout.create()
  form.glay_2 = QGridLayout.create()
  form.vlay_1 = QVBoxLayout.create()
  form.lab_1 = QLabel.create("Tipo")
  form.lab_2 = QLabel.create("Colore Inchiostro")
  form.lab_3 = QLabel.create("Tratto")
  form.lab_4 = QLabel.create("Durezza")
  form.lab_5 = QLabel.create("Colore Mina")
  form.comb_1 = QComboBox.create()
  form.comb_1.addItem("Penna")
  form.comb_1.addItem("Matita")
  form.comb_2 = QComboBox.create()
  form.comb_2.addItems(["Blu", "Nero", "Rosso", "verde"])
  form.comb_3 = QComboBox.create()
  form.comb_3.addItems(["Fine", "Medio", "Grosso"])
  form.comb_4 = QComboBox.create()
  form.comb_4.addItems(["F", "HB", "B"])
  form.comb_5 = QComboBox.create()
  form.comb_5.addItems(["Arancio", "Blu", "Verde", "Giallo", "Rosso", "Magenta"])
  
  form.stack_1 = QStackedwidget.create() #qui creo la pial di WEidgets (uno solo ne basta!!)
  form.qwi_2 = QWidget.create() #dentro vi va un widget personalizzato da polplare.
  form.glay_1.addWidget(form.lab_2, 0, 0) #aggiungo dei widgett lel layout selezionato...
  form.glay_1.addWidget(form.comb_2, 0 ,1) #.....
  form.glay_1.addWidget(form.lab_3, 1, 0) #....
  form.glay_1.addWidget(form.comb_3, 1, 1) #.....
  form.qwi_2.setLayout(form.glay_1) #ora agiungo il layout al mo widget personalizzato...
  discard form.stack_1.addWidget(form.qwi_2) #ora agingo il mio widget personale nello stack (pila).
  
  form.qwi_3 = QWidget.create() #qui creo un nuovo widget persolalizzato da popolare...
  form.glay_2.addWidget(form.lab_4, 0, 0) #aggiungo i widget in un nuovo layaut (non quello di porima!!)
  form.glay_2.addWidget(form.comb_4, 0, 1)
  form.glay_2.addWidget(form.lab_5, 1, 0)
  form.glay_2.addWidget(form.comb_5, 1 ,1)
  form.qwi_3.setLayout(form.glay_2) #aggiungo il layout al mio widget personalizzato...
  discard form.stack_1.addWidget(form.qwi_3) #qui aggiungo il mio widget personalizzatto all interno DELLO STESSIO stack di prima.
  
  form.hlay_1.addWidget(form.lab_1)
  form.hlay_1.addWidget(form.comb_1)
  #form.hlay_1.addWidget(form.stack_1)
  form.vlay_1.addLayout(form.hlay_1)
  form.vlay_1.addWidget(form.stack_1)
  form.qwi_1.setLayout(form.vlay_1)
  
  connect(form.comb_1, onCurrentIndexChanged , cambioScheda, form)
  
  form.mwin.setCentralWidget(form.qwi_1)
  form.mwin.setWindowTitle("Layout Stack")
  form.mwin.resize(300, 250)
  form.mwin.show()
  quit QApplication.exec().int


finestra()


proc cambioScheda(c: Form) = #va crata una procedura per selezionare quale voce dello stack far vedere sll'utete.
  echo("£----> Cambio....")
  if c.stack_1.currentIndex == 0: #controlla che indica ha ora la combo, se = 0...
    c.stack_1.setCurrentIndex(1) #allora fa vedere il psecondo (1) elementeo dello stack (i widget contentuti).
  else: #se invece e 1 (in questo caso)...
    c.stack_1.setCurrentIndex(0) #fa vedere il rpimo elemento dello stack (0).
