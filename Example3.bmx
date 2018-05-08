' Warning: low quality looking code below

Framework BRL.StandardIO
Import BRL.Random
Import BRL.GlMax2D
Import BRL.SystemDefault
Import BRL.PolledInput

Import "NeuralCode.bmx"

SeedRnd MilliSecs()

Local SingleLayer:NeuronLayer = New NeuronLayer
Local OutputNeuron:Neuron = New Neuron

SingleLayer.Configure(64,8)
OutputNeuron.ConfigureInputs(8)

'Layer 1: 8 neurons with all 64 pixels connected to each them
'Layer 2: 1 neuron with 8 inputs (previous neurons)


Local OutArray:Float[8]

Local Layer2Output:Float

Local PixmapArray:Int[8,8]
Local NetworkArray:Int[64]

Local Iterations:Int = 100

Local PointerX,PointerY
Local TempColor
Local LearnFlag = 0
Local DesiredOutput


AppTitle$ = "Neural network pattern example"
Graphics 800,800

While Not AppTerminate()
	If LearnFlag = 1
		For Local i=0 To Iterations
			SingleLayer.SetInputsFromArray(NetworkArray)
			
			OutArray = SingleLayer.CalculateToArray()
			OutputNeuron.SetInputs(OutArray)
			
			Layer2Output = OutputNeuron.CalculateOutput()
			
			SingleLayer.LearnFromErrorsArray(OutputNeuron.GetErrorsArray(DesiredOutput))
			OutputNeuron.Learn(DesiredOutput)
		Next
		LearnFlag = 0
	End If
	
	For Local ii=0 To 63
		NetworkArray[ii] = PixmapArray[ii/8, ii - ii/8*8]
	Next

	SingleLayer.SetInputsFromArray(NetworkArray)
	OutArray = SingleLayer.CalculateToArray()
	OutputNeuron.SetInputs(OutArray)

	
	Cls
	
	For Local i1=0 To 7
		For Local i2=0 To 7
			TempColor = PixmapArray[i1,i2]
			SetColor 255*TempColor,255*TempColor,255*TempColor
			DrawRect (i1*100),(i2*100),100,100
		Next
	Next
	
	PointerX = MouseX() / 100
	PointerY = MouseY() / 100

	SetColor 64,64,64
	DrawRect (PointerX*100)+10,(PointerY*100)+10,80,80
	SetColor 200,200,200
	
	
	If KeyDown(KEY_G) Then DrawText "Learning as good...",10,30 ; LearnFlag = 1 ; DesiredOutput=1
	If KeyDown(KEY_B) Then DrawText "Learning as bad...",10,30 ; LearnFlag = 1 ; DesiredOutput=0
	
	If KeyDown(KEY_N)
		DrawText "Learning as bad with random noise...",10,30
		LearnFlag = 1
		DesiredOutput=0
		
		For Local ii=0 To 63
			NetworkArray[ii] = Rnd(1)
		Next
	End If

	If MouseHit(1)
		If PixmapArray[PointerX,PointerY] = 1
			PixmapArray[PointerX,PointerY] = 0
		Else
			PixmapArray[PointerX,PointerY] = 1
		End If
	End If
	
	
	DrawText PointerX + " / " + PointerY,10,10
	DrawText "Click to flip the cell state. Hold G/B to learn this pattern as a good/bad example.",10,20
	DrawText "Hold N to learn with random noise pattern as a bad example.",10,30
	DrawText "Usually network needs about 5 good and bad examples.",10,40
	DrawText "Neural network thinks: " + OutputNeuron.CalculateOutput(),10,50
	
	Flip
Wend