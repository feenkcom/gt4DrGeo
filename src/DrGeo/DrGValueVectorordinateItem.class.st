Class {
	#name : #DrGValueVectorordinateItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueVectorordinateItem >> adaptiveDescriptiveName [
	^ 'This vector ordinate %1' translated
]

{ #category : #'xml writing' }
DrGValueVectorordinateItem >> nodeType [ 
	^ #'vector_ordinate'
]

{ #category : #updating }
DrGValueVectorordinateItem >> update [
	self doParentsExist ifTrue: [
		value := parents first direction y]
]
