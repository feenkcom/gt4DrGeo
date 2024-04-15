Class {
	#name : #DrGCompositeCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'compositeItem',
		'mathItems'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGCompositeCommand class >> with: theMathItems in: aDomain [
	^self new
		domain: aDomain ;
		compileComposite: theMathItems
]

{ #category : #'as yet unclassified' }
DrGCompositeCommand >> compileComposite: theMathItems [
	mathItems := theMathItems.
	compositeItem := DrGCompositeItem newWith: theMathItems.
]

{ #category : #'as yet unclassified' }
DrGCompositeCommand >> execute [
	domain triggerEvent: #groupCostumes with: compositeItem.
]

{ #category : #'as yet unclassified' }
DrGCompositeCommand >> release [
	compositeItem release.

]

{ #category : #'as yet unclassified' }
DrGCompositeCommand >> unexecute [
	domain triggerEvent: #ungroupCostumes with: compositeItem.
]
