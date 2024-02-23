Class {
	#name : #DrGVectorRotationItem,
	#superclass : #DrGVectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGVectorRotationItem >> initialize: theParents [
	super initialize: theParents.
	self origin: parents first origin.
]

{ #category : #updating }
DrGVectorRotationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGVectorRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGVectorRotationItem >> update [
	self doParentsExist ifTrue:
		[vector := parents first direction 
			rotateVector: parents third valueItem].

]
