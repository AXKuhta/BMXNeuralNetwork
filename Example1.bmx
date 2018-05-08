' Based on: https://medium.com/technology-invention-and-more/how-to-build-a-simple-neural-network-in-9-lines-of-python-code-cc8f23647ca1

Framework BRL.StandardIO
Import BRL.Random

Import "NeuralCode.bmx"

SeedRnd MilliSecs()

Local SingleNeuron:Neuron = New Neuron

SingleNeuron.ConfigureInputs(3)

Print "Neuron has random weights now and should fail the test"

SingleNeuron.Inputs[0].Value = 1
SingleNeuron.Inputs[1].Value = 0
SingleNeuron.Inputs[2].Value = 0

Print "Test result (Should be about ~0.99) : " + SingleNeuron.CalculateOutput()
Print "Error rate: " + (1 - SingleNeuron.CalculateOutput())

Local Iterations, IterationLimit
IterationLimit = Int(Input("For how many iterations to train the neuron (>100 is enough): "))

' |Inp1|Inp2|Inp3|DesiredOut|
Local TrainingSet[][] = [ [0,0,1,0] , [1,1,1,1] , [1,0,1,1] , [0,1,1,0] ]

Print "Learning..."

While Iterations < IterationLimit
	For Local SetSubArray[] = EachIn TrainingSet
		SingleNeuron.Inputs[0].Value = SetSubArray[0]
		SingleNeuron.Inputs[1].Value = SetSubArray[1]
		SingleNeuron.Inputs[2].Value = SetSubArray[2]
		
		SingleNeuron.Learn(SetSubArray[3])
	Next
	
	Iterations:+1
Wend

Print "Setting test values for input..."

SingleNeuron.Inputs[0].Value = 1
SingleNeuron.Inputs[1].Value = 0
SingleNeuron.Inputs[2].Value = 0

Print "Test result (Should be about ~0.99) : " + SingleNeuron.CalculateOutput()




