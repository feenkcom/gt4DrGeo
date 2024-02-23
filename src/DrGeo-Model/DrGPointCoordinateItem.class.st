Class {
	#name : #DrGPointCoordinateItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPointCoordinateItem >> editPropertyIn: presenter [
	| holder |
	holder := ValueHolder with: point.
	holder action: [:newPoint | presenter domain propertyCommandFor: self with: newPoint].
	^ PointEntryPanel open: holder label: 'Edit the coordinates' translated.
]

{ #category : #'testing-model' }
DrGPointCoordinateItem >> isConstrainedPointItem [
	^ true
]

{ #category : #'xml writing' }
DrGPointCoordinateItem >> nodeType [
	^#Coordinate
]

{ #category : #updating }
DrGPointCoordinateItem >> update [
	self doParentsExist ifTrue:
		[self point: parents first valueItem @ parents second valueItem]. 

]
