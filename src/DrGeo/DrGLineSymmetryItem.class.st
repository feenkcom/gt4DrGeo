Class {
	#name : #DrGLineSymmetryItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGLineSymmetryItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGLineSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGLineSymmetryItem >> update [
	self symmetryUpdate 
]
