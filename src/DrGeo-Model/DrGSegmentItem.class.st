Class {
	#name : #DrGSegmentItem,
	#superclass : #DrGDirectionItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGSegmentItem >> abscissaOf: aPoint [
	^((aPoint - origin) dotProduct: vector) / (vector dotProduct: vector)
]

{ #category : #private }
DrGSegmentItem >> adaptiveDescriptiveName [
	^ 'This segment %1' translated
]

{ #category : #accessing }
DrGSegmentItem >> basicType [
	^#segment
]

{ #category : #computing }
DrGSegmentItem >> clone [
	|pointA pointB clone|
	pointA := DrGPointFreeItem newWith: {self extremity1 + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {self extremity2 + (0.2@0.2)}.
	clone := DrGSegment2ptsItem newWith: {pointA . pointB}.
	^ {pointA . pointB . clone}
]

{ #category : #computing }
DrGSegmentItem >> closestPointTo: aPoint [
	|abscissa squareNorm|
	abscissa := (aPoint - origin) dotProduct: vector.
	squareNorm := vector dotProduct: vector.
	abscissa := abscissa min: squareNorm max: 0.
	^ [origin + (abscissa * vector / squareNorm asFloat)] on: ZeroDivide do: [origin]
]

{ #category : #testing }
DrGSegmentItem >> contains: aPoint [
|anAbscissa|
	^ ((vector crossProduct: (aPoint - origin)) closeTo: 0) 
		and: [(anAbscissa := self abscissaOf: aPoint) >= 0
			and: [anAbscissa <= 1]]
]

{ #category : #accessing }
DrGSegmentItem >> extremity1 [
	^ origin 
]

{ #category : #accessing }
DrGSegmentItem >> extremity2 [
	^ self pointAt: 1
]

{ #category : #computing }
DrGSegmentItem >> intersectionWith: aCurveItem flag: aFlag [
|aPoint|
	aCurveItem isLineItem
		ifTrue:
			[aPoint := self intersectionWithDirection: aCurveItem.
			aPoint ifNil: [^nil].
			(self contains: aPoint)
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	aCurveItem isSegmentItem
		ifTrue:
			[aPoint := self intersectionWithDirection: aCurveItem.
			aPoint ifNil: [^nil].
			((self contains: aPoint) and: [aCurveItem contains: aPoint])
				ifTrue: [^aPoint]
				ifFalse: [^nil]].
	(aCurveItem isRayItem 
		or: [aCurveItem isCircleItem
			or: [aCurveItem isArcItem]])
		ifTrue:
			[^aCurveItem intersectionWith: self flag: aFlag].
			
]

{ #category : #'as yet unclassified' }
DrGSegmentItem >> isSegmentItem [
	^ true
]

{ #category : #accessing }
DrGSegmentItem >> length [
	^ self direction r
]

{ #category : #accessing }
DrGSegmentItem >> middle [
	^ self extremity1 + self extremity2 / 2
]

{ #category : #accessing }
DrGSegmentItem >> morphClass [ 
	^DrGSegmentMorph
]

{ #category : #computing }
DrGSegmentItem >> pointAt: anAbscissa [
	^ origin + (anAbscissa * vector)
]

{ #category : #printing }
DrGSegmentItem >> printOn: aStream [ 
	self printType: DrGSegmentBuilder title on: aStream.
	aStream nextPut: Character space.
	self printDecimal: self length on: aStream.
]
