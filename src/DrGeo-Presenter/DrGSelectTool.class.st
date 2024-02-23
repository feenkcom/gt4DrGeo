"
- start: the position where start the dragging
- mathItems: the mathItems impacted by the dragging operation
- morphs: the DrGMorphs impacted by the dragging opration
- builder: we have the clone builder, ready to serve, so we have to instantiate it.
"
Class {
	#name : #DrGSelectTool,
	#superclass : #DrGTool,
	#instVars : [
		'start',
		'mathItems',
		'morphs',
		'builder'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #documentation }
DrGSelectTool class >> description [
	^ 'Select and move an object.' translated
]

{ #category : #documentation }
DrGSelectTool class >> title [ 
	^ 'Select and Move' translated
]

{ #category : #accessing }
DrGSelectTool >> builder [
	^ builder
]

{ #category : #accessing }
DrGSelectTool >> curvesToMutatePointIntoNear: aPoint [
"Search for the curves the point can mutate into. In priority intersectable curves, then curves."
	| curves intersectables |
	curves := (self myMorphsNear: aPoint) select: [:aMorph | 		aMorph mathItem isCurveItem 
		and: [self domain factory is: aMorph mathItem before: self mathItem]].
	"if several curves check for the intersectables"
	^ curves size > 1 
		ifTrue: [  
			intersectables := curves select: [ :aMorph |  aMorph mathItem isIntersectableItem].
			intersectables size > 1
				ifTrue: [intersectables]
				ifFalse: [#()]]
		ifFalse: [ curves ]
]

{ #category : #accessing }
DrGSelectTool >> description [
	^ self class description
]

{ #category : #updating }
DrGSelectTool >> grabClone: clone [
"We cloned! We want to grab the clone to let the user move it somewhere in the canvas"
	self morph: (self drawable viewOf: clone).
	builder reset.
	self switchState: DrGSelectToolStateDragged.

]

{ #category : #'initialize-release' }
DrGSelectTool >> initialize [
	self reset.
	builder := DrGCloneBuilder new.
]

{ #category : #testing }
DrGSelectTool >> isBuilding [
	^ false
]

{ #category : #testing }
DrGSelectTool >> isCloning [
	^ builder readyToBuild 
]

{ #category : #accessing }
DrGSelectTool >> mathItems [ 
	^ mathItems 
]

{ #category : #accessing }
DrGSelectTool >> morphs [
	^ morphs 
]

{ #category : #accessing }
DrGSelectTool >> mutableMorphsAt: aPoint [
"select the morph we can mutate"
	^ (self relevantMorphsNear: aPoint) select: [:aMorph | |item|
		item := aMorph mathItem.
		item isFreePointOnPlaneItem 
			or: [(item isPointItemOnCurve and: [(self factory is: item parentWithTest: #isLocusItem) not])
				or: [item isIntersectionPointItem]]]
]

{ #category : #accessing }
DrGSelectTool >> pointMorphToMergeWithAt: aPoint [
"A collection of point we can merge with. Only free point on plane are merge-able, and the merger should not depend on the initial point as well"
	| dependents myMorphs |
	^ morph mathItem isFreePointOnPlaneItem 
		ifTrue: [
			myMorphs := self pointMorphsNear: aPoint.
			myMorphs ifEmpty: [^ #()].
			dependents := self domain factory dependentMathItem: morph mathItem.
			
			myMorphs select: [:aMorph | aMorph mathItem  ~~ morph mathItem 
					and: [(dependents includes: aMorph mathItem) not]]]
		ifFalse: [#()]
]

{ #category : #'initialize-release' }
DrGSelectTool >> registerDependant: anObject [
	builder when: #readyToBuild send: #readyToBuildClone to: anObject
]

{ #category : #accessing }
DrGSelectTool >> relevantMorphsNear: aPoint [
	^ self pointMorphsFirstNear: aPoint
]

{ #category : #updating }
DrGSelectTool >> reset [
	super reset.
	start := nil.
	self switchState: DrGSelectToolStateNeutral.
	mathItems := nil.
	builder ifNotNil: [builder reset].
]

{ #category : #accessing }
DrGSelectTool >> start [
	^start
]

{ #category : #accessing }
DrGSelectTool >> start: aPoint [
	start := aPoint 
]

{ #category : #updating }
DrGSelectTool >> updateDirtyItemsList [
"Dirty items are the one needing update, both model and view. Don't try to be smart, update all of them."
	mathItems := self factory pool.
	morphs := self drawable itemViews 
]
