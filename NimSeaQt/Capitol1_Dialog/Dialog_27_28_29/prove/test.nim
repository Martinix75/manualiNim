import seaqt/[qapplication, qdialog, qtablewidget, qtablewidgetitem, qboxlayout]
import qtconnect

proc main() =
  discard QApplication.create()

  let win = QDialog.create()
  let table = QTableWidget.create()

  table.setRowCount(3)
  table.setColumnCount(3)
  table.setHorizontalHeaderLabels(@["A","B","C"])

  # prototipo con testo (serve per forzare il binding a usare item con text)

  var items: seq[QTableWidgetItem] #seq per mantenere in meoria i gli item altrimenti il gc li distrugge tutti appena greati tranne l'ultimo
  for x in countup(0,2):
    for y in countup(0,2):
      let tx = QTableWidgetItem.create("FFFF")
      table.setItem(x.cint,y.cint ,tx)
      items.add(tx)
                           
  

  let lay = QVBoxLayout.create()
  lay.addWidget(table)
  win.setLayout(lay)
  win.resize(400, 200)
  win.show()

  discard QApplication.exec()

main()
