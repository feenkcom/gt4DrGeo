Class {
	#name : #DrGLineRotationItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGLineRotationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGLineRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGLineRotationItem >> update [
	self rotationUpdate 
]
