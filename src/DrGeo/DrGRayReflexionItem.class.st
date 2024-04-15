Class {
	#name : #DrGRayReflexionItem,
	#superclass : #DrGRayItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGRayReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGRayReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGRayReflexionItem >> update [
	self reflexionUpdate 
]
