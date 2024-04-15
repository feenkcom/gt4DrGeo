Class {
	#name : #DrGSelectToolStateDragged,
	#superclass : #DrGSelectToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGSelectToolStateDragged >> handleChoice: aMorphCollection [ 
"In this state, handle a choice to merge two points"
	aMorphCollection ifNotEmpty: [
		aMorphCollection do: [:aCostume | aCostume stopBlinking].
		self context mathItem point: (self drawable morphToWorld: self context start).
		self context domain 
			merge: self context mathItem with: aMorphCollection first mathItem.
		self presenter saved: false].
	self context reset.
]

{ #category : #handling }
DrGSelectToolStateDragged >> handleMouseAt: aPoint [
|gridded|
	(self context isGridded and: [self mathItem isFreePointItem])
		ifFalse: [gridded := self drawable gridWorldVector: aPoint - self context last.
			self context domain 
				moveEvent: self mathItem
				inDirection: gridded 
				withDirty: self context mathItems.
			"If no movement, keep previous last position in reference"
			(gridded closeTo: 0@0) ifFalse: [self context last: (self context gridPoint: aPoint)]]
		ifTrue: [gridded := self context gridPoint: aPoint.
			self context domain 
				moveEvent: self mathItem
				at: (self drawable gridWorldPoint: gridded)
				withDirty: self context mathItems.
			self context last: gridded.].
	self drawable updateDottedLinesToParents.
	self drawable restartMouseStillDownHandle.
	^ true
]

{ #category : #handling }
DrGSelectToolStateDragged >> handleRelease: aPoint [ 
	self switchState: DrGSelectToolStateNeutral.
	"issue a moveCommand"
	self context domain 
		moveMathItem: self mathItem 
		with: (self drawable gridWorldVector: self context last - self context start).
	self drawable removeDottedLinesToParents.
	self context reset.
	self presenter saved: false
]

{ #category : #handling }
DrGSelectToolStateDragged >> handleStillPress: aPoint [
	|merger|
	(merger := self context pointMorphToMergeWithAt: aPoint) notEmpty  ifTrue: 
		["I keep pressing while holding a free point"
		merger size = 1 
			ifTrue: [self handleChoice: merger]
			ifFalse: [self context chooseMorph: merger title: 'Select a point to merge with' translated]]
]
