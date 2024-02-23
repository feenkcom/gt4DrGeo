Class {
	#name : #DrGSegmentHomothetyItem,
	#superclass : #DrGSegmentItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGSegmentHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGSegmentHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGSegmentHomothetyItem >> update [
	self homothetyUpdate 
]
