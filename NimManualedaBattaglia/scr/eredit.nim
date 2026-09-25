type
    Cibo = ref object of RootObj
        proteine: int
        carboidrati: int
        grassi: int
        parent: Cibo
    Verdura = ref object of Cibo

proc newCibo(prot, carb, garss: int): Cibo =
    Cibo(proteine: prot, carboidrati: carb, grassi: garss)

proc calcolacalorie(self: Cibo): int =
    result = (self.proteine * 4 + self.carboidrati * 4 +
    self.grassi * 9)

proc newVerdura(prot, carb: int, grass = 0): Verdura =
    Verdura(proteine: prot, carboidrati: carb, grassi: grass)

when isMainModule:

    var pasta = newCibo(prot = 12, carb = 72, garss = 1)
    echo pasta.calcolacalorie

    var melanzana = newVerdura(prot = 2, carb = 3)
    echo melanzana.calcolacalorie
