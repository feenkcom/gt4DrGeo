Class {
	#name : #DrGMutatorToolStateGrabbed,
	#superclass : #DrGSelectToolStateGrabbed,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGMutatorToolStateGrabbed >> handleMouseAt: aPoint [ 
	"The user is moving, detach the point as a free point and switch to dragging state"
	|griddedPoint|
	self switchState: DrGMutatorToolStateDragged.
	griddedPoint := self context gridPoint: aPoint.
	self context
		start: griddedPoint;
		last: griddedPoint.
	self context domain mutateAsFreePoint: self mathItem.
	^ true


]
