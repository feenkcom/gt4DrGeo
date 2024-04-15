Class {
	#name : #DrGValueArclengthItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueArclengthItem >> adaptiveDescriptiveName [
	^ 'This arc length %1' translated
]

{ #category : #'xml writing' }
DrGValueArclengthItem >> nodeType [
	^#'arc_length'
]

{ #category : #updating }
DrGValueArclengthItem >> update [
	self doParentsExist ifTrue: 
		[value := parents first length abs * parents first radius].

]
