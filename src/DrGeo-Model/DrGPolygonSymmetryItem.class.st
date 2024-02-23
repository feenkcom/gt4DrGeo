Class {
	#name : #DrGPolygonSymmetryItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPolygonSymmetryItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGPolygonSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGPolygonSymmetryItem >> update [
|center|
	self doParentsExist 	ifTrue: [
		center := parents second point.
		points := OrderedCollection new.
		parents first points do: [:point | points add: (2 * center - point)].
		self computeLength].

]
