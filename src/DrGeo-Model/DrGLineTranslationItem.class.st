Class {
	#name : #DrGLineTranslationItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGLineTranslationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGLineTranslationItem >> nodeType [
	^#Translation
]

{ #category : #updating }
DrGLineTranslationItem >> update [
	self translationUpdate
]
