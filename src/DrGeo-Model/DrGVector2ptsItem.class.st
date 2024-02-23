Class {
	#name : #DrGVector2ptsItem,
	#superclass : #DrGVectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGVector2ptsItem >> initialize: theParents [
	super initialize: theParents.
	self origin: (theParents first point).
]

{ #category : #'xml writing' }
DrGVector2ptsItem >> nodeType [
	^#'2pts'
]

{ #category : #updating }
DrGVector2ptsItem >> update [
	self doParentsExist ifTrue:
		[self direction: (parents at: 2) point - (parents at: 1) point].

]
