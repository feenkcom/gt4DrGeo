"
A command to merge 'mathItem' in 'target': all the direct children of mathItem will become direct children of target.
- directChildren : the children with the position of the mathItem in the parents collection.
"
Class {
	#name : #DrGMergeCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'mathItem',
		'target',
		'directChildren',
		'mathItemIndex'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGMergeCommand class >> merge: aMathItem with: aTarget in: aDomain [
	^ self new 
		domain: aDomain;
		merge: aMathItem with: aTarget 
]

{ #category : #command }
DrGMergeCommand >> execute [
	"replace mathItem as target in the parent item"
	directChildren do: [:array |
		array first parents 
			at: array second 
			put: target].
	domain factory remove: {mathItem}.
	domain updateAllMathItems.
]

{ #category : #'initialize-release' }
DrGMergeCommand >> merge: aMathItem with: aTarget [
	|children|
	mathItem := aMathItem.
	target := aTarget.
	mathItemIndex := domain factory indexOf: mathItem.
	children := domain factory directChildrenOf: mathItem.
	directChildren := OrderedCollection new.
	children do:[:aChild |
		directChildren add: (
			Array 
				with: aChild 
				with: (aChild parents indexOf: mathItem))]
]

{ #category : #command }
DrGMergeCommand >> unexecute [
	"unmerge target and mathItem"
	domain factory add: mathItem beforeIndex: mathItemIndex.
	domain triggerEvent: #redoMathItem with: mathItem.
	directChildren do: [:array |
		array first parents 
			at: array second 
			put: mathItem].
	domain updateAllMathItems.
]
