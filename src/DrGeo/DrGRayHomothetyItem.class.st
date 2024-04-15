Class {
	#name : #DrGRayHomothetyItem,
	#superclass : #DrGRayItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGRayHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGRayHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGRayHomothetyItem >> update [
	self homothetyUpdate
]
