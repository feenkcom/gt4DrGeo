Class {
	#name : #DrGPolygonItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'points',
		'length',
		'sidesLength'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGPolygonItem >> abscissaOf: aPoint [
 ^ (self closestPointInfoTo: aPoint) second
]

{ #category : #computing }
DrGPolygonItem >> abscissaOf: aPoint in: side [
"To speed up calculs, we better know the side where is the point"
|distanceToPoint|
	distanceToPoint := 0.
	1 to: side - 1 do: [:i |
		distanceToPoint := distanceToPoint + (sidesLength at: i)].
	distanceToPoint := distanceToPoint + (aPoint dist: (points at: side)).
	^ distanceToPoint / length
]

{ #category : #private }
DrGPolygonItem >> adaptiveDescriptiveName [
| sides |
	sides := self points size.
	sides = 3 ifTrue: [^ 'This triangle %1' translated].
	sides = 4 ifTrue: [^ 'This quadrilateral %1' translated].
	^ 'This polygon %1' translated
]

{ #category : #accessing }
DrGPolygonItem >> basicType [
	^#polygon
]

{ #category : #computing }
DrGPolygonItem >> clone [
	|clonedPoints clone|
	clonedPoints := points collect: [:aPoint | DrGPointFreeItem newWith: {aPoint + (0.2@0.2)}].
	clone := DrGPolygonNptsItem newWith: clonedPoints.
	^ (OrderedCollection withAll: clonedPoints) add: clone; yourself
]

{ #category : #computing }
DrGPolygonItem >> closestPointInfoTo: aPoint [
"the closest point on the polygon and its curvilinear abscissa in [0 ; 1]"
|closestPoint smallestDistance side|
	smallestDistance := 1e9.
	points withIndexDo: [:p :i | | distance point |
		point := self closestPointTo: aPoint 
					from: p
					to:  (points at: i + 1 ifAbsent: [points at: 1]).
		distance := aPoint dist: point.
		distance < smallestDistance
			ifTrue:
				[smallestDistance := distance.
				closestPoint := point.
				side := i]].
	^{closestPoint . self abscissaOf: closestPoint in: side}
]

{ #category : #computing }
DrGPolygonItem >> closestPointTo: aPoint [
	^ (self closestPointInfoTo: aPoint) first
]

{ #category : #computing }
DrGPolygonItem >> closestPointTo: aPoint from: pointA to: pointB [
"the closest point to aPoint in [AB]"
|abscissa vector squareNorm|
	vector := pointB - pointA.
	squareNorm := vector dotProduct: vector.
	abscissa := (aPoint - pointA) dotProduct: vector.
	abscissa < 0 ifTrue: [abscissa := 0].
	abscissa > squareNorm ifTrue: 
		[abscissa := squareNorm].
	^ pointA + (abscissa * vector / squareNorm asFloat)
]

{ #category : #updating }
DrGPolygonItem >> computeLength [
	length := 0.
	sidesLength := OrderedCollection new.
	points  withIndexDo: [:p :i |
		length := length + 
			(sidesLength add: (p dist: (points at: i + 1 ifAbsent: [points at: 1])))].
	^length
]

{ #category : #testing }
DrGPolygonItem >> isCloneable [
	^ true
]

{ #category : #'testing-model' }
DrGPolygonItem >> isCurveItem [ 
	^ true
]

{ #category : #'testing-model' }
DrGPolygonItem >> isGeometricItem [
	^true
]

{ #category : #'testing-model' }
DrGPolygonItem >> isIntersectableItem [
	^ false
]

{ #category : #'testing-model' }
DrGPolygonItem >> isPolygonItem [
	^true
]

{ #category : #accessing }
DrGPolygonItem >> length [
	^length 
]

{ #category : #accessing }
DrGPolygonItem >> morphClass [ 
	^ DrGPolygonMorph
]

{ #category : #computing }
DrGPolygonItem >> pointAt: anAbscissa [
|distanceToPoint leftDistanceToPoint sum|
	distanceToPoint := leftDistanceToPoint := anAbscissa * length.
	sum := 0.
	sidesLength withIndexDo: [:s :i |
		sum := sum + s.
		sum >= distanceToPoint 
			ifTrue:
				["point is on this side"
				|pointA pointB vector|
				pointA := points at: i.
				pointB := points at: i + 1 ifAbsent: [points at: 1].
				pointA = pointB 
					ifTrue: [vector := 0@0]
					ifFalse:	[vector := (pointB - pointA) / (pointA dist: pointB)].
				^pointA + (vector * leftDistanceToPoint)].
		leftDistanceToPoint := leftDistanceToPoint - s]
]

{ #category : #accessing }
DrGPolygonItem >> points [
	^points
]

{ #category : #printing }
DrGPolygonItem >> printOn: aStream [ 
	self printType: DrGPolygonBuilder title on: aStream.
	aStream nextPutAll: ' edges=' translated;
		nextPutAll: points size printString
]

{ #category : #accessing }
DrGPolygonItem >> sidesLength [
	^ sidesLength 
]
