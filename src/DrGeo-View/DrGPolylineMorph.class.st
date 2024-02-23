"
A morph to represent polygon (closed) or polyline (open)
"
Class {
	#name : #DrGPolylineMorph,
	#superclass : #DrGCurveMorph,
	#instVars : [
		'vertices',
		'closed',
		'arrows'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #'instance creation' }
DrGPolylineMorph class >> arrowPrototype [
	"Answer an instance of the receiver that will serve as a prototypical arrow"
	"DrGPolylineMorph arrowPrototype openInWorld"
	
	| aa |
	aa := self vertices: (Array with: 0@0 with: 40@40) 
		color: Color black 
		borderWidth: 2 
		borderColor: Color black.
	aa arrow: #forward.
	^ aa
]

{ #category : #settings }
DrGPolylineMorph class >> defaultArrowSpec [
	^ 5@4
]

{ #category : #examples }
DrGPolylineMorph class >> example1 [
	"self example1"
	^ DrGPolylineMorph
		vertices: {61@100. 88@219. 102@95. 22@50. 41@83}
		color: Color blue
		borderColor: Color black
]

{ #category : #examples }
DrGPolylineMorph class >> example2 [
	"self example2"
	^ DrGPolylineMorph
		vertices: {61@100. 88@219. 102@95. 22@50. 41@83}
		color: Color red
		borderColor: Color black.
]

{ #category : #examples }
DrGPolylineMorph class >> example3 [
	"self example3"
	| poly | 
	poly := DrGPolylineMorph
				vertices: {61@100. 88@219. 102@95. 22@50. 41@83}
				color: Color blue
				borderColor: Color black.
	poly makeOpen.
	^ poly 
]

{ #category : #examples }
DrGPolylineMorph class >> example4 [
	"self example4"
	| poly | 
	poly :=  (DrGPolylineMorph
		vertices: {61@100. 88@219. 102@95. 22@50. 41@83}
		color: Color blue
		borderColor: Color black).
	poly dashedBorder: { 5 .
		5.
		Color red.
		50 .
		0 }.
	^ poly 
]

{ #category : #'instance creation' }
DrGPolylineMorph class >> from: start to: end color: lineColor width: width in: aDrawable [
	| instance |
	instance := self new vertices: {start. end} color: nil borderWidth: width borderColor: lineColor.
	instance	 drawable: aDrawable .
	^ instance 
]

{ #category : #'instance creation' }
DrGPolylineMorph class >> vertices: verts color: c borderColor: bc [
	"(DrGPolylineMorph
		vertices: {261@400. 388@519. 302@595. 	222@500.	141@583. 34@444}
		color: Color red
		borderColor: Color yellow) openInWorld"
	^ self new vertices: verts color: c borderColor: bc
]

{ #category : #drawing }
DrGPolylineMorph >> adjustSegmentPointsForArrows [
	" In the list of vertices, adjust first and last entry if this polygon uses arrows.
	Returned the adjusted vertices, and if any the arrow bound"
	| verts arrowsBound |
	self hasArrows ifFalse: [ ^ Array with: vertices with: nil].
	verts := vertices copy.
	arrowsBound := Array new: 2.
	(arrows == #back or: [ arrows == #both ])
		ifTrue: [ | arrow |
			arrow := self arrowBoundsAt: verts first from: verts second.
			arrowsBound at: 1 put: arrow.
			arrow size = 4
				ifTrue: [ verts at: 1 put: arrow third ]
				ifFalse: [ verts at: 1 put: (arrow copyFrom: 2 to: 3) average ] ].
	(arrows == #forward or: [ arrows == #both ])
		ifTrue: [ | arrow |
			arrow := self arrowBoundsAt: verts last from: (verts at: (verts size - 1)).
			arrowsBound at: 2 put: arrow.
			arrow size = 4
				ifTrue: [ verts at: verts size put: arrow third ]
				ifFalse: [ verts at: verts size put: (arrow copyFrom: 2 to: 3) average ] ].
	^ Array with: verts with: arrowsBound 
]

{ #category : #arrow }
DrGPolylineMorph >> arrow: aSymbol [
"Accepted values: #none #back #forward #both "
	arrows := aSymbol 
]

{ #category : #arrow }
DrGPolylineMorph >> arrowBoundsAt: endPoint from: priorPoint [ 
	"Answer a triangle oriented along the line from priorPoint to endPoint."
	| d v angle wingBase arrowSpec length width |
	v := endPoint - priorPoint.
	angle := v degrees.
	d := borderWidth max: 1.
	arrowSpec := self valueOfProperty: #arrowSpec ifAbsent: [DrGPolylineMorph defaultArrowSpec].
	length := arrowSpec x abs.  width := arrowSpec y abs.
	wingBase := endPoint + (Point r: d * length degrees: angle + 180.0).
	arrowSpec x >= 0
		ifTrue: [^ {	endPoint.
					wingBase + (Point r: d * width degrees: angle + 125.0).
					wingBase + (Point r: d * width degrees: angle - 125.0) }]
		ifFalse: ["Negative length means concave base."
				^ {	endPoint.
					wingBase + (Point r: d * width degrees: angle + 125.0).
					wingBase.
					wingBase + (Point r: d * width degrees: angle - 125.0) }]
]

{ #category : #arrow }
DrGPolylineMorph >> arrowSpec: specPt [
	"Specify a custom arrow for this line.
	specPt x abs gives the length of the arrow (point to base) in terms of borderWidth.
	If specPt x is negative, then the base of the arrow will be concave.
	specPt y abs gives the width of the arrow.
	The standard arrow is equivalent to arrowSpec: PolygonMorph defaultArrowSpec.
	See arrowBoundsAt:From: for details."

	self setProperty: #arrowSpec toValue: specPt
]

{ #category : #geometry }
DrGPolylineMorph >> closestPointTo: aPoint [ 
	| closestPoint minDist |
	closestPoint := minDist := nil.
	self lineSegmentsDo: 
			[:p1 :p2 | | dist curvePoint | 
			curvePoint := aPoint nearestPointOnLineFrom: p1 to: p2.
			dist := curvePoint squaredDistanceTo: aPoint.
			(closestPoint isNil or: [dist < minDist]) 
				ifTrue: 
					[closestPoint := curvePoint.
					minDist := dist]].
	^closestPoint
]

{ #category : #geometry }
DrGPolylineMorph >> closestSegmentTo: aPoint [
	"Answer the starting index of my (big) segment nearest to aPoint"
	| closestPoint minDist vertexIndex closestVertexIndex |
	vertexIndex := 0.
	closestVertexIndex := 0.
	closestPoint := minDist := nil.
	self lineSegmentsDo:
		[:p1 :p2 | | curvePoint dist | 
		(p1 = (self vertices at: vertexIndex + 1))
			ifTrue: [ vertexIndex := vertexIndex + 1 ].
		curvePoint := aPoint nearestPointOnLineFrom: p1 to: p2.
		dist := curvePoint distanceTo: aPoint.
		(closestPoint isNil or: [dist < minDist])
			ifTrue: [closestPoint := curvePoint.
					minDist := dist.
					closestVertexIndex := vertexIndex. ]].
	^ closestVertexIndex
]

{ #category : #drawing }
DrGPolylineMorph >> drawArrow: pts on: aCanvas at: endPoint from: priorPoint [ 
	"Draw a triangle oriented along the line from priorPoint to  
	endPoint. Answer the wingBase."
	| spec  |
	spec := self valueOfProperty: #arrowSpec ifAbsent: [DrGPolylineMorph defaultArrowSpec].
	spec x sign = spec y sign 
		ifTrue: [aCanvas fillColor: borderColor do: [aCanvas polyLine: pts]]			
		ifFalse: 
			[aCanvas strokeWidth:  (borderWidth + 1) // 2  color: borderColor  do: [aCanvas polyLine: pts]].
]

{ #category : #drawing }
DrGPolylineMorph >> drawArrows: arrowsBound on: aCanvas [ 
	"Answer (possibly modified) endpoints for border drawing"
	"ArrowForms are computed only upon demand"
	arrowsBound ifNil: [^ self ]. "No arrow"
	"backward arrow?"
	arrowsBound first ifNotNil: [:arrow |
		self drawArrow: arrow on: aCanvas at: vertices first from: self nextToFirstPoint].
	"forward arrow?"
	arrowsBound second ifNotNil: [ :arrow |
		self drawArrow: arrow on: aCanvas at: vertices last from: self nextToLastPoint].
	
]

{ #category : #drawing }
DrGPolylineMorph >> drawOn: aCanvas [ 
	| verticesAndArrows |
	self isDrawNeeded ifFalse: [^ false].
	self getVertices.
	self isNotForAway ifFalse: [
		labelMorph ifNotNil: [labelMorph hide].
		 ^ false].
	self updateLabelStatus.
	vertices size < 1
		ifTrue: [self error: 'a polygon must have at least one point'].
	verticesAndArrows := self adjustSegmentPointsForArrows.
	style isFilled ifTrue: [
		aCanvas 
			strokeWidth: borderWidth 
			color: borderColor 
			fillColor: color 
			do: [aCanvas polyLine: verticesAndArrows first]]
		ifFalse: [
		aCanvas 
			strokeWidth: borderWidth 
			color: borderColor 
			strokeDashArray: dashedBorder 			strokeDashArrayOffset: 0.0 
			do: [aCanvas polyLine: verticesAndArrows first]].
	self drawArrows: verticesAndArrows second on: aCanvas.
	^ true
]

{ #category : #accessing }
DrGPolylineMorph >> getVertices [
"Write here how to fetch the vertices"
]

{ #category : #arrow }
DrGPolylineMorph >> hasArrows [
	"Are all the conditions meet for having arrows?"
	^ (closed or: [arrows == #none or: [vertices size < 2]]) not
]

{ #category : #initialization }
DrGPolylineMorph >> initialize [
	super initialize.
	closed := false.
	arrows := #none
]

{ #category : #testing }
DrGPolylineMorph >> isNotForAway [
" are all vertices in expanded screen area ?"
	| expandedBound |
	^ super isNotForAway or: [
		expandedBound := self drawable morphLocalBounds expandBy: 10000.
		vertices allSatisfy: [:v | 		expandedBound containsPoint: v		] ]
]

{ #category : #accessing }
DrGPolylineMorph >> labelMorph: aString [
"Dirty. No label morph  for Polyline morph, it is an abstract morph
May be create a sister class out of this hierarchy "
	self class == DrGPolylineMorph ifFalse: [super labelMorph: aString]
]

{ #category : #accessing }
DrGPolylineMorph >> lineSegmentsDo: endPointsBlock [ 
	"Emit a sequence of segment endpoints into endPointsBlock."
	| beginPoint |
	vertices size < 1
		ifTrue: [^ self].
	"test too few vertices first"
	beginPoint := nil.
	vertices do: [:vert | 
		beginPoint ifNotNil: [
			endPointsBlock value: beginPoint value: vert].
			beginPoint := vert].
		(closed or: [vertices size = 1]) ifTrue: [
			endPointsBlock value: beginPoint value: vertices first].

]

{ #category : #geometry }
DrGPolylineMorph >> makeClosed [
	closed := true
]

{ #category : #geometry }
DrGPolylineMorph >> makeOpen [
	closed := false.
]

{ #category : #accessing }
DrGPolylineMorph >> nextToFirstPoint [
	"For arrow direction"
	^ vertices second
]

{ #category : #accessing }
DrGPolylineMorph >> nextToLastPoint [
	"For arrow direction"
	^ vertices at: vertices size - 1
]

{ #category : #arrow }
DrGPolylineMorph >> standardArrows [
	self removeProperty: #arrowSpec.
]

{ #category : #accessing }
DrGPolylineMorph >> vertices [
	^ vertices
]

{ #category : #accessing }
DrGPolylineMorph >> vertices: newVertices [
	vertices := newVertices.
]

{ #category : #initialization }
DrGPolylineMorph >> vertices: verts color: aColor borderColor: anotherColor [ 
	color := aColor.
	borderColor := anotherColor.
	self vertices: verts.
	closed := vertices size > 2.
]

{ #category : #initialization }
DrGPolylineMorph >> vertices: verts color: aColor borderWidth: width borderColor: anotherColor [ 
	borderWidth := width.
	self vertices: verts color: aColor borderColor: anotherColor 
]
