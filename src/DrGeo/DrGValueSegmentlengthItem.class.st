Class {
	#name : #DrGValueSegmentlengthItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueSegmentlengthItem >> adaptiveDescriptiveName [
	^ 'This segment length %1' translated
]

{ #category : #'xml writing' }
DrGValueSegmentlengthItem >> nodeType [
	^#'segment_length'
]

{ #category : #updating }
DrGValueSegmentlengthItem >> update [
	self doParentsExist ifTrue:
		[value := parents first direction r].

]
