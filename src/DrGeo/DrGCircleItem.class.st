"
Instance variables radius and center are used to cache these values
"
Class {
	#name : #DrGCircleItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'radius',
		'center'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGCircleItem >> abscissaOf: aPoint [ 
	| angle vector |
	vector := aPoint - self center.
	angle := vector y arcTan: vector x.
	angle < 0 ifTrue: [angle := angle + Float twoPi].
	^angle * 0.5 * DrGDirectionItem invPi
]

{ #category : #private }
DrGCircleItem >> adaptiveDescriptiveName [
	^ 'This circle %1' translated
]

{ #category : #accessing }
DrGCircleItem >> basicType [
	^#circle
]

{ #category : #accessing }
DrGCircleItem >> center [
	^center
]

{ #category : #accessing }
DrGCircleItem >> center: aPoint [
	center := aPoint 
]

{ #category : #computing }
DrGCircleItem >> clone [
	|pointA pointB clone|
	pointA := DrGPointFreeItem newWith: {self center + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {(self pointAt: 0) + (0.2@0.2)}.
	clone := DrGCircle2ptsItem newWith: {pointA . pointB}.
	^ {pointA . pointB . clone}
]

{ #category : #accessing }
DrGCircleItem >> closestPointTo: aPoint [
| v | 
	[v := (aPoint - self center) normalized] on: ZeroDivide do: [ v := 0 @ 0 ].
	^self center + (self radius * v)
]

{ #category : #testing }
DrGCircleItem >> contains: aPoint [
	^ (center dist: aPoint) closeTo: radius  
]

{ #category : #computing }
DrGCircleItem >> intersectionWith: aCurveItem flag: aFlag [
|aPoint|
	aCurveItem isLineItem 
		ifTrue: [^self intersectionWithDirection: aCurveItem  flag: aFlag].
	(aCurveItem isSegmentItem or: [aCurveItem isRayItem])
		ifTrue:
			[aPoint := self intersectionWithDirection: aCurveItem  flag: aFlag.
			aPoint ifNil: [^nil].
			(aCurveItem contains: aPoint)
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	aCurveItem isCircleItem
		ifTrue: [^self intersectionWithCircle: aCurveItem flag: aFlag].
	aCurveItem isArcItem
		ifTrue: [^aCurveItem intersectionWith: self flag: aFlag]
]

{ #category : #computing }
DrGCircleItem >> intersectionWithCircle: aCircleItem flag: aFlag [ 
	| directionItem aVector aRadius x d |
	directionItem := DrGDirectionItem new.
	aVector := aCircleItem center - center.
	aRadius := aCircleItem radius.
	d := aVector dotProduct: aVector.
	d = 0 ifTrue: [ ^ nil ].
	x := (d + radius squared - aRadius squared) / (2 * d).
	directionItem direction: aVector normal.
	directionItem origin: x * aVector + center.
	^self intersectionWithDirection: directionItem flag: aFlag
]

{ #category : #computing }
DrGCircleItem >> intersectionWithDirection: aDirectionItem flag: aFlag [
|a b c d k vector|
	vector := aDirectionItem direction.
	a := vector dotProduct: vector.
	b := vector dotProduct: (aDirectionItem origin - self center).
	c := (aDirectionItem origin squaredDistanceTo: self center) - self radius squared.
	d := b squared - (a * c).
	(d < 0 or: [a = 0]) ifTrue: [^ nil].
	k := (b negated + (aFlag * d sqrt)) / a.
	^ aDirectionItem origin + (k * vector)
]

{ #category : #'testing-model' }
DrGCircleItem >> isCircleItem [
	^ true
]

{ #category : #testing }
DrGCircleItem >> isCloneable [
	^ true
]

{ #category : #'testing-model' }
DrGCircleItem >> isCurveItem [
	^ true
]

{ #category : #'testing-model' }
DrGCircleItem >> isGeometricItem [
	^ true
]

{ #category : #accessing }
DrGCircleItem >> morphClass [ 
	^DrGCircleMorph
]

{ #category : #accessing }
DrGCircleItem >> pointAt: anAbscissa [
	|angle|
	angle := Float twoPi * anAbscissa.
	^ (Point x: angle cos y: angle sin) * self radius + self center.
]

{ #category : #printing }
DrGCircleItem >> printOn: aStream [ 
	self printType: DrGCircleBuilder title on: aStream .
	aStream nextPut: Character space.
	self printCoordinates: center on: aStream.
	aStream nextPut: Character space.
	self printDecimal: radius  on: aStream
]

{ #category : #accessing }
DrGCircleItem >> radius [
	^radius
]

{ #category : #accessing }
DrGCircleItem >> radius: aFlaot [
	radius := aFlaot 
]
