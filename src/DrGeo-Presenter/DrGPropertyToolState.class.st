Class {
	#name : #DrGPropertyToolState,
	#superclass : #DrGStyleToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGPropertyToolState >> handleChoice: aMorphCollection [
	aMorphCollection 		
		ifNotEmpty: 
			[self context morph: aMorphCollection first.
			context presenter controlsManager propertyFor: context mathItem]

]
