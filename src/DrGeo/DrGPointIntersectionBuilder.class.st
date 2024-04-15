"
The build the intersection between two curves. One or two output may be created
"
Class {
	#name : #DrGPointIntersectionBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'curveItemA',
		'curveItemB'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPointIntersectionBuilder class >> description [
	^'Intersection(s) of two curves.' translated
]

{ #category : #documentation }
DrGPointIntersectionBuilder class >> title [
	^ 'Intersection' translated
]

{ #category : #private }
DrGPointIntersectionBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	curveItemA ifNil: [
		curveItemA := aMathItemCollection first.
		^self].
	curveItemB ifNil: [curveItemB := aMathItemCollection first]

]

{ #category : #accessing }
DrGPointIntersectionBuilder >> arguments [ 
	^{curveItemA . curveItemB.  point}
]

{ #category : #updating }
DrGPointIntersectionBuilder >> buildItem [ 
	^ self isArcSelected
		ifFalse: [super buildItem] 
		ifTrue: [{
			self mathItemClass newWith: self arguments k: 1.
			self mathItemClass newWith: self arguments k: -1}]
]

{ #category : #testing }
DrGPointIntersectionBuilder >> isArcSelected [
	"does the user selected two arcs ?"
	^ (curveItemA isCircleItem or: [curveItemA isArcItem]) or: [
		curveItemB isCircleItem or: [curveItemB isArcItem]]
]

{ #category : #testing }
DrGPointIntersectionBuilder >> isWanted: aMathItemCollection [ 
	aMathItemCollection ifEmpty: [^false].
	^ aMathItemCollection first isIntersectableItem 
		and: [curveItemA isNil or: [curveItemB isNil]]
]

{ #category : #xml }
DrGPointIntersectionBuilder >> itemInstanceFrom: node [
	"We only want intersection point"
	|arguments k|
	arguments := self parentsById: node.
	"We by-pass the builder because it requires the user mouse position at intersection request "
	k :=  (node attributeAt: 'extra') asNumber = 0 ifTrue: [-1] ifFalse: [1].
	^self mathItemClass newWith: arguments k: k.
]

{ #category : #constant }
DrGPointIntersectionBuilder >> mathItemClass [ 
	^ DrGPointIntersectionItem
]

{ #category : #'as yet unclassified' }
DrGPointIntersectionBuilder >> postProcess: item from: node [
	|k|
	super postProcess: item from: node.
	k :=  (node attributeAt: 'extra') asNumber = 0 ifTrue: [-1] ifFalse: [1].
	item k: k
]

{ #category : #testing }
DrGPointIntersectionBuilder >> readyToBuild [ 
	^ curveItemA notNil & curveItemB notNil 
]

{ #category : #updating }
DrGPointIntersectionBuilder >> reset [
	super reset.
	curveItemA := curveItemB := nil
]
