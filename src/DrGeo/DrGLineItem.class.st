Class {
	#name : #DrGLineItem,
	#superclass : #DrGDirectionItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGLineItem >> abscissaOf: aPoint [ 
	| v | 
	[ v := vector normalized ] on: ZeroDivide do: [ v := 0 @ 0 ].
	^(aPoint - origin dotProduct: v) arcTan 
		* DrGDirectionItem invPi + 0.5
]

{ #category : #private }
DrGLineItem >> adaptiveDescriptiveName [
	^ 'This line %1' translated
]

{ #category : #accessing }
DrGLineItem >> basicType [
	^#line
]

{ #category : #computing }
DrGLineItem >> clone [
	|pointA pointB clone|
	pointA := DrGPointFreeItem newWith: {self origin + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {self origin + self direction + (0.2@0.2)}.
	clone := DrGLine2ptsItem newWith: {pointA . pointB}.
	^ {pointA . pointB . clone}
]

{ #category : #computing }
DrGLineItem >> closestPointTo: aPoint [
	|unitVector|
	[ unitVector := vector normalized ] on: ZeroDivide do: [ unitVector := 0 @ 0 ].
	^origin + (((aPoint - origin) dotProduct: unitVector) * unitVector)
]

{ #category : #computing }
DrGLineItem >> contains: aPoint [
	^ (vector crossProduct: (aPoint - origin)) closeTo: 0
]

{ #category : #computing }
DrGLineItem >> intersectionWith: aCurveItem flag: aFlag [
	aCurveItem isLineItem 
		ifTrue: [^ self intersectionWithDirection: aCurveItem].
	(aCurveItem isSegmentItem 
		or: [aCurveItem isRayItem 
			or: [aCurveItem isCircleItem
				or: [aCurveItem isArcItem]]])
			ifTrue: [^ aCurveItem intersectionWith: self flag: aFlag].
]

{ #category : #'testing-model' }
DrGLineItem >> isLineItem [
	^ true
]

{ #category : #accessing }
DrGLineItem >> morphClass [ 
	^ DrGLineMorph
]

{ #category : #computing }
DrGLineItem >> pointAt:	anAbscissa [
	|point abscissa v |
	"In the interval [-0.5 ; 0.5]"
	abscissa := anAbscissa - 0.5.
	(abscissa = 0.5 or: [abscissa = -0.5]) 
		ifTrue:
			[point := abscissa * vector.
			point x > 0 
				ifTrue: [point := Float infinity @ point y] 
				ifFalse: [point := 0 - Float infinity @ point y].
			point y > 0
				ifTrue: [point := point x @ Float infinity] 
				ifFalse: [point := point x @ (0 - Float infinity)]]
		ifFalse:
			[abscissa := abscissa * Float pi.
			[ v := vector normalized ] on: ZeroDivide do: [ v := 0 @ 0 ].
			point := origin + (abscissa tan * v)].
	^point
]

{ #category : #printing }
DrGLineItem >> printOn: aStream [ 
	self printType: DrGLineBuilder title on: aStream.
]
