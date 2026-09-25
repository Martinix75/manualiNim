import std/[algorithm, strutils]
let h = "1234567.0"
var cont = 1
var strx: string
let a = split(h,".")
let b = a[0]
for z in countDown(len(b)-1, 0):
    echo b[z]
    strx = strx & b[z]
    if cont == 3:
        echo "."
        strx = strx & "."
        cont = 0
    cont.inc()

echo("--> ", strx)
let invstr = reversed(strx)
echo(invstr)
let jstr = join(invstr,"")
echo(jstr)
