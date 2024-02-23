Class {
	#name : #DrGVectorHomothetyItem,
	#superclass : #DrGVectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGVectorHomothetyItem >> initialize: theParents [
	super initialize: theParents.
	self origin: parents second point.
]

{ #category : #updating }
DrGVectorHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGVectorHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGVectorHomothetyItem >> update [
	self doParentsExist ifTrue:
		[vector := parents first direction * parents third valueItem].
]
