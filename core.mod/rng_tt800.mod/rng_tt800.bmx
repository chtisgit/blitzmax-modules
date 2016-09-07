Strict

Rem
bbdoc: TT800 PRNG implementing InterfaceRNG
End Rem
Module core.rng_tt800

ModuleInfo "Version: 0.8"
ModuleInfo "Author: Christian Fiedler"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Christian Fiedler"

Import core.rng

Type TRNG_TT800 Extends InterfaceRNG
	Const N = 25, M = 7
	Const MULT = 509845221, ADD = 3
	Global A[] = [0, $8EBFD028]

	Field p[N], idx = 0
	Field seed1, seed2

	Method vector_update() Private
		Local i
		For i = 0 Until N-M
			p[i] = p[i+M] ~ (p[i] Shr 1) ~ A[p[i] & 1]
		Next
		For i = i Until N
			p[i] = p[i+(M-N)] ~ (p[i] Shr 1) ~ A[p[i] & 1]
		Next
	EndMethod
	
	Method vector_init(opt_seed=0) Private
		seed1 = 9 ~ opt_seed
		seed2 = 3402 ~ opt_seed
		For Local i = 0 Until N
			seed1 = (seed1 * MULT + ADD)
			seed2 :* seed2 + 1
			p[i] = seed2 + (seed1 Shr 10)
		Next
		vector_update
	EndMethod

	Method Init()
		vector_init
	EndMethod

	Method RndInt()
		Local e

		If idx >= N Then
			vector_update()
			idx = 0
		EndIf

		e = p[idx]
		e :~ (e Shl 7) & $2b5b2500
		e :~ (e Shl 15) & $db8b0000
		e :~ (e Shr 16)

		idx :+ 1

		Return e
	EndMethod

	Method Seed(seed)
		vector_init seed
	EndMethod

	Rem
	bbdoc: Seed RNG with a vector of integers
	about: @seed shall point to a vector of at least 25 integers
	The first 25 integers are used as the TT800 PRNG's state.
	End Rem
	Method SeedVector(seed:Int Ptr)
		For Local i = 0 Until N
			p[i] = seed[i]
		Next
	EndMethod


	Method RndDouble:Double()
		' IEEE754 trickery
		Local ieee754:Long

		' this writes random bits into the mantissa
		ieee754 = RndInt() ~ (Long(RndInt()) Shl 20)

		' mask mantissa
		ieee754 :& $000FFFFFFFFFFFFF:Long

		' this sets exponent bits to zero in
		' excess notation, not touching sign bit
		ieee754 :| $3FF0000000000000:Long

		' now we have a random double in range
		'   1 (inclusive) to 2 (exclusive)
		' read as double and subtract 1:
		Return Double Ptr(Varptr ieee754)[0]-1
	EndMethod
EndType
