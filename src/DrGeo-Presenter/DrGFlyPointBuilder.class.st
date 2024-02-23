"
To build free point and intersection point, it is also used to construct on the fly those point categories.
"
Class {
	#name : #DrGFlyPointBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'curveItemA',
		'curveItemB'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGFlyPointBuilder class >> description [ 
	^ DrGeoSystem isTablet
		ifTrue: ['Tap to create a point: free point on the background, on a curve or on two curves intersection.' translated]
		ifFalse:  ['Click to create a point: free point on the background, on a curve or on two curves intersection.' translated]
]

{ #category : #documentation }
DrGFlyPointBuilder class >> title [ 
	^ 'Point' translated
]

{ #category : #private }
DrGFlyPointBuilder >> addItem: aMathItemCollection at: aPoint [
"The behavior is a bit different as we send in the collection all the parent in one shot: 
to create the interesection the user clicks on two curves at the same time"
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection ifNotEmpty: 
		[curveItemA := aMathItemCollection first].
	aMathItemCollection size >= 2 ifTrue:
		[curveItemB := aMathItemCollection second]
]

{ #category : #accessing }
DrGFlyPointBuilder >> arguments [
	(curveItemA notNil and: [curveItemB notNil])
		ifTrue: [^{curveItemA . curveItemB . point}].
	curveItemA ifNotNil: [^{curveItemA . point}].
	^{point}
			
]

{ #category : #testing }
DrGFlyPointBuilder >> isCurveIntersectionValid: aCollection [
	| item state |
	state := self saveState.
	self restoreState: aCollection.
	[item := self buildItem]
		on: Error 
		do: [self restoreState: state.
			^false].
	self restoreState: state.
	^ item anyOne exist

]

{ #category : #testing }
DrGFlyPointBuilder >> isWanted: aMathItemCollection [
	^self isWanted: aMathItemCollection  at: 0@0
]

{ #category : #testing }
DrGFlyPointBuilder >> isWanted: aMathItemCollection at: aPoint [
	"click on the background?"
	aMathItemCollection ifEmpty: [^true].
	"click on two curves?"
	(aMathItemCollection size >= 2
		and: [aMathItemCollection first isIntersectableItem 
			and: [aMathItemCollection second isIntersectableItem]])
	ifTrue: [^ self isCurveIntersectionValid: {aMathItemCollection first. aMathItemCollection second. aPoint}].
	"click on one curve?"
	^aMathItemCollection first isCurveItem		
]

{ #category : #xml }
DrGFlyPointBuilder >> itemInstanceFrom: node [
	self shouldNotImplement
]

{ #category : #constant }
DrGFlyPointBuilder >> mathItemClass [
	(curveItemA notNil and: [curveItemB notNil]) 
		ifTrue: [^DrGPointIntersectionItem].
	curveItemA ifNotNil: [^DrGPointOncurveItem].
	point ifNotNil: [^DrGPointFreeItem].
	self error: 'Should not be there!'
]

{ #category : #testing }
DrGFlyPointBuilder >> readyToBuild [
	^ curveItemA notNil or: [point notNil]
]

{ #category : #updating }
DrGFlyPointBuilder >> reset [
	super reset.
	curveItemA := curveItemB := nil
]

{ #category : #private }
DrGFlyPointBuilder >> restoreState: anArray [
	curveItemA := anArray first.
	curveItemB := anArray second.
	point := anArray third
]

{ #category : #private }
DrGFlyPointBuilder >> saveState [
	^Array with: curveItemA with: curveItemB with: point
]
