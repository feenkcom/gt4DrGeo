"
A command to delete a mathItem and its dependant.
"
Class {
	#name : #DrGDeleteCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'mathItems'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGDeleteCommand class >> for: aMathItem in: aDomain [
	^self new
		domain: aDomain;
		deleteMathItem: aMathItem.
]

{ #category : #'as yet unclassified' }
DrGDeleteCommand >> deleteMathItem: aMathItem [ 
	mathItems := domain factory orderedDependentMathItem: aMathItem.
]

{ #category : #command }
DrGDeleteCommand >> execute [
	domain factory 
		remove: mathItems
]

{ #category : #'as yet unclassified' }
DrGDeleteCommand >> release [
	mathItems do: [:m | m release].
]

{ #category : #command }
DrGDeleteCommand >> unexecute [
	mathItems do: [:aMathItem|
		domain factory add: aMathItem.
		domain triggerEvent: #redoMathItem with: aMathItem].
	domain factory changed: #pool
	
]
