#esempio di layout con i Tabs.

import seaqt/[qapplication, qmainwindow, qlineedit, qwidget, qlabel, qtabwidget, qgridlayout, qboxlayout, qradiobutton, qcombobox, qslider]
#import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qw_1, qw_2,qw_3: QWidget
    tab_1: QTabWidget
    lab_1, lab_2, lab_3, lab_4: QLabel
    rad_1,rad_2,rad_3: QRadioButton
    qbx_1: QComboBox
    sld_1: QSlider
    vlay_1, vlay_2, vlay_3: QVBoxLayout
    hlay_1: QHBoxLayout

proc finestra() =
  discard QApplication.create()
  let
    form = Form()
  form.mwin = QMainWindow.create()
  
  form.tab_1 = QTabWidget.create() #creo il tab (unico poi sia ggiunge!!)
  # creazione del tab1 
  
  form.qw_1 = QWidget.create()
  form.lab_1 = QLabel.create("Opzioni Varie di Controllo")
  form.rad_1 = QRadioButton.create("Manuale")
  form.rad_2 = QRadioButton.create("Auto")
  form.rad_3 = QRadioButton.create("Off")
  form.rad_3.setChecked(true)
  form.vlay_1 = QVBoxLayout.create()
  form.vlay_1.addWidget(form.lab_1)
  form.vlay_1.addSpacing(30) #ATTENZIONE la spazio è in pixel!!!!
  form.vlay_1.addWidget(form.rad_1)
  form.vlay_1.addWidget(form.rad_2)
  form.vlay_1.addWidget(form.rad_3)
  form.vlay_1.addStretch(1) #con un strech il numero () non conta ma se ccene sono di piu vienesuddiviso lo strac in base al numero argomento.
  form.qw_1.setLayout(form.vlay_1)
  discard form.tab_1.addTab(form.qw_1,"Tab 1")
  
  # creazione del tab2
  form.qw_2 = QWidget.create()
  form.lab_2 = QLabel.create("Selezione Buad")
  form.lab_3 = QLabel.create("Seleziona i Buud:")
  form.qbx_1 = QComboBox.create()
  form.qbx_1.addItems(["9600", "19200", "38400", "115200"])
  form.hlay_1 = QHBoxLayout.create()
  form.hlay_1.addWidget(form.lab_3)
  form.hlay_1.addWidget(form.qbx_1)
  form.vlay_2 = QVBoxLayout.create()
  form.vlay_2.addWidget(form.lab_2)
  form.vlay_2.addSpacing(30)
  form.vlay_2.addLayout(form.hlay_1)
  form.vlay_2.addStretch(1)
  form.qw_2.setLayout(form.vlay_2)
  discard form.tab_1.addTab(form.qw_2,"Tab 2")
  
  # creazione del tab3
  form.qw_3 = QWidget.create()
  form.lab_4 = QLabel.create("Volume")
  form.sld_1 = QSlider.create()
  form.sld_1.setOrientation(1)
  form.vlay_3 = QVBoxLayout.create()
  form.vlay_3.addWidget(form.lab_4)
  form.vlay_3.addSpacing(30)
  form.vlay_3.addWidget(form.sld_1)
  form.vlay_3.addStretch(1)
  form.qw_3.setLayout(form.vlay_3)
  discard form.tab_1.addTab(form.qw_3,"Tab 3")
  
  
  
  form.mwin.setCentralWidget(form.tab_1)
  form.mwin.setWindowTitle("Tabs")
  form.mwin.resize(300,200)
  form.mwin.show()
  quit QApplication.exec().int

finestra()
    
