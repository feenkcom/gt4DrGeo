Class {
	#name : #DrGSelectToolStateSelected,
	#superclass : #DrGSelectToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGSelectToolStateSelected >> handleMouseAt: aPoint [
	| morphs |
	morphs := self context relevantMorphsNear: aPoint.
	^ (morphs includes: self context morph)
		ifTrue:
			[self drawable 	tip: self mathItem descriptiveName				at: aPoint.
			true]
		ifFalse: 
			[self drawable hideTip.
			false]
]

{ #category : #handling }
DrGSelectToolStateSelected >> handlePress: aPoint [ 
	self drawable hideTip.
	((self context relevantMorphsNear: aPoint) includes: self context morph) 
		ifTrue: [
			self context updateDirtyItemsList.
			self switchState: DrGSelectToolStateGrabbed.
			^true]
		ifFalse: [ 
			self context reset.
			^false]
]
