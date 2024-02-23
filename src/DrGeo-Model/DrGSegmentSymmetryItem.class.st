Class {
	#name : #DrGSegmentSymmetryItem,
	#superclass : #DrGSegmentItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGSegmentSymmetryItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGSegmentSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGSegmentSymmetryItem >> update [
	self symmetryUpdate 
]
