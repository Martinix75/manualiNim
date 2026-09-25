import std/[tables, strutils]
import seaqt/[qapplication, qdialog, qgridlayout, qlabel, qlineedit, qspinbox, qcheckbox, qdialogbuttonbox, qpushbutton]
import qtconnect4_3
type
  Keep* = ref object
    dlg*: QDialog
    mlab_1, mlab_2, mlab_3: Qlabel
    mqle_1, mqle_2: QLineEdit
    mqcb_1: QCheckBox
    msbx_1: QSpinBox
    mbbb_1: QDialogButtonBox
    tabx*: Table[string, string]
    mlay_1: QGridLayout
    ok: QPushButton
    onDataCh*: proc() {.closure.} #funzione acessibile dalla madrea per poter fare "cose".

proc upDateTab(a: Keep) {.raises: [].}

proc modlessx*(tab: Table[string, string]):Keep  {.raises: [].} =
    echo("Modal Win")
    let form = Keep()
    form.mlay_1 = QGridLayout.create()
    form.dlg = QDialog.create()
    form.mlab_1 = QLabel.create("Imposta Separatore Migliaia")
    form.mlab_2 = QLabel.create("Imposta separatori Decimali")
    form.mlab_3 = QLabel.create("Arrotonda a")
    form.mqle_1 = QLineEdit.create()
    form.mqle_2 = QLineEdit.create()
    form.mqcb_1 = QCheckBox.create("Negativi Rossi")
    form.msbx_1 = QSpinBox.create()
    form.mbbb_1 = QDialogButtonBox.create()
    form.tabx = tab
    
    let ok = form.mbbb_1.addButton(0x02000000) #nota cher ora abbiamo assegnato il bottone ad uan variabile
    discard form.mbbb_1.addbutton(0x00400000)
    try:
        form.mqle_1.setText(form.tabx["separatore"])
        form.mqle_2.setText(form.tabx["decimali"])
        form.msbx_1.setValue(parseInt(form.tabx["numDec"]).cint)
        if form.tabx["redNeg"] == "checked":
            form.mqcb_1.setChecked(true)
        if form.tabx["redNeg"] == "checked":
            form.mqcb_1.setChecked(true)
        else:
            form.mqcb_1.setChecked(false)
    except KeyError:
        discard
    except ValueError:
        discard
    form.msbx_1.setRange(0, 5)
    form.mlay_1.addWidget(form.mlab_1, 0, 0)
    form.mlay_1.addWidget(form.mlab_2, 1, 0)
    form.mlay_1.addWidget(form.mlab_3, 2, 0)
    form.mlay_1.addWidget(form.mqcb_1, 3, 0)
    form.mlay_1.addWidget(form.mqle_1, 0, 1)
    form.mlay_1.addWidget(form.mqle_2, 1, 1)
    form.mlay_1.addWidget(form.msbx_1, 2, 1)
    form.mlay_1.addWidget(form.mbbb_1, 4, 0)

    connect(ok, onClicked, upDateTab, form)
    connect(form.mbbb_1, onRejected, form.dlg.reject)

    form.dlg.setLayout(form.mlay_1)
    form.dlg.resize(200, 200)
    form.dlg.setWindowTitle("Modal Win")
    result = form
    
proc upDateTab(a: Keep)=
  echo("Ritorno....")
  let chk = if a.mqcb_1.isChecked == true: "checked" else: "unchecked"
  a.tabx["separatore"] = a.mqle_1.text()
  a.tabx["decimali"] = a.mqle_2.text()
  a.tabx["numDec"] = a.msbx_1.text()
  a.tabx["redNeg"] = chk
  echo("ris --> ", a.tabx)
  try:
    a.onDataCh() #chiama questa funzione sulla madre paer aggiornare i dati in tabella
  except Exception:
    discard

when isMainModule:
    var tab = {"separatore": "'", "decimali": ".","numDec": "3", "redNeg": "checked"}.toTable
    echo("Inizio --> ", tab)
    discard QApplication.create()
    let x = modlessx(tab)
    echo("Risultato --> ", x.tabx)
    x.dlg.show()
    quit QApplication.exec().int
   
