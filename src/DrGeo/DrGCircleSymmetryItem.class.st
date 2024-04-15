Class {
	#name : #DrGCircleSymmetryItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGCircleSymmetryItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGCircleSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGCircleSymmetryItem >> update [
	self doParentsExist ifTrue:
		[self radius: parents first radius.
		self center: (2 * parents second point) - parents first center].

]
