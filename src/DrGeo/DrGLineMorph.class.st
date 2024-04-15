"
A DrGLineMorph is extented to the boundary of its parent morph, a drawable in Dr. Geo jargon.
Its extend is virtually infinit.
"
Class {
	#name : #DrGLineMorph,
	#superclass : #DrGCurveStraightMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #helper }
DrGLineMorph class >> extend: origin inDirection: u toBorder: extent [
	| points c ex ey coordinate |
	points := OrderedCollection new.
	c := (origin x * u y - (origin y * u x)) asFloat.
	ex := extent x.
	ey := extent y.
	"Intersections with horizontal borders A, B"
	"A"
	[coordinate := (extent y * u x + c) / u y] on: ZeroDivide do: [coordinate := -1].
	(coordinate between: 0 and: ex) ifTrue: [points add: coordinate @ ey].
	"B"
	[coordinate := c / u y] on: ZeroDivide do: [coordinate := -1].
	(coordinate between: 0 and: ex) ifTrue: [points add: coordinate @ 0].
	"Vertical borders P, Q"
	"P"
	[coordinate := c negated / u x] on: ZeroDivide do: [coordinate := -1].
	(coordinate between: 0 and: ey) ifTrue: [points add: 0 @ coordinate].
	"Q"
	[coordinate := (ex * u y) - c / u x] on: ZeroDivide do: [coordinate := -1].
	(coordinate between: 0 and: ey) ifTrue: [points add: ex @ coordinate].
	^ points

]

{ #category : #accessing }
DrGLineMorph >> from: origin direction: u [
	| points |
	points := self class extend: origin inDirection: u toBorder: self drawable morphExtent.
	points size < 2 
		ifTrue: [self from: (-1 @0) to: (-1 @0) "off-limit, empy draw"]
		ifFalse: [	self from: points first to: points second]
]

{ #category : #accessing }
DrGLineMorph >> getVertices [
	self
		from: (self drawable worldToMorph: mathItem origin)
		direction: (self drawable vectorToMorph: mathItem direction).

]

{ #category : #'testing type' }
DrGLineMorph >> isLine [
	^ true
]

{ #category : #accessing }
DrGLineMorph >> styleClass [
	^DrGLineStyle
]
