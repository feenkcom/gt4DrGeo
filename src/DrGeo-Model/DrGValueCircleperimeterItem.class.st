Class {
	#name : #DrGValueCircleperimeterItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueCircleperimeterItem >> adaptiveDescriptiveName [
	^ 'This circle perimeter %1' translated
]

{ #category : #'xml writing' }
DrGValueCircleperimeterItem >> nodeType [
	^#'circle_perimeter'
]

{ #category : #updating }
DrGValueCircleperimeterItem >> update [
	self doParentsExist ifTrue:
		[value := parents first radius * Float twoPi].

]
