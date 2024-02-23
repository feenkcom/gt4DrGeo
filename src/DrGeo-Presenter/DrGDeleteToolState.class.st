Class {
	#name : #DrGDeleteToolState,
	#superclass : #DrGStyleToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #handling }
DrGDeleteToolState >> handleChoice: aMorphCollection [
	aMorphCollection 		ifNotEmpty: 
		[self context presenter 
			deleteMathItem: aMorphCollection first;
			selectToolAfterBuilding].
	self context reset
]
