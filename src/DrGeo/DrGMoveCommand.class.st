Class {
	#name : #DrGMoveCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'vector',
		'mathItem'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGMoveCommand class >> for: aMathItem with: aPoint in: aDomain [
	^self new
		domain: aDomain;
		mathItem: aMathItem;
		vector: aPoint
]

{ #category : #command }
DrGMoveCommand >> execute [
	domain moveEvent: mathItem inDirection: vector
]

{ #category : #accessing }
DrGMoveCommand >> mathItem: aMathItem [
	mathItem := aMathItem 
]

{ #category : #command }
DrGMoveCommand >> unexecute [
	domain moveEvent: mathItem inDirection: vector negated
]

{ #category : #accessing }
DrGMoveCommand >> vector: aPoint [
	vector := aPoint
	
]
