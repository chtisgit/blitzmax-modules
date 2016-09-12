Strict

Rem
bbdoc: Core.Bitmap
about:
This Module contains the type TBitmap which can
be used to save vectors of boolean values efficiently
End Rem
Module core.bitmap
Import core.interfaces

Rem
bbdoc: TBitmap holds a vector of booleans
about:
TBitmap uses an array of Int to hold the bits.
The data structure is designed for static use.
A bitmap can be resized, but the operation is
not optimized to be fast.
End Rem
Type TBitmap Extends InterfaceSize

	Const BITS_PER_UNIT = 32

	Field buf:Int[]
	Field capacity:Int

	Rem
	bbdoc: Create a bitmap
	returns: a new bitmap
	about: @cap is the capacity of the bitmap in bits
	EndRem
	Function Create:TBitmap(cap:Int)
		Local b:TBitmap = New TBitmap
		b.Resize cap
		Return b
	EndFunction

	Function MaskBits(buf:Int[],cap) Private
		Local mask, m

		m = cap Mod BITS_PER_UNIT
		If m <> 0 Then
			Local mask = 0
			While m <> 0
				mask = (mask Shl 1) | 1
				m :- 1
			Wend
			buf[buf.length-1] :& mask
		EndIf
	EndFunction

	Rem
	bbdoc: Resets all bits
	about: Resets all bits in bitmap to @b (by default = False)
	EndRem
	Method Clear(b = False)
		Local val,i
		If b Then val = $FFFFFFFF Else val = 0
		For i = 0 Until buf.length
			buf[i] = val
		Next
		MaskBits buf,capacity
	EndMethod

	Rem
	bbdoc: Get capacity in bits
	EndRem
	Method SizeNative()
		Return capacity
	EndMethod

	Rem
	bbdoc: Get capacity in bytes
	EndRem
	Method Size()
		Local bc = capacity/BITS_PER_UNIT
		If capacity Mod BITS_PER_UNIT <> 0 Then bc:+1
		Return bc
	EndMethod

	Rem
	bbdoc: Resize a bitmap
	about: @cap is the capacity of the bitmap in bits

	When an existing bitmap is resized, the data is
	left untouched - unless the new size is smaller
	than the old size.

	If the new size is larger, the additional bits
	are guaranteed to be False.
	EndRem
	Method Resize(cap:Int)

		If cap = capacity Then Return

		Local nbf:Int[], bc = cap/BITS_PER_UNIT

		If cap Mod BITS_PER_UNIT <> 0 Then bc :+ 1

		nbf = New Int[bc]

		If buf <> Null Then
			For Local i = 0 Until Min(buf.length, bc)
				nbf[i] = buf[i]
			Next

			MaskBits nbf, cap
		EndIf

		buf = nbf
		capacity = cap
	EndMethod

	Rem
	bbdoc: get boolean value
	returns: the boolean value at position @pos in the bitmap
	EndRem
	Method Get(pos)
		Return (buf[pos/BITS_PER_UNIT] Shr (pos Mod BITS_PER_UNIT)) & 1
	EndMethod

	Rem
	bbdoc: set boolean value
	about: set the boolean at position @pos to @b
	EndRem
	Method Set(pos, b)
		Local n = pos / BITS_PER_UNIT
		Local k = 1 Shl (pos Mod BITS_PER_UNIT)
		If b Then
			buf[n] :| k
		Else
			buf[n] :& ~k
		EndIf
	EndMethod

EndType
