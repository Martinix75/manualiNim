import std/macros
# SOLUZIONE SEMPLICE: Due macro con overloading

# Macro senza parametro (per segnali come clicked)
macro connect*(call: untyped; event: untyped; fuc: untyped) =
    result = quote do:
        `call`.`event`(proc() {.closure.} = `fuc`())

# Macro con parametro (per segnali come valueChanged)
macro connect*(call: untyped; event: untyped; fuc: untyped; paramType: untyped) =
    result = quote do:
        `call`.`event`(proc(val: `paramType`) {.closure.} = `fuc`())
