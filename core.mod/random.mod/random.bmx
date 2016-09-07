Strict

Rem
bbdoc: Core.Random
about:
The random module contains commands for generating random numbers
in a way compatible with original BlitzMax Module BRL.Random.

@Warning: The functions provided by this module, are not thread-safe.
If you want thread-safety, either lock use of the functions with
a mutex or use a Core.RNG_* module directly and create as many
instances of an RNG as you like.

This module uses the Core.RNG_TT800 pseudo-random number generator.

To obtain other numbers each time you start the program you can
seed the PRNG like this:

&{
SeedRnd MilliSecs()
}

@Warning: As this method provides a maximum of only 32 bits of entropy
this is not safe to use in cryptographic functions.
End Rem
Module core.random

ModuleInfo "Version: 0.8"
ModuleInfo "Author: Christian Fiedler"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Christian Fiedler"

Import core.rng
Import core.rng_tt800 'this is the default RNG used

Private

Global active_rng:InterfaceRNG = Null
Global active_seed = 0

Public

Rem
bbdoc: Generate random double
returns: A random double in the range 0 (inclusive) to 1 (exclusive)
End Rem
Function RndDouble:Double()
	Return active_rng.RndDouble()
End Function

Rem
bbdoc: Generate random float
returns: A random float in the range 0 (inclusive) to 1 (exclusive)
End Rem
Function RndFloat#()
	Return Float(RndDouble())
End Function

Rem
bbdoc: Generate random double
returns: A random double in the range min (inclusive) to max (exclusive)
about: 
The optional parameters allow you to use Rnd in 3 ways:

[ @Format | @Result
* &Rnd() | Random double in the range 0 (inclusive) to 1 (exclusive)
* &Rnd(_x_) | Random double in the range 0 (inclusive) to n (exclusive)
* &Rnd(_x,y_) | Random double in the range x (inclusive) to y (exclusive)
]
End Rem
Function Rnd:Double( min_value:Double=1,max_value:Double=0 )
	If min_value = 1 And max_value = 0 Then
		Return active_rng.RndDouble()
	EndIf
	If min_value > 0 And max_value = 0 Then
		max_value = min_value
		min_value = 0
	EndIf
	Return active_rng.Rnd(min_value, max_value) 
End Function

Rem
bbdoc: Generate random integer
returns: A random integer in the range min (inclusive) to max (inclusive)
about:
The optional parameter allows you to use #Rand in 2 ways:

[ @Format | @Result
* &Rand(x) | Random integer in the range 1 to x (inclusive)
* &Rand(x,y) | Random integer in the range x to y (inclusive)
]
End Rem
Function Rand( min_value,max_value=1 )
	If max_value > min_value And max_value = 1 Then
		max_value = min_value
		min_value = 1
	EndIf
	Return active_rng.Rand(min_value, max_value)
End Function

Rem
bbdoc: Set random number generator seed
End Rem
Function SeedRnd( seed )
	active_seed = seed
	active_rng.Seed(seed)
End Function

Rem
bbdoc: Get random number generator seed
returns: The current random number generator seed
about: Use in conjunction with SeedRnd, RndSeed allows you to reproduce sequences of random
numbers.
Generally, the return value is undefined if there has been no previous call to SeedRnd since
the active RNG was set using SetActiveRNG.
End Rem
Function RndSeed()
	Return active_seed
EndFunction

Rem
bbdoc: Specify a random number generator that should be used by the functions provided
about: Core.Random sets an appropriate RNG itself. You probably don't need this function.
If you want to use different RNG's, consider using the specific type directly.
End Rem
Function SetActiveRNG(rng:InterfaceRNG)
	active_rng = rng
	active_rng.Init()
EndFunction

SetActiveRNG New TRNG_TT800