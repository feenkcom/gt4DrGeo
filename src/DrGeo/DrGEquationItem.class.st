Class {
	#name : #DrGEquationItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGEquationItem >> adaptiveDescriptiveName [
	^ 'This equation %1' translated
]

{ #category : #accessing }
DrGEquationItem >> basicType [
	^#equation
]

{ #category : #accessing }
DrGEquationItem >> equation [
"a string representing the equation"
	^ ''
]

{ #category : #'as yet unclassified' }
DrGEquationItem >> isEquationItem [ 
	^ true
]

{ #category : #'testing-model' }
DrGEquationItem >> isValueItem [ 
	^ false
]

{ #category : #testing }
DrGEquationItem >> isVerifiedBy: aPoint [
	self subclassResponsibility 
]

{ #category : #printing }
DrGEquationItem >> printOn: aStream [
	self printType: 'Equation' translated on: aStream.
	self printValueOn: aStream 
]

{ #category : #printing }
DrGEquationItem >> printValueOn: aStream [ 
	aStream nextPutAll: value
]

{ #category : #accessing }
DrGEquationItem >> valueItem [
	^ self equation 
]
