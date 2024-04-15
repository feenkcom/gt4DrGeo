Class {
	#name : #DrGValueSlopeItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueSlopeItem >> adaptiveDescriptiveName [
	^ 'This line slope %1' translated
]

{ #category : #'xml writing' }
DrGValueSlopeItem >> nodeType [
	^#slope
]

{ #category : #updating }
DrGValueSlopeItem >> update [
	|v|
	self doParentsExist ifTrue:
		[v := parents first direction.
		v x= 0 ifTrue: [exist := false]
		ifFalse: [value := v y / v x.]].

]
