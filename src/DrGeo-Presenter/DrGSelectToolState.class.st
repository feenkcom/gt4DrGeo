"
An abstract state for the select tool and derivate.
"
Class {
	#name : #DrGSelectToolState,
	#superclass : #DrGToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGSelectToolState >> handleChoice: aMorphCollection [ 
	aMorphCollection 
		ifNotEmpty: 
			[self context morph: aMorphCollection first.
			self switchState: DrGSelectToolStateSelected.
			^true]
		ifEmpty: 
			[self context reset.
			^false]
]

{ #category : #accessing }
DrGSelectToolState >> mathItem [ 
"the selected math item"
	^ self context mathItem 
]
