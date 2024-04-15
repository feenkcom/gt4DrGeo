Class {
	#name : #DrGMacroPlayToolStateSelect,
	#superclass : #DrGMacroBuildToolStateInput,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGMacroPlayToolStateSelect >> handleChoice: aMorphCollection [ 
	self context builder 
		add: (aMorphCollection collect: [ :c | c mathItem ])
		at: (self drawable gridWorldPoint: self context last).
	self context selectInputMorph
]
