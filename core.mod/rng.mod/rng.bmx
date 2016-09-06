Strict

Rem
bbdoc: Random Number Generator's super module
End Rem
Module core.rng

ModuleInfo "Version: 0.8"
ModuleInfo "Author: Christian Fiedler"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Christian Fiedler"

Import core.interfaces

Rem
	bbdoc: Interface for pseudo-random number generators
EndRem
Type InterfaceRNG Extends InterfaceInit
	
	Rem
	bbdoc: Set random number generator seed
	about: the random number sequence generated after a call to seed is required
	to be the same every time the seed is set.
	End Rem
	Method Seed(seed) Abstract
	
	Rem
	bbdoc: Generate a random 32 bit integer
	returns: completely random integer
	about: this function should deliver 32 bits of entropy from the RNG packed
	into a 32 bit integer
	End Rem
	Method RandInt:Int() Abstract
	
	Rem
	bbdoc: Generate a random double
	returns: random double from 0.0 (inclusive) to 1.0 (exclusive)
	End Rem	
	Method RndDouble:Double() Abstract
	
	Rem
	bbdoc: Generate random 32 bit integer (in a certain range)
	returns: A random integer in the range min (inclusive) to max (inclusive)
	End Rem
	Method Rand(min_value, max_value)
		' FIXME: this is bad ...
		Local m = max_value - min_value + 1
		Local x = RandInt()
		If m <> 0 Then x :Mod m
		If x < 0 Then x :+ m
		Return x + min_value
	EndMethod
	
	Rem
	bbdoc: Generate random double
	returns: A random double in the range min (inclusive) to max (exclusive)
	End Rem
	Method Rnd:Double(min_value:Double, max_value:Double)
		Return RndDouble() * (max_value - min_value) + min_value
	EndMethod

EndType

