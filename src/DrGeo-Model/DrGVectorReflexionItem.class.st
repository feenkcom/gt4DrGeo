Class {
	#name : #DrGVectorReflexionItem,
	#superclass : #DrGVectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGVectorReflexionItem >> initialize: theParents [
	super initialize: theParents.
	self origin: parents first origin.
]

{ #category : #updating }
DrGVectorReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGVectorReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGVectorReflexionItem >> update [
	self doParentsExist ifTrue:
		[self direction: (parents first direction 
								vectorReflexionBy: parents second direction)].

]
