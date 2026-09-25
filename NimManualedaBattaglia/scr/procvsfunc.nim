let globale = 20

proc somma(a: int): int =
    result = globale + a
     
func diff(a: int): int =
    result = globale - a
    
echo(somma(10))
echo(diff(10))
