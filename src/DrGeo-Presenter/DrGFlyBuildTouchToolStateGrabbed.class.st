"
I am grabbing: i.e. the mouse move with bouton pressed or the user finger is moving on the touch screen
"
Class {
	#name : #DrGFlyBuildTouchToolStateGrabbed,
	#superclass : #DrGFlyBuildTouchToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGFlyBuildTouchToolStateGrabbed >> handleMouseAt: aPoint [
	self switchState: DrGFlyBuildTouchToolStateSlided.
	^ true
]

{ #category : #handling }
DrGFlyBuildTouchToolStateGrabbed >> handlePress: aPoint [
	"We cannot clic again as the finger is stuck on the screen"
	^ false
]

{ #category : #handling }
DrGFlyBuildTouchToolStateGrabbed >> handleRelease: aPoint [
	self switchState: DrGFlyBuildTouchToolState
]
