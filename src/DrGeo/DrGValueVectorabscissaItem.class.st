Class {
	#name : #DrGValueVectorabscissaItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueVectorabscissaItem >> adaptiveDescriptiveName [
	^ 'This vector abscissa %1' translated
]

{ #category : #'xml writing' }
DrGValueVectorabscissaItem >> nodeType [ 
	^#'vector_abscissa'
]

{ #category : #updating }
DrGValueVectorabscissaItem >> update [
	self doParentsExist ifTrue: [
		value := parents first direction x]
]
