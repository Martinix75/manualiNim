proc sommaArray(arry: array[4, int]): array[4, int] =
    var arry_copia = arry
    for indice in 0..<len(arry):
        arry_copia[indice] = arry[indice] + 10
    result = arry_copia
        

let array1 = [1, 2, 3, 4]
let array2 = [10, 20, 30, 40, 50]

echo sommaArray(array1)
#echo sommaArray(array2)

echo("-------- con seq ----------")

proc sommaSeq(sec: seq[int]): seq[int]=
    var sec_copia = sec
    for indice in sec.low..sec.high:
        sec_copia[indice] = sec[indice] + 10
    result = sec_copia

let sec1 = @[1, 2, 3 ,4]
let sec2 = @[10, 20, 30, 30, 40, 50, 60]

echo sommaSeq(sec1)
echo sommaSeq(sec2)
