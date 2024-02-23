Class {
	#name : #DrGFlyBuildTouchToolStateSlided,
	#superclass : #DrGFlyBuildTouchToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGFlyBuildTouchToolStateSlided >> handlePress: aPoint [
	"the finger is stuck on the screen, we cannot clic again, can't do anything"
	^ false
]

{ #category : #handling }
DrGFlyBuildTouchToolStateSlided >> handleRelease: aPoint [
	self switchState: DrGFlyBuildTouchToolState.
	self context last: aPoint.
	"do we select an item underneath?"
	(self context mathItemTool handlePress: aPoint) ifTrue: [^true].
	"do we want a flyingPoint ?"
	(self isFlyingPointConstructedAt: aPoint) ifFalse: [^false].
	self addFlyingPointToBuiltItemAt: aPoint.
	^ true
]
