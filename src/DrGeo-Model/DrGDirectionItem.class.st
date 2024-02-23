Class {
	#name : #DrGDirectionItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'origin',
		'vector'
	],
	#classVars : [
		'Inv2Pi',
		'InvPi'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #'class initialization' }
DrGDirectionItem class >> initialize [
	InvPi := 0.31830988618379067154.
	Inv2Pi := 0.636619772367581.
]

{ #category : #constants }
DrGDirectionItem class >> inv2Pi [
	^Inv2Pi
]

{ #category : #constants }
DrGDirectionItem class >> invPi [
	^InvPi
]

{ #category : #accessing }
DrGDirectionItem >> basicType [ 
	^#direction
]

{ #category : #accessing }
DrGDirectionItem >> direction [
	^vector 
]

{ #category : #accessing }
DrGDirectionItem >> direction: aDirection [
	vector := aDirection 
]

{ #category : #updating }
DrGDirectionItem >> homothetyUpdate [
|center|
	self doParentsExist ifTrue:
		[center := parents second point.
		origin := center +
			(parents third valueItem * (parents first origin - center)).
		vector := parents first direction * parents third valueItem].
]

{ #category : #computing }
DrGDirectionItem >> intersectionWithDirection: aDirectionItem [
| det c1 c2 direction |
	direction := aDirectionItem  direction.
	det := vector crossProduct: direction.
	(det closeTo: 0) ifTrue: [^ nil].
	c1 := origin crossProduct: vector.
	c2 := aDirectionItem  origin crossProduct: direction.
	^ ((c2 * vector x - (c1 * direction x) ) / det) @ ((vector y * c2 - (direction y * c1)) / det)
]

{ #category : #testing }
DrGDirectionItem >> isCloneable [
	^ true
]

{ #category : #testing }
DrGDirectionItem >> isCollinearWith: aDirection [ 
	^ (vector crossProduct: aDirection direction)
		closeTo: 0
]

{ #category : #'testing-model' }
DrGDirectionItem >> isCurveItem [
	^ true
]

{ #category : #'testing-model' }
DrGDirectionItem >> isDirectionItem [
	^ true
]

{ #category : #'testing-model' }
DrGDirectionItem >> isGeometricItem [
	^ true
]

{ #category : #accessing }
DrGDirectionItem >> normal [
	^ vector normal
]

{ #category : #accessing }
DrGDirectionItem >> origin [
	^origin 
]

{ #category : #accessing }
DrGDirectionItem >> origin: anOrigin [
	origin := anOrigin 
]

{ #category : #printing }
DrGDirectionItem >> printOn: aStream [ 	
	self printCoordinates: origin  on: aStream.
	aStream nextPutAll: '->'.
	self printCoordinates: vector on: aStream 

]

{ #category : #updating }
DrGDirectionItem >> reflexionUpdate [
	self doParentsExist ifTrue:
		[self origin: (parents first origin
							reflexionBy: parents second origin 
							direction: parents second direction).
		self direction: (parents first direction 
								vectorReflexionBy: parents second direction)].
]

{ #category : #updating }
DrGDirectionItem >> rotationUpdate [
	self doParentsExist ifTrue:
		[origin := parents first origin
			rotateBy: parents third valueItem negated
			about: parents second point.
		vector := parents first direction 
			rotateVector: parents third valueItem].
]

{ #category : #updating }
DrGDirectionItem >> symmetryUpdate [
	self doParentsExist ifTrue:
		[self origin: (2 * parents second point) - parents first origin.
		self direction: parents first direction negated].
]

{ #category : #updating }
DrGDirectionItem >> translationUpdate [
	self doParentsExist ifTrue: 
		[self origin: parents first origin + parents second direction.
		self direction: parents first direction].
]

{ #category : #updating }
DrGDirectionItem >> update [
	self doParentsExist ifTrue:
		["default behavior for segment, line and ray defined by 2 points"
		self origin: (parents at: 1) point.
		self direction: (parents at: 2) point - (self origin).
		self direction =( 0@0) ifTrue: [exist := false]].
]
