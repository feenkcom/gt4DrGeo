Class {
	#name : #DrGRayTranslationItem,
	#superclass : #DrGRayItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGRayTranslationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGRayTranslationItem >> nodeType [
	^#Translation
]

{ #category : #updating }
DrGRayTranslationItem >> update [
	self translationUpdate 
]
