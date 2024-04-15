Class {
	#name : #DrGFlyPointBuildToolState,
	#superclass : #DrGBuildToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGFlyPointBuildToolState >> handleMouseAt: aPoint [ 
	| morphs aTip |
	morphs := self context relevantMorphsNear: aPoint.
	morphs size = 1
		ifTrue: [aTip := morphs first mathItem descriptiveName].
	morphs size > 1
		ifTrue: [aTip := 'This intersection' translated].
	aTip
		ifNil: [self drawable hideTip]
		ifNotNil: [self drawable tip: aTip at: aPoint].
	^ aTip notNil
]

{ #category : #handling }
DrGFlyPointBuildToolState >> handlePress: aPoint [ 
"return true as we always do something in this context."
	self drawable hideTip.
	self context last: (self context gridPoint: aPoint).
	"user clicked in the background or in one or several curve item, handle it immediately"
	self handleChoice: (self context relevantMorphsNear: aPoint).
	^ true
]
