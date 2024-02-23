Class {
	#name : #DrGLinePerpendicularItem,
	#superclass : #DrGLineParallelItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGLinePerpendicularItem >> adaptiveDescriptiveName [
	^ 'This perpendicular line %1' translated
]

{ #category : #'xml writing' }
DrGLinePerpendicularItem >> nodeType [
	^#perpendicular
]

{ #category : #updating }
DrGLinePerpendicularItem >> update [
	self doParentsExist ifTrue:
		[self direction: (parents at: 1) normal.
		parents size = 2 	ifTrue: [self origin: (parents at: 2) point]].

]
