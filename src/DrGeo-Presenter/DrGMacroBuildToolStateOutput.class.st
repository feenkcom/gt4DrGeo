"
When user selects  output page, blink the cosumes related to this state. In this state the user can select items as output parameters for the macro. He can also unselect items.
"
Class {
	#name : #DrGMacroBuildToolStateOutput,
	#superclass : #DrGBuildToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGMacroBuildToolStateOutput >> context: aContext [
	super context: aContext.
	self context selectOutputMorph 
]

{ #category : #handling }
DrGMacroBuildToolStateOutput >> handleChoice: aMorphCollection [ 
	self context builder
		add: (aMorphCollection collect: [ :c | c mathItem ])
			at: (self drawable gridWorldPoint: self context last);
		changed: #outputNames.
	self context selectOutputMorph
]
