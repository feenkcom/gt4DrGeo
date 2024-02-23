Class {
	#name : #DrGVectorSymmetryItem,
	#superclass : #DrGVectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGVectorSymmetryItem >> initialize: theParents [
	super initialize: theParents.
	self origin: (parents first origin)
]

{ #category : #updating }
DrGVectorSymmetryItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGVectorSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGVectorSymmetryItem >> update [
	self doParentsExist ifTrue:
		[self direction: parents first direction negated].

]
