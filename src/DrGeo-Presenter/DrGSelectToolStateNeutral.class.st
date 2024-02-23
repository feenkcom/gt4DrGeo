Class {
	#name : #DrGSelectToolStateNeutral,
	#superclass : #DrGSelectToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGSelectToolStateNeutral >> handleMouseAt: aPoint [
	| processSomething |
	(processSomething := super handleMouseAt: aPoint)
		ifTrue: [	Cursor webLinkCursor activateCursor] 
		ifFalse: [Cursor normalCursorWithMask activateCursor].
	^ processSomething 
]

{ #category : #handling }
DrGSelectToolStateNeutral >> handlePress: aPoint [ 
	| morphs griddedPoint|
	self drawable hideTip.
	griddedPoint := self context gridPoint: aPoint.
	morphs := self context relevantMorphsNear: aPoint.
	morphs size = 1 
		ifTrue: 
			[self context last: griddedPoint.
			self context morph: morphs first.
			self context updateDirtyItemsList.
			self switchState: DrGSelectToolStateGrabbed.
			^true].
	"More than one math item under mouse"
	morphs size > 1 
		ifTrue: 
			[self context last: griddedPoint.
			self context chooseMorph: morphs.
			^true].
	"The user clicked in the background, clear the selection"
	self context reset.
	^false
]

{ #category : #handling }
DrGSelectToolStateNeutral >> handlePressShiftKey: aPoint [ 
	| morphs griddedPoint|
	self drawable hideTip.
	griddedPoint := self context gridPoint: aPoint.
	morphs := self context mutableMorphsAt: aPoint.
	morphs size = 1 
		ifTrue: 
			[self context last: griddedPoint.
			self context morph: morphs first.
			self context updateDirtyItemsList.
			self switchState: DrGMutatorToolStateGrabbed. 
			^true].
	"More than one math item under mouse"
	morphs size > 1 
		ifTrue: 
			[self context last: griddedPoint.
			(self context chooseMorph: morphs) 
				ifTrue: [self switchState: DrGMutatorToolStateSelected].
			^true].
	"The user clicked in the background, clear the selection"
	self context reset.
	^false
]

{ #category : #handling }
DrGSelectToolStateNeutral >> handleShiftKeyMouseAt: aPoint [
	"Let's inform about the mutate mode"
	| morphs aTip |
	morphs := self context mutableMorphsAt: aPoint.
	morphs ifEmpty: [
		aTip := 'Pressing down the [Shift] key you can drag and change the nature of free point or intersection point.' translated].
	morphs size = 1 ifTrue: [
		aTip := 'Drag this point to change its nature.' translated].
	morphs size > 1 ifTrue: [
		aTip := 'Several objects can be selected. Please, select one clicking the mouse.' translated. ].
	self drawable tip: aTip at: aPoint.
	^ aTip notNil
]

{ #category : #testing }
DrGSelectToolStateNeutral >> isSelectNeutral [
	^ true
]
