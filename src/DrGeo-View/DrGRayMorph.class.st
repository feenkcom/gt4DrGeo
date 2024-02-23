"
A DGRayMorph is extended in one 'sens' to the boundary of its parents morph, a drawable in Dr. Geo   jargon.
"
Class {
	#name : #DrGRayMorph,
	#superclass : #DrGCurveStraightMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGRayMorph >> extendFrom: origin direction: u [
	| border r borderY |
	r := u x asFloat / u y.
	u y > 0
		ifTrue: [
			borderY := self drawable morphExtent y.
			border := (borderY - origin y) * r + origin x @ borderY]
		ifFalse: [ border := (0 - origin y) * r + origin x @ 0].
	self from: origin to: border
]

{ #category : #accessing }
DrGRayMorph >> extendHorizontally: origin direction: u [
	| border |
	u x > 0
		ifTrue: [ border := self drawable morphExtent x @ origin y ]
		ifFalse: [ border := 0 @ origin y ].
	self from: origin to: border
]

{ #category : #accessing }
DrGRayMorph >> from: aPoint direction: u [
	u y abs < 0.001 
		ifTrue: [self extendHorizontally: aPoint direction: u]
		ifFalse: [self extendFrom: aPoint direction: u]
]

{ #category : #accessing }
DrGRayMorph >> getVertices [
	self
		from: (self drawable worldToMorph: mathItem origin)
		direction: (self drawable vectorToMorph: mathItem direction).

]

{ #category : #'testing type' }
DrGRayMorph >> isRay [
	^ true
]

{ #category : #accessing }
DrGRayMorph >> styleClass [
	^DrGRayStyle
]
