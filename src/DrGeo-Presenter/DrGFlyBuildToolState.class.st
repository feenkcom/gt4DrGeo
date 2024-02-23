Class {
	#name : #DrGFlyBuildToolState,
	#superclass : #DrGToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #processing }
DrGFlyBuildToolState >> addFlyingPointToBuiltItemAt: aPoint [
	self context mathItemTool 
		add: self context drawable lastItemView.
	self context mathItemTool builder 
		add: {self context domain factory last} 
		at: (self drawable morphToWorld: aPoint).
]

{ #category : #handling }
DrGFlyBuildToolState >> handleMouseAt: aPoint [ 
	self context builder moveFlyingMorphAt: (self drawable  morphToWorld: aPoint).
	self context last: aPoint.
	self drawable updateUnderMouseMorph.
	"dispatch handleMouseAt"
	^ (self context mathItemTool handleMouseAt: aPoint) 
		ifFalse: [self isFlyingPointWantedAt: aPoint]
		ifTrue: [true]
]

{ #category : #handling }
DrGFlyBuildToolState >> handlePress: aPoint [ 
	self context last: aPoint.
	"do we select an item underneath? If so we are done"
	(self context mathItemTool handlePress: aPoint) ifTrue: [^true].
	"do we want a flyingPoint ?"
	(self isFlyingPointConstructedAt: aPoint) ifFalse: [^false].
	self addFlyingPointToBuiltItemAt: aPoint.
	^ true
]

{ #category : #handling }
DrGFlyBuildToolState >> handleRelease: aPoint [
	self context mathItemTool handleRelease: aPoint.
	self context flyPointTool handleRelease: aPoint.
]

{ #category : #testing }
DrGFlyBuildToolState >> isFlyingPointConstructedAt: aPoint [
"return true whenever a flypoint is constructed, the new point instance is then 
 ready to use, from the flyPointTool builder"
	^ (self context mathItemTool builder isWanted: { (DrGPointItem new) }) 
		and: [self context flyPointTool handlePress: aPoint]
]

{ #category : #testing }
DrGFlyBuildToolState >> isFlyingPointWantedAt: aPoint [
"are we interested by a point at position aPoint"
	^ (self context mathItemTool builder isWanted: { (DrGPointItem new) }) 
		ifTrue: [self context flyPointTool handleMouseAt: aPoint]
		ifFalse: [false]
]
