Import core.bitmap

Const COUNT = 100

Local bitmap:TBitmap = TBitmap.Create(COUNT)

For i = 0 Until COUNT
	Local b = Rand(0,1)
	bitmap.Set i, b
	Assert bitmap.Get(i) = b
Next

Print "bitmap saves " + COUNT + " bits in " + bitmap.Size() + " bytes"