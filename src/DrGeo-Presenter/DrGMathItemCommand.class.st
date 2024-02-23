"
A command to record a mathItem construction
"
Class {
	#name : #DrGMathItemCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'mathItems'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGMathItemCommand class >> for: aMathItem in: aDomain [ 
	^self new
		domain: aDomain;
		fromMathItem: aMathItem .
]

{ #category : #'as yet unclassified' }
DrGMathItemCommand class >> with: aBuilder in: aDomain [ 
	^self new
		domain: aDomain;
		createMathItem: aBuilder.
]

{ #category : #accessing }
DrGMathItemCommand >> createMathItem: aBuilder [
	mathItems := aBuilder getItem.
	mathItems do: [:each | domain autoname: each]

]

{ #category : #command }
DrGMathItemCommand >> execute [
	"Remove any previous dependant"
	mathItems do: [:aMathItem| 
		"record the mathItem in the factory"
		domain factory add: aMathItem.
		domain triggerEvent: #redoMathItem with: aMathItem].
	^mathItems
]

{ #category : #accessing }
DrGMathItemCommand >> fromMathItem: aMathItem [
	mathItems := {aMathItem}.

]

{ #category : #'dependents access' }
DrGMathItemCommand >> release [
	mathItems do: [:m | m release]
]

{ #category : #command }
DrGMathItemCommand >> unexecute [
	"remove the mathItem in the factory"
	domain factory 
		remove: mathItems
]
