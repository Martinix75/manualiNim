import std/[tables, strutils]
import seaqt/[qdialog, qgridlayout, qlabel, qlineedit, qspinbox, qcheckbox, qdialogbuttonbox]
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
    #ok: QPushButton
    #onDataCh*: proc() {.closure.} #funzione acessibile dalla madrea per poter fare "cose".

proc upDateTab(a: Keep) {.raises: [].}

proc modalx*(tab: Table[string, string] ): Keep {.raises: [].} =
    echo("Modal Win")
    #var tabx = tab
    let
        form = Keep()
        #mwin = QDialog.create()
        #mlay_1 = QGridLayout.create()
        #mlab_1 = QLabel.create("Imposta Separatore Migliaia")
        #mlab_2 = QLabel.create("Imposta separatori Decimali")
        #mlab_3 = QLabel.create("Arrotonda a")
        #mqcb_1 = QCheckBox.create("Negativi Rossi")
        #mqle_1 = QLineEdit.create()
        #mqle_2 = QLineEdit.create()
        #msbx_1 = QSpinBox.create()
        #mbbb_1 = QDialogButtonBox.create()

    form.dlg = QDialog.create()
    form.mlab_1 = QLabel.create("Imposta Separatore Migliaia")
    form.mlab_2 = QLabel.create("Imposta Separatore Migliaia")
    form.mlab_3 = QLabel.create("Arrotonda a")
    form.mqcb_1 = QCheckBox.create("Negativi Rossi")
    form.mqle_1 = QLineEdit.create()
    form.mqle_2 =  QLineEdit.create()
    form.msbx_1 = QSpinBox.create()
    form.mbbb_1 = QDialogButtonBox.create()
    form.mlay_1 = QGridLayout.create()
    form.tabx = tab


    discard form.mbbb_1.addButton(0x400)
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
    form.mlay_1.addWidget(form.mbbb_1, 4, 0, 4, 1)

    connect(form.mbbb_1, onAccepted, upDateTab, form)
    connect(form.mbbb_1, onRejected, form.dlg.reject)

    form.dlg.setLayout(form.mlay_1)
    form.dlg.resize(200, 200)
    form.dlg.setWindowTitle("Modal Win")
    #form.dlg.show()
    result = form
    #[if form.dlg.exec() == 1:
        echo("Ritorno....")
        let chk = if form.mqcb_1.isChecked == true: "checked" else: "unchecked"
        form.tabx["separatore"] = form.mqle_1.text()
        form.tabx["decimali"] = form.mqle_2.text()
        form.tabx["numDec"] = form.msbx_1.text()
        form.tabx["redNeg"] = chk
        result = form ]#

proc upDateTab(a: Keep) =
    echo("Aggiorno Dati..")
    let chk = if a.mqcb_1.isChecked == true: "checked" else: "unchecked"
    a.tabx["separatore"] = a.mqle_1.text()
    a.tabx["decimali"] = a.mqle_2.text()
    a.tabx["numDec"] = a.msbx_1.text()
    a.tabx["redNeg"] = chk
    a.dlg.accept()

when isMainModule:
    var tab = {"separatore": "'", "decimali": ".","numDec": "3", "redNeg": "checked"}.toTable
    echo("Inizio --> ", tab)
    discard QApplication.create()
    let rit = modalx(tab)
    echo("Risultato --> ", rit.tabx)
    quit QApplication.exec().int
