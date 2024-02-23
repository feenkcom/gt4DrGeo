Class {
	#name : #DrGLineHomothetyItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGLineHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGLineHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGLineHomothetyItem >> update [
	self homothetyUpdate 
]
