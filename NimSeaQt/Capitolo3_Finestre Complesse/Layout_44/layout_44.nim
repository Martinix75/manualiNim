import seaqt/[qapplication, qmainwindow, qwidget, qsplitter, qlistwidget, qtextbrowser, qsettings, qvariant]#, qcloseevent]
import qtconnect

type
  Form = ref object
    mwin: QMainWindow
    qwi_1: QWidget
    split_1, split_2: QSplitter
    lw_1, lw2: QListWidget
    txb_1: QTextBrowser
    

proc dati(c: Form) {.raises: [].}
proc salvaParametri(c: Form) {.raises: [].}
proc leggiParametri(c: Form)


proc finestra() =
  let app =  QApplication.create()
  let form = Form()
  form.mwin = QMainWindow.create()
  form.lw_1 = QListWidget.create()
  form.lw_2 = QListWidget.create()
  form.txb_1 = QTextBrowser.create()
  
  form.split_1 = QSplitter.create(2) #il 2 indic  il verso = Vetricale
  form.split_1.addWidget(form.lw_1)
  form.split_1.addWidget(form.txb_1)
  form.split_2 = QSplitter.create(1) #il 1 indic  il verso = orrizontale (qt.orientation)
  form.split_2.addWidget(form.lw_2)
  form.split_2.addWidget(form.split_1)
  
  form.split_1.setStretchFactor(0, 1)
  form.split_1.setStretchFactor(1, 5)
  form.split_2.setStretchFactor(0, 1)
  form.split_2.setStretchFactor(1, 3)
  
  form.dati()
  
  connect(app, onAboutToQuit, salvaParametri, form) #seganle erditato da QCoreApplication
  
  form.mwin.setCentralWidget(form.split_2)
  form.mwin.setWindowTitle("Splitters")
  form.mwin.resize(600, 600)
  leggiParametri(form)
  form.mwin.show()
  quit QApplication.exec().int
  
finestra()

proc leggiParametri(c: Form) =
  echo " +++++++++++++++ Leggo i parametri +++++++++++++"
  #QCoreApplication.setOrganizationName("NimQt")    # ← deve stare PRIMA di create()
  #QCoreApplication.setApplicationName("Layout44")   # ← idem
  let setting = QSettings.create("./layout_44.conf", QSettingsFormatEnum.IniFormat)
  
  let geom = setting.value("MainWindow/Geometry")   # legge il QVariant
  discard c.mwin.restoreGeometry(geom.toByteArray())        # estrae i bytes e li passa
  let stato = setting.value("MainWindow/Stato")   # legge il QVariant
  discard c.mwin.restoreState(stato.toByteArray()) 
  let sp1 = setting.value("Splitter/MessaggeSplitter")   # legge il QVariant
  discard c.split_1.restoreState(sp1.toByteArray()) 
  let sp2 = setting.value("Splitter/MainSplitter")   # legge il QVariant
  discard c.split_2.restoreState(sp2.toByteArray()) 
  #let stato = setting.value("MainWindow/Stato")
  #discard c.mwin.restoreState(stato.toByteArray())

proc salvaParametri(c: Form) =
  echo(" ------------ Salvo i Parametri ------------------")
  #QCoreApplication.setOrganizationName("NimQt")
  #QCoreApplication.setApplicationName("Layout44")
  let setting = QSettings.create("./layout_44.conf", QSettingsFormatEnum.IniFormat) #crea il file confoig, nella direcory di lavoro
  setting.setValue("MainWindow/Geometry", QVariant.create(c.mwin.saveGeometry())) #salva la geometria dello split in mainwindow (titolo) geometry  (parametro)
  setting.setValue("MainWindow/Stato", QVariant.create(c.mwin.saveState())) #salva lo stato della Mainwindow
  setting.setValue("Splitter/MessaggeSplitter", QVariant.create(c.split_1.saveState())) #salva lo stato della Mainwindow
  setting.setValue("Splitter/MainSplitter", QVariant.create(c.split_2.saveState())) #salva lo stato della Mainwindow
  echo setting.fileName() #scrive in consolle dove salva il file.
  

proc dati(c: Form) =
  echo("Carico Dati")
  for dati1 in ["Linguaggi Programmazione", "Grafica Raster", "Grafica Vettoriale", "EDA", "CAD"]:
    c.lw_1.addItem(dati1)
  for dati2 in ["Nim", "Python", "C", "C++", "Rust"]:
    c.lw_2.addItem(dati2)
  c.txb_1.setHtml("""<table bgcolor="yellow" cellpadding="5" cellspacing="0">
<tr>
  <td><b>Groups:</b></td>
  <td>comp.lang.nim.announce</td>
</tr>

<tr>
  <td><b>From:</b></td>
  <td>"Andrea" &lt;andrea@example.com&gt;</td>
</tr>

<tr>
  <td><b>Subject:</b></td>
  <td>
    <b>[ANN] Nim 2.2.4 Final Available</b>
  </td>
</tr>
</table>

<h3>Nim 2.2.4 Final</h3>

<p>
<a href="https://nim-lang.org/">
https://nim-lang.org/
</a>
is now available.
</p>

<p>
Nim is a fast, expressive and elegant programming language focused on
performance, portability and metaprogramming.
</p>

<p>
This release includes:
</p>

<ul>
  <li>Improved compiler optimizations</li>
  <li>Better async support</li>
  <li>Enhanced macro system</li>
  <li>Various bug fixes and stability improvements</li>
</ul>

<p>
Download binaries and source packages from the official website.
</p>""")
  
# NOTA: le proc passate come slot devono avere {.raises: [].}
# se nel modulo c'è almeno una proc dichiarata con quel pragma,
# altrimenti il tipo non è compatibile con i QxxxSlot di seaqt.
# Esempio: proc mioHandler() {.raises: [].} = ...
