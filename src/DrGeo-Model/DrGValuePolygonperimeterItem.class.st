Class {
	#name : #DrGValuePolygonperimeterItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValuePolygonperimeterItem >> adaptiveDescriptiveName [
	^ 'This polygon perimeter %1' translated
]

{ #category : #'xml writing' }
DrGValuePolygonperimeterItem >> nodeType [
	^#'polygon_perimeter'
]

{ #category : #updating }
DrGValuePolygonperimeterItem >> update [
	self doParentsExist ifTrue:
		[value := parents first length].

]
