' Based on: https://medium.com/technology-invention-and-more/how-to-build-a-multi-layered-neural-network-in-python-53ec3d1d326a

Framework BRL.StandardIO
Import BRL.Random

Import "NeuralCode.bmx"

SeedRnd MilliSecs()

Local SingleLayer:NeuronLayer = New NeuronLayer
Local OutputNeuron:Neuron = New Neuron

SingleLayer.Configure(3,4)
OutputNeuron.ConfigureInputs(4)

'Layer 1: 4 neurons with 3 inputs each
'Layer 2: 1 neuron with 4 inputs (previous neurons)


Local OutArray:Float[4]
Local NetworkOutput:Float

Local TrainingData[][] = [ [0,0,1,0], [0,1,1,1], [1,0,1,1], [0,1,0,1], [1,0,0,1], [1,1,1,0], [0,0,0,0] ]


For Local Iteration=0 To 10000
	For Local SubArray[] = EachIn TrainingData
		SingleLayer.SetInputsFromArray(SubArray)
		
		OutArray = SingleLayer.CalculateToArray()
		OutputNeuron.SetInputs(OutArray)
			
		NetworkOutput = OutputNeuron.CalculateOutput()
		
		If (Iteration Mod 1000) = 0 Then Print "Iteration: " + Iteration + ". Expected output: " + SubArray[3] + "; Got: " + NetworkOutput

		SingleLayer.LearnFromErrorsArray(OutputNeuron.GetErrorsArray(SubArray[3]))
		OutputNeuron.Learn(SubArray[3])
	Next
Next