Class {
	#name : #DrGPolygonBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'points'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPolygonBuilder class >> description [
	^ 'Polygon by n points: last point must be the initial point to terminate.' translated
]

{ #category : #documentation }
DrGPolygonBuilder class >> title [ 
	^ 'Polygon' translated
]

{ #category : #private }
DrGPolygonBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	points add: aMathItemCollection first.
	self addToFlyingItem: points last.
]

{ #category : #'flying costume' }
DrGPolygonBuilder >> addToFlyingItem: anItem [
	self isNotInteractive ifTrue: [^self].
	points size = 2 ifTrue: [
		movingPoint := DrGPointFreeItem new point: anItem point + (0.1 @ 0.1).
		flyingItem := self mathItemClass 
			newWith: ((OrderedCollection withAll: points) add: movingPoint; yourself).
		self initializeFlyingMorph].
	points size > 2 ifTrue: [
		movingPoint := DrGPointFreeItem new point: anItem point + (0.1 @ 0.1).
		flyingItem parents: (flyingItem parents
								add: movingPoint;
								yourself).
		flyingMorph redrawNeeded]
]

{ #category : #accessing }
DrGPolygonBuilder >> arguments [
	^points allButLast
]

{ #category : #'flying costume' }
DrGPolygonBuilder >> flyingMorphClass [
	^ DrGPolygonMorph 
]

{ #category : #'initialize-release' }
DrGPolygonBuilder >> initialize [
	points := OrderedCollection new.

]

{ #category : #testing }
DrGPolygonBuilder >> isWanted: aMathItemCollection [
^aMathItemCollection notEmpty
	and: [aMathItemCollection first isPointItem
	and: [points isEmpty
		or: [(points first = aMathItemCollection first and: [ points size > 2])
		or: [(points includes: aMathItemCollection first) not]]]]
]

{ #category : #constant }
DrGPolygonBuilder >> mathItemClass [
	^DrGPolygonNptsItem
]

{ #category : #xml }
DrGPolygonBuilder >> parentsById: node [
	|arguments|
	"To instantiate a polygon we need the first summit to be duplucated at the end of the point collection"
	arguments := super parentsById: node.
	arguments addLast: arguments first.
	^ arguments 
]

{ #category : #testing }
DrGPolygonBuilder >> readyToBuild [
	^ points size > 2 and: [points first = points last]
]

{ #category : #updating }
DrGPolygonBuilder >> reset [
	super reset.
	points := OrderedCollection new
]
