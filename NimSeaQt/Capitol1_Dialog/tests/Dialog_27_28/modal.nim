import std/[tables, strutils]
import seaqt/[qapplication, qdialog, qgridlayout, qlabel, qlineedit, qspinbox, qcheckbox, qdialogbuttonbox]
import qtconnect

proc modalx*(tab: Table[string, string] ): Table[string, string] {.raises: [].} =
    echo("Modal Win")
    var tabx = tab
    let
        mwin = QDialog.create()
        mlay_1 = QGridLayout.create()
        mlab_1 = QLabel.create("Imposta Separatore Migliaia")
        mlab_2 = QLabel.create("Imposta separatori Decimali")
        mlab_3 = QLabel.create("Arrotonda a")
        mqcb_1 = QCheckBox.create("Negativi Rossi")
        mqle_1 = QLineEdit.create()
        mqle_2 = QLineEdit.create()
        msbx_1 = QSpinBox.create()
        mbbb_1 = QDialogButtonBox.create()

    discard mbbb_1.addButton(0x400)
    discard mbbb_1.addbutton(0x00400000)
    try:
        mqle_1.setText(tabx["separatore"])
        mqle_2.setText(tabx["decimali"])
        msbx_1.setValue(parseInt(tabx["numDec"]).cint)
        if tabx["redNeg"] == "checked":
            mqcb_1.setChecked(true)
        if tabx["redNeg"] == "checked":
            mqcb_1.setChecked(true)
        else:
            mqcb_1.setChecked(false)
    except KeyError:
        echo("w")
    except ValueError:
        echo("s")
    msbx_1.setRange(0, 5)
    mlay_1.addWidget(mlab_1, 0, 0)
    mlay_1.addWidget(mlab_2, 1, 0)
    mlay_1.addWidget(mlab_3, 2, 0)
    mlay_1.addWidget(mqcb_1, 3, 0)
    mlay_1.addWidget(mqle_1, 0, 1)
    mlay_1.addWidget(mqle_2, 1, 1)
    mlay_1.addWidget(msbx_1, 2, 1)
    mlay_1.addWidget(mbbb_1, 4, 0, 4, 1)

    connect(mbbb_1, onAccepted, mwin.accept)
    connect(mbbb_1, onRejected, mwin.reject)

    mwin.setLayout(mlay_1)
    mwin.resize(200, 200)
    mwin.setWindowTitle("Modal Win")
    mwin.show()
    if mwin.exec() == 1:
        echo("Ritorno....")
        let chk = if mqcb_1.isChecked == true: "checked" else: "unchecked"
        tabx["separatore"] = mqle_1.text()
        tabx["decimali"] = mqle_2.text()
        tabx["numDec"] = msbx_1.text()
        tabx["redNeg"] = chk
        result = tabx

when isMainModule:
    var tab = {"separatore": "'", "decimali": ".","numDec": "3", "redNeg": "checked"}.toTable
    echo("Inizio --> ", tab)
    discard QApplication.create()
    tab = modalx(tab)
    echo("Risultato --> ", tab)
    quit QApplication.exec().int
