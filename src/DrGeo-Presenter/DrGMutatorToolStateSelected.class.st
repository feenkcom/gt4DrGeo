Class {
	#name : #DrGMutatorToolStateSelected,
	#superclass : #DrGSelectToolStateSelected,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGMutatorToolStateSelected >> handlePress: aPoint [ 
	self drawable hideTip.
	((self context relevantMorphsNear: aPoint) includes: self context morph) 
		ifTrue: [
			self context updateDirtyItemsList.
			self switchState: DrGMutatorToolStateGrabbed.
			^true]
		ifFalse: [ 
			self context reset.
			^false]
]
