Import BRL.Random

Type NeuronInput
	Field Weight:Float
	Field Value:Float
End Type

Type Neuron
	Field Inputs:NeuronInput[] ' Create empty array of custom 'NeuronInput' type
	
	Method ConfigureInputs(NumberOfInputs:Int)
		Self.Inputs[] = Self.Inputs[..NumberOfInputs] ' Resize array to fit the required number of neurons
		
		For Local i=0 To NumberOfInputs
			Self.Inputs[i] = New NeuronInput ' Fill the aray with newly created 'NeuronInput'-type objects
			Self.Inputs[i].Weight = (1.0 - Rnd(2.0)) ' Randomize startup weights from -1.0 to 1.0
		Next
	End Method
	
	
	Method DumpInputs()
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			Print InputObject.Value
		Next
	End Method
	
	
	Method SetInputs(InputsArray:Float[]) ' Sets neuron inputs from float array
		Local i:Int = 0
		
		If InputsArray.length <> Self.Inputs.length Then RuntimeError("SetInputs(): Array size mismatch")
		
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			InputObject.Value = InputsArray[i]
			i:+1
		Next
	End Method
	
	
	Method CalculateUnnormalizedOutput:Float() ' Returns the sum of all neuron inputs multiplied to their weights
		Local UnnormalizedOutput:Float
		
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			UnnormalizedOutput :+ (InputObject.Weight * InputObject.Value)
		Next
		
		Return UnnormalizedOutput
	End Method
	
	
	Method CalculateOutput:Float()
		Return Sigmoid(Self.CalculateUnnormalizedOutput())
	End Method
	
	
	Method Learn(DesiredOutput:Float)
		Local Output:Float = Self.CalculateOutput()
		Local Error:Float = (DesiredOutput - Output)
		
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			InputObject.Weight:+ (Error * InputObject.Value * SigmoidDerivative(Output))
		Next
	End Method
	
	
	Method LearnFromKnownError(Error:Float)
		Local Output:Float = Self.CalculateOutput()
				
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			InputObject.Weight:+ (Error * InputObject.Value * SigmoidDerivative(Output))
		Next
	End Method
	
	
	Method GetErrorsArray:Float[](DesiredOutput:Float)
		Local ReturnArray:Float[Self.Inputs.length]
		Local Error:Float = DesiredOutput - Self.CalculateOutput()
		Local Delta:Float = Error * SigmoidDerivative(Self.CalculateOutput())
		Local i:Int = 0
		
		For Local InputObject:NeuronInput = EachIn Self.Inputs
			ReturnArray[i] = Delta * InputObject.Weight
			i:+1
		Next
		
		Return ReturnArray
	End Method

End Type

Type NeuronLayer
	Field NeuronArray:Neuron[]
	
	Method Configure(Inputs:Int, Outputs:Int)
		NeuronArray = NeuronArray[..Outputs+1]
		
		For Local i=0 To (Outputs - 1)
			Self.NeuronArray[i] = New Neuron
			Self.NeuronArray[i].ConfigureInputs(Inputs)
		Next
	End Method
	
	
	Method SetInputsFromArray(InputArray[])
		Local iArray:Int
		
		For Local iNeuron:Neuron = EachIn NeuronArray
			iArray = 0
			For Local iInput:NeuronInput = EachIn iNeuron.Inputs
				iInput.Value = Float(InputArray[iArray])
				iArray:+1
			Next
			'DumpNeuronStats(iNeuron)
		Next
	End Method
	
	
	Method LearnFromErrorsArray(ErrorArray:Float[])
		Local iArray:Int = 0
		
		For Local iNeuron:Neuron = EachIn NeuronArray
			iNeuron.LearnFromKnownError(ErrorArray[iArray])
			iArray:+1
		Next
	End Method
	
	
	Method CalculateToArray:Float[]()
		Local ReturnArray:Float[]
		Local iArray:Int = 0
		
		For Local iNeuron:Neuron = EachIn NeuronArray
			ReturnArray = ReturnArray[..iArray+1]
			ReturnArray[iArray] = iNeuron.CalculateOutput()
			'DumpNeuronStats(iNeuron)
			iArray:+1
		Next
		
		Return ReturnArray
	End Method
		
End Type


Function Sigmoid:Float(Value:Float)
	Return 1/(1+(2.718282^-Value))
End Function

Function SigmoidDerivative:Float(Value:Float)
	Return Value * (1 - Value)
End Function

Function DumpNeuronStats(NeuronObject:Neuron)
	Print "DumpNeuronStats():"
	For Local iNeuronInput:NeuronInput = EachIn NeuronObject.Inputs
		Print iNeuronInput.Value + " / " + iNeuronInput.Weight
	Next
End Function