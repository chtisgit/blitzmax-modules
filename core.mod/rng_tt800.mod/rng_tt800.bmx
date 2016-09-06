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
	
	Method vector_init(seed3 = 0) Private
		seed1 = 9
		seed2 = 3402
		For Local i = 0 Until N
			seed1 = (seed1 * MULT + ADD) ~ seed3
			seed2 :* seed2 + 1
			p[i] = seed2 + (seed1 Shr 10)
		Next
		vector_update
	EndMethod

	Method Init()
		vector_init
	EndMethod

	Method RandInt()
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
	
	Method RndDouble:Double()
		' IEEE754 trickery
		Local ieee754:Long = RandInt() | (Long(RandInt()) Shl 32)
		ieee754 :& $000FFFFFFFFFFFFF:Long
		ieee754 :| $3FF0000000000000:Long
		Return Double Ptr(Varptr ieee754)[0]-1
	EndMethod
EndType
