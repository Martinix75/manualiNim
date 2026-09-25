#esempio di layout con i Tabs.
#import std/strformat
import seaqt/[qapplication, qmainwindow, qlineedit, qwidget, qlabel, qtabwidget, qgridlayout, qboxlayout]
#import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    edit_1, edit_2, edit_3,edit_4: QLineEdit
    lab_1, lab_2, lab_3, lab_4, lab_tab_1, lab_tab_2, lab_tab_3: QLabel
    tab_1, tab_2, tab_3: QTabWidget #dichiarazione oggetto TABS.
    qw_1, qw_2, qw_3, qw_4: QWidget
    vlay_1: QVBoxLayout
    hlay_1, hlay_2, hlay_3: QHBoxLayout

proc finestra() =
  discard QApplication.create()
  let 
    form = Form()
    lay_1 = QGridLayout.create()
  
  form.qw_1 = QWidget.create()
  form.mwin = QMainWindow.create()
  form.edit_1 = QLineEdit.create()
  form.edit_2 = QLineEdit.create()
  form.edit_3 = QLineEdit.create()
  form.edit_4 = QLineEdit.create()
  form.lab_1 = QLabel.create("Opzione 1")
  form.lab_2 = QLabel.create("Opzione 2")
  form.lab_3 = QLabel.create("Opzione 3")
  form.lab_4 = QLabel.create("Opzione 4")
  form.vlay_1 = QVBoxLayout.create() #creo il  layout base  dove metto i widget sempre visibili (1) e il widget TABS(2).
  
  form.qw_2 = QWidget.create() #devo creara un widget da inserire dentro per ogni Tab
  form.tab_1 = QTabWidget.create() #qui creo il TAB vero e proprio il primo....
  form.hlay_1 = QHBoxLayout.create()
  form.lab_tab_1 = QLabel.create("Sei Nel Primo Tab")
  form.hlay_1. addWidget(form.lab_tab_1)
  form.qw_2.setLayout(form.hlay_1)
  discard form.tab_1.addTab(form.qw_2, "TAB 1") #aggiungo il TAB al widget personalizzato 1...
  
  form.qw_3 = QWidget.create() #devo creara un widget da inserire dentro per ogni Tab
  form.tab_2 = QTabWidget.create() #qui creo il TAB vero e proprio il secondo....
  form.hlay_2 = QHBoxLayout.create()
  form.lab_tab_2 = QLabel.create("Sei Nel Secondo Tab")
  form.hlay_2. addWidget(form.lab_tab_2)
  form.qw_3.setLayout(form.hlay_2)
  discard form.tab_1.addTab(form.qw_3, "TAB 2") #aggiungo il TAB al widget personalizzato 2...
  
  
  form.qw_4 = QWidget.create() #devo creara un widget da inserire dentro per ogni Tab
  form.tab_3 = QTabWidget.create() #qui creo il TAB vero e proprio il terzo ....
  discard form.tab_1.addTab(form.qw_4, "TAB 3") #aggiungo il TAB al widget personalizzato 3...
  form.hlay_3 = QHBoxLayout.create()
  form.lab_tab_3 = QLabel.create("Sei Nel Terzo Tab")
  form.hlay_3. addWidget(form.lab_tab_3)
  form.qw_4.setLayout(form.hlay_3)
  
  
  lay_1.addWidget(form.lab_1, 0, 0)
  lay_1.addWidget(form.lab_2, 0, 2)
  lay_1.addWidget(form.lab_3, 1, 0)
  lay_1.addWidget(form.lab_4, 1, 2)
  lay_1.addWidget(form.edit_1, 0, 1)
  lay_1.addWidget(form.edit_2, 0, 3)
  lay_1.addWidget(form.edit_3, 1, 1)
  lay_1.addWidget(form.edit_4, 1, 3)
  #lay_1.addWidget(form.tab_1, 2, 0)
  
  form.vlay_1.addLayout(lay_1)
  form.vlay_1.addWidget(form.tab_1)
  form.qw_1.setLayout(form.vlay_1)
  
  #form.mwin.setWindowTitle("Finestra TAB")
  form.mwin.setCentralWidget(form.qw_1)
  form.mwin.resize(400, 300)
  form.mwin.show()
  quit QApplication.exec().int


finestra()
