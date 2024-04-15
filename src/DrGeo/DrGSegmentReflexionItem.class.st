Class {
	#name : #DrGSegmentReflexionItem,
	#superclass : #DrGSegmentItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGSegmentReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGSegmentReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGSegmentReflexionItem >> update [
	self reflexionUpdate 
]
