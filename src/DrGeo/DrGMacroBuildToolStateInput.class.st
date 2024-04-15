"
When user selects input page, blink the cosumes related to this state. In this state the user can select items as input parameters for the macro. He can also unselect items.
"
Class {
	#name : #DrGMacroBuildToolStateInput,
	#superclass : #DrGBuildToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #accessing }
DrGMacroBuildToolStateInput >> context: aContext [
	super context: aContext.
	self context selectInputMorph 
]

{ #category : #handling }
DrGMacroBuildToolStateInput >> handleChoice: aMorphCollection [ 
	self context builder
		add: (aMorphCollection collect: [ :c | c mathItem ])	
			at: (self drawable gridWorldPoint: self context last);
		changed: #inputNames.
	self context selectInputMorph
]
