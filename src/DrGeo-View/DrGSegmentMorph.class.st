Class {
	#name : #DrGSegmentMorph,
	#superclass : #DrGCurveStraightMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #drawing }
DrGSegmentMorph >> drawCircleOn: aCanvas [ 
	| center |
	center := vertices first + vertices second / 2.0.
	aCanvas strokeWidth: borderWidth color: borderColor do: [
		aCanvas circleCenter: center radius:  2 + borderWidth]
]

{ #category : #drawing }
DrGSegmentMorph >> drawDiscOn: aCanvas [ 
	| center |
	center := vertices first + vertices second / 2.0.
	aCanvas fillColor:  borderColor do: [
		aCanvas circleCenter: center radius: 2 + borderWidth]
]

{ #category : #drawing }
DrGSegmentMorph >> drawMark1On: aCanvas [ 
	|center vector u n startPoint endPoint |
	startPoint := vertices at: 1.
	endPoint := vertices at: 2.
	(startPoint squaredDistanceTo: endPoint) < borderWidth squared ifTrue: [^ self].
	center := startPoint + endPoint / 2.0.
	vector := endPoint - startPoint.
	[u := vector normalized] on: ZeroDivide do: [u := 0@1].
	n := u y @ u x negated.
	vector :=  (u + n ) normalized * (borderWidth + 1 * 3).
	aCanvas 
		line: center - vector
		to: center + vector
		width: borderWidth  
		color: borderColor.
]

{ #category : #drawing }
DrGSegmentMorph >> drawMark2On: aCanvas [ 
	|center vector u n startPoint endPoint |
	startPoint := vertices at: 1.
	endPoint := vertices at: 2.
	(startPoint squaredDistanceTo: endPoint) < (borderWidth * 4) squared ifTrue: [^ self].
	vector := endPoint - startPoint.
	[u := vector normalized] on: ZeroDivide do: [u := 0@1].
	n := u y @ u x negated.
	vector :=  (u + n ) normalized * (borderWidth + 1 * 3).
	center := (startPoint + endPoint / 2) - (u * (borderWidth * 1.5)).
	2 timesRepeat: [
		aCanvas line: center - vector to: center + vector width: borderWidth color: borderColor.
		center := center + (u * (borderWidth  * 3))].
]

{ #category : #drawing }
DrGSegmentMorph >> drawMark3On: aCanvas [ 
	|center vector u n startPoint endPoint |
	startPoint := vertices at: 1.
	endPoint := vertices at: 2.
	(startPoint squaredDistanceTo: endPoint) < (borderWidth * 7) squared ifTrue: [^ self].
	vector := endPoint - startPoint.
	[u := vector normalized] on: ZeroDivide do: [u := 0@1].
	n := u y @ u x negated.
	vector :=  (u + n ) normalized * (borderWidth + 1 * 3).
	center := (startPoint + endPoint / 2) - (u * (borderWidth * 3)).
	3 timesRepeat: [
		aCanvas line: center - vector to: center + vector width: borderWidth color: borderColor.
		center := center + (u * (borderWidth  * 3))].
]

{ #category : #drawing }
DrGSegmentMorph >> drawMarkOn: aCanvas [
	|mark|
	mark := self style mark.
	mark == #none ifTrue: [^self].
	mark == #mark1 ifTrue: [^ self drawMark1On: aCanvas].
	mark == #mark2 ifTrue: [^ self drawMark2On: aCanvas].
	mark == #mark3 ifTrue: [^ self drawMark3On: aCanvas].
	mark == #disc ifTrue: [^ self drawDiscOn: aCanvas].
	mark == #circle ifTrue: [^ self drawCircleOn: aCanvas].
	

]

{ #category : #drawing }
DrGSegmentMorph >> drawOn: aCanvas [
	(super drawOn: aCanvas) ifTrue: [ self drawMarkOn: aCanvas ]
		
]

{ #category : #accessing }
DrGSegmentMorph >> getVertices [
	self 
		from: (self drawable worldToMorph: mathItem origin)
		to: (self drawable worldToMorph: mathItem origin + mathItem direction).

]

{ #category : #'testing type' }
DrGSegmentMorph >> isSegment [
	^ true
]

{ #category : #accessing }
DrGSegmentMorph >> styleClass [
	^DrGSegmentStyle
]
