"
A DrGArcItem is an abstract arc item.

Instance Variables
	center:		the arc center
	length:		the arc angle, it can be negative
	origin:		the starting angle of the arc
	radius:		its radius
"
Class {
	#name : #DrGArcItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'radius',
		'center',
		'origin',
		'length'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGArcItem >> abscissaOf: aPoint [
	^(self angleOf: aPoint) / length
]

{ #category : #private }
DrGArcItem >> adaptiveDescriptiveName [
	^ 'This Arc Circle %1' translated
]

{ #category : #private }
DrGArcItem >> angleOf: aPoint [
	"Compute the angle position of aPoint in the circle"
	| angleM pointM |
	pointM := aPoint - center.
	angleM := (pointM y asFloat arcTan: pointM x) - origin.
	length > 0
		ifTrue: [
			angleM < 0 ifTrue: [ angleM := angleM + Float twoPi ].
			angleM := angleM min: length ]
		ifFalse: [
			angleM > 0 ifTrue: [ angleM := angleM - Float twoPi ].
			angleM := angleM max: length ].
	^ angleM
]

{ #category : #accessing }
DrGArcItem >> basicType [
	^#arc
]

{ #category : #accessing }
DrGArcItem >> center [
	^center
]

{ #category : #accessing }
DrGArcItem >> center: aPoint [
	center := aPoint 
]

{ #category : #computing }
DrGArcItem >> clone [
	|pointA pointB pointC clone|
	pointA := DrGPointFreeItem newWith: {(self pointAt: 0) + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {(self pointAt: 0.5) + (0.2@0.2)}.
	pointC := DrGPointFreeItem newWith: {(self pointAt: 1) + (0.2@0.2)}.
	clone := DrGArc3ptsItem newWith: {pointA . pointB . pointC}.
	^ {pointA . pointB . pointC. clone}
]

{ #category : #computing }
DrGArcItem >> closestPointTo: aPoint [
	| angle |
	angle := self angleOf: aPoint.
	^center + (radius * ((origin + angle) cos @ (origin + angle) sin))
]

{ #category : #testing }
DrGArcItem >> contains: aPoint [ 
	| angleM pointM |
	((center dist: aPoint) closeTo: radius) ifFalse: [^false].
	pointM := aPoint - center.
	angleM := (pointM y asFloat arcTan: pointM x) - origin.
	^ length > 0 
		ifTrue: 
			[angleM < 0 ifTrue: [angleM := angleM + Float twoPi].
			length >= angleM]
		ifFalse: 
			[angleM > 0 ifTrue: [angleM := angleM - Float twoPi].
			length <= angleM]
]

{ #category : #computing }
DrGArcItem >> intersectionWith: aCurveItem flag: aFlag [
	| aPoint |
	aCurveItem isLineItem 
		ifTrue: 
			[aPoint := self intersectionWithDirection: aCurveItem flag: aFlag.
			aPoint ifNil: [^nil].
			(self contains: aPoint)
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	(aCurveItem isRayItem or: [aCurveItem isSegmentItem])
		ifTrue:
			[aPoint := self intersectionWithDirection: aCurveItem flag: aFlag.
			aPoint ifNil: [^nil].
			((self contains: aPoint) and: [aCurveItem contains: aPoint])
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	aCurveItem isCircleItem
		ifTrue:
			[aPoint := self intersectionWithCircle: aCurveItem flag: aFlag.
			aPoint ifNil: [^nil].
			(self contains: aPoint)
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	aCurveItem isArcItem
		ifTrue:
			[aPoint := self intersectionWithCircle: aCurveItem flag: aFlag.
			aPoint ifNil: [^nil].
			((self contains: aPoint) and: [aCurveItem contains: aPoint])
				ifTrue: [^aPoint]
				ifFalse: [^nil]].

]

{ #category : #computing }
DrGArcItem >> intersectionWithCircle: aCircleOrArcItem flag: aFlag [ 
	| circleItem |
	circleItem := (DrGCircleItem new)
				center: self center;
				radius: self radius.
	^circleItem intersectionWithCircle: aCircleOrArcItem flag: aFlag
]

{ #category : #computing }
DrGArcItem >> intersectionWithDirection: aDirectionItem flag: aFlag [ 
	| circleItem |
	circleItem := (DrGCircleItem new)
				center: self center;
				radius: self radius.
	^circleItem intersectionWithDirection: aDirectionItem flag: aFlag
]

{ #category : #'testing-model' }
DrGArcItem >> isArcItem [
	^true
]

{ #category : #testing }
DrGArcItem >> isCloneable [ 
	^ true
]

{ #category : #'testing-model' }
DrGArcItem >> isCurveItem [
	^true
]

{ #category : #'testing-model' }
DrGArcItem >> isGeometricItem [
	^ true
]

{ #category : #accessing }
DrGArcItem >> length [
"the arc length, in radius, can be negative"
	^length
]

{ #category : #accessing }
DrGArcItem >> length: aFloat [
	length := aFloat 
]

{ #category : #accessing }
DrGArcItem >> morphClass [ 
	^DrGArcMorph
]

{ #category : #accessing }
DrGArcItem >> origin [
	^origin
]

{ #category : #accessing }
DrGArcItem >> origin: aFloat [
	origin := aFloat 
]

{ #category : #computing }
DrGArcItem >> pointAt: anAbscissa [
	|angle|
	angle := origin + (anAbscissa * length).
	^center + (radius * (angle cos @ angle sin))
	
]

{ #category : #printing }
DrGArcItem >> printOn: aStream [
	self printType: DrGArcBuilder title on: aStream.
	aStream nextPut: Character space.
	self printDecimal: (length * radius ) abs on: aStream.
]

{ #category : #accessing }
DrGArcItem >> radius [
	^radius
]

{ #category : #accessing }
DrGArcItem >> radius: aFloat [
	radius := aFloat
]
