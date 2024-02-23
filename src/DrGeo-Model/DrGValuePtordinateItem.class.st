Class {
	#name : #DrGValuePtordinateItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValuePtordinateItem >> adaptiveDescriptiveName [
	^ 'This point ordinate %1' translated
]

{ #category : #'xml writing' }
DrGValuePtordinateItem >> nodeType [ 
	^#'pt_ordinate'
]

{ #category : #updating }
DrGValuePtordinateItem >> update [
	self doParentsExist ifTrue: [
		value := parents first point y]
]
