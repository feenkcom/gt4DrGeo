Class {
	#name : #DrGStyleToolState,
	#superclass : #DrGSelectToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGStyleToolState >> handleChoice: aMorphCollection [
	aMorphCollection 
		ifNotEmpty: 
			[self context morph: aMorphCollection first.
			context presenter controlsManager stylerFor: self morphStyle]
		ifEmpty: [self context reset]
]

{ #category : #handling }
DrGStyleToolState >> handlePress: aPoint [
	|costumes|
	self drawable hideTip.
	costumes := self context relevantMorphsNear: aPoint.
	costumes size = 1 ifTrue:
		[self context last: aPoint.
		self handleChoice: costumes.
		^true].
	"More than one math item under mouse"
	costumes size > 1 ifTrue:
		[self context last: aPoint.
		self context chooseMorph: costumes.
		^true].
	"The user clicked in the background, clear the selection"
	self context reset.
	^false
]

{ #category : #'as yet unclassified' }
DrGStyleToolState >> morphStyle [
	^ self context morphStyle
]
