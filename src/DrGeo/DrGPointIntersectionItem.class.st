"
k 				- (-1) or 1 when they are 2 intersection points
"
Class {
	#name : #DrGPointIntersectionItem,
	#superclass : #DrGPointItem,
	#instVars : [
		'k'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #'as yet unclassified' }
DrGPointIntersectionItem class >> newWith: theParents k: integer [
	"Instantiate this mathItem with these parents
	Parents contains other MathItem instance, sometime it contains other object as Point"
	^self new 
		parents: theParents; 
		k: integer;
		update;
		rehash;
		yourself
]

{ #category : #comparing }
DrGPointIntersectionItem >> = aMathItem [
	^ super = aMathItem and: [k = aMathItem k]
]

{ #category : #'initialize-release' }
DrGPointIntersectionItem >> initialize: theParents [
"check for the right intersection point when one parent is a circle or an arc"
|pointA pointB clicPoint|
	super initialize: theParents.
	k := 0. "0 when only one intersection"
	(theParents first isCircleItem 
		or: [theParents second isCircleItem
	 		or: [theParents first isArcItem
				or: [theParents second isArcItem]]])
		ifFalse: [^self].
	pointA := [theParents first intersectionWith: theParents second flag: -1] on: Error do: [nil].
	pointB := [theParents first intersectionWith: theParents second flag: 1] on: Error do: [nil].
	pointA ifNil: [^ self k: 1].
	pointB ifNil: [^ self k: -1].
	clicPoint := theParents third.
	(pointA squaredDistanceTo: clicPoint) < (pointB squaredDistanceTo: clicPoint)
		ifTrue: [self k: -1] 
		ifFalse: [self k: 1]
]

{ #category : #'testing-model' }
DrGPointIntersectionItem >> isConstrainedPointItem [
	^true
]

{ #category : #'testing-model' }
DrGPointIntersectionItem >> isIntersectionPointItem [
	^true
]

{ #category : #accessing }
DrGPointIntersectionItem >> k [
	^k
]

{ #category : #accessing }
DrGPointIntersectionItem >> k: integer [ 
	k := integer.
	self update.
	self rehash
]

{ #category : #'xml writing' }
DrGPointIntersectionItem >> nodeType [
	^#Intersection
]

{ #category : #accessing }
DrGPointIntersectionItem >> parents: aCollection [ 
	"We only need the 1st and 2nd mathItem in the collection. 
The 3rd one is a Point instance (position the user clicked) only used at initialization time"
	aCollection isEmptyOrNil ifTrue: 
		[parents := aCollection.
		^self].
	parents := OrderedCollection new
		add: aCollection first;
		add: aCollection second;
		yourself.

]

{ #category : #comparing }
DrGPointIntersectionItem >> rehash [
	^hash := (super rehash bitXor: k ) bitXor: point hash 
]

{ #category : #updating }
DrGPointIntersectionItem >> update [
	|aPoint|
	self doParentsExist ifTrue:
		[aPoint := [(parents first intersectionWith: parents second flag: k)] on: Error do: [nil].
		aPoint 
			ifNil: [exist := false]
			ifNotNil: 
				[exist := true.
				self point: aPoint]].
]

{ #category : #'xml writing' }
DrGPointIntersectionItem >> writeAsXmlTo: aNode [ 
	| node |
	node := super writeAsXmlTo: aNode.
	node
		attributeAt: #extra
		put: (k = 1
				ifTrue: ['1']
				ifFalse: ['0']).
	^node
]
