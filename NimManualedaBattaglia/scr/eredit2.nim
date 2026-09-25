
type
  Frutto = ref object of RootObj
    nome*: string
  Mela = ref object of Frutto
  Pera = ref object of Frutto

method eat(f: Frutto) {.base.} =
  echo "Sono un Frutto Generico"

method eat(f: Mela) =
  echo "Sono un Mela"

method eat(f: Pera) =
  echo "Sono un Pera"

let cesto = @[Mela(nome:"a"), Pera(nome:"b")]

for frutto in cesto:
  frutto.eat()
#perchè nel for la variabile è come se diventasse "dinamicamente" tipi oggetti diversi se ti limiti a chiamare oggetti singoli sei sempre nello static dispatch
#[import times
type
    Note = ref object of RootObj
        text: string
        parent: Note
    TaskNote = ref object of Note
        completed: bool
    ReminderNote = ref object of Note
        due_timestamp: DateTime
        
proc render(note: Note): string =
    return note.text

proc render(note: TaskNote): string =
    case note.completed
    of true:
        return "Ok.. true!!!"
    of false:
        return "Ok..false!!"
proc render(note: ReminderNote): string =
    return note.due_timestamp.format("YYYY-MM-dd") & " " & note.text

let textNote = Note(text: "solo uan nota!")
let taskNote = TaskNote(text:"Ma ciaoo", completed: false, parent: textNote)
let reminderNote = ReminderNote(text: "Non dimenticare ", due_timestamp: now() + 1.months, parent: taskNote)
let childNote = ReminderNote(text: "ma veramente..", due_timestamp:now() + 1.hours + 1.months, parent: reminderNote)

echo textNote.render()
echo taskNote.render()
echo reminderNote.render()
echo childNote.render()]#

#[type 
    Stringa = ref object of RootObj
        frase: string
        parent: Stringa
    Finale = ref object of Stringa
        finale: char
        
proc newStringa(a: string): Stringa =
    Stringa(frase: a)
    
proc newFinale(a: string, b: char, v: Stringa): Finale =
    Finale(finale: b, parent: v)
    
let f1 = newStringa("ciao")
#echo f1.frase

let f2 = newFinale(a = "figa", b = '!',v = f1)
echo(f2.frase, f2.finale)]#
