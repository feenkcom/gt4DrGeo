Class {
	#name : #DrGBuildToolState,
	#superclass : #DrGToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGBuildToolState >> handleChoice: aMorphCollection [
|aMathItemCollection|
	aMathItemCollection := OrderedCollection new.
	aMorphCollection do: [:aMorph|
		aMathItemCollection add: aMorph mathItem.
		self context add: aMorph].
	self context builder 
		add: aMathItemCollection 
		at: (self drawable gridWorldPoint: self context last).
]

{ #category : #handling }
DrGBuildToolState >> handlePress: aPoint [ 
	"return true if we process something (including additional user choice)"
	| morphs |
	self drawable hideTip.
	self context last: aPoint.
	morphs := self context relevantMorphsNear: aPoint.
	morphs size = 1 	ifTrue: [
		self handleChoice: morphs.
		^true].
	(morphs size = 0 and: [self context isWanted: #() ]) 		ifTrue: [
		self handleChoice: morphs.
		^true].
	"More than one math item under mouse, user must choose one item"
	morphs size >= 2 	ifTrue: [
		"Display a pop-up menu to select one item"
		self context chooseMorph: morphs.
		^true].
	^false
]
