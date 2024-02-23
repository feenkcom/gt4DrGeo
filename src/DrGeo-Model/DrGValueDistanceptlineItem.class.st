Class {
	#name : #DrGValueDistanceptlineItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueDistanceptlineItem >> adaptiveDescriptiveName [
	^ 'This point-line distance %1' translated
]

{ #category : #'xml writing' }
DrGValueDistanceptlineItem >> nodeType [
	^#'distance_pt_line'
]

{ #category : #updating }
DrGValueDistanceptlineItem >> update [
	self doParentsExist ifTrue:
		[value := ((parents first point - parents second origin) 
					dotProduct: parents second direction normal) abs].

]
