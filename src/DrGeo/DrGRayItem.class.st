Class {
	#name : #DrGRayItem,
	#superclass : #DrGDirectionItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGRayItem >> abscissaOf: aPoint [ 
	| v |
	[ v := vector normalized ] on: ZeroDivide do: [ v := 0 @ 0 ].
	^(aPoint - origin dotProduct: v) arcTan 
		* DrGDirectionItem inv2Pi
]

{ #category : #private }
DrGRayItem >> adaptiveDescriptiveName [
	^ 'This half-line %1' translated
]

{ #category : #accessing }
DrGRayItem >> basicType [
	^#ray
]

{ #category : #computing }
DrGRayItem >> clone [
	|pointA pointB clone|
	pointA := DrGPointFreeItem newWith: {self origin + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {self origin + self direction + (0.2@0.2)}.
	clone := DrGRay2ptsItem newWith: {pointA . pointB}.
	^ {pointA . pointB . clone}
]

{ #category : #computing }
DrGRayItem >> closestPointTo: aPoint [
	|unitVector abscissa|
	[ unitVector := vector normalized ] on: ZeroDivide do: [ unitVector := 0 @ 0 ].	
	abscissa := aPoint - origin dotProduct: unitVector.
	abscissa < 0 ifTrue: [abscissa := 0].
	^origin + (abscissa * unitVector)
]

{ #category : #testing }
DrGRayItem >> contains: aPoint [
	^ ((vector crossProduct: (aPoint - origin)) closeTo: 0) 
		and: [((aPoint - origin) dotProduct: vector) >= 0]
]

{ #category : #computing }
DrGRayItem >> intersectionWith: aCurveItem flag: aFlag [
|aPoint|
	aCurveItem isLineItem 
		ifTrue: 
			[aPoint := self intersectionWithDirection: aCurveItem.
			(self contains: aPoint)
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	(aCurveItem isSegmentItem or: [aCurveItem isRayItem])
		ifTrue:
			[aPoint := self intersectionWithDirection: aCurveItem.
			((self contains: aPoint) and: [aCurveItem contains: aPoint])
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	(aCurveItem isCircleItem
		or: [aCurveItem isArcItem])
		ifTrue:
			[^aCurveItem intersectionWith: self flag: aFlag].
]

{ #category : #'testing-model' }
DrGRayItem >> isRayItem [
	^ true
]

{ #category : #accessing }
DrGRayItem >> morphClass [ 
	^DrGRayMorph
]

{ #category : #computing }
DrGRayItem >> pointAt: anAbscissa [
	|point|
	anAbscissa = 1 
		ifTrue:
			[|infX infY|
			point := vector.
			point x > 0 
				ifTrue: [infX := Float infinity] 
				ifFalse: [infX := 0 - Float infinity].
			point y > 0
				ifTrue: [infY :=	Float infinity] 
				ifFalse: [infY := 0 - Float infinity].
			point := infX@infY]
		ifFalse:
			[anAbscissa = 0
				ifTrue: [point := origin]
				ifFalse:
					[| v |
					[ v := vector normalized ] on: ZeroDivide do: [ v := 0 @ 0 ].
					point := origin + ((anAbscissa * Float halfPi) tan * v)]].
	^point

]

{ #category : #printing }
DrGRayItem >> printOn: aStream [ 
	self printType: DrGRayBuilder title on: aStream.
	self printCoordinates: origin on: aStream
]
