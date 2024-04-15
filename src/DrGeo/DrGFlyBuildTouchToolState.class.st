Class {
	#name : #DrGFlyBuildTouchToolState,
	#superclass : #DrGFlyBuildToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGFlyBuildTouchToolState >> handlePress: aPoint [
	| answer |
	answer := super handlePress: aPoint.
	answer ifTrue: [			self switchState: DrGFlyBuildTouchToolStateGrabbed].
	^ answer
]
