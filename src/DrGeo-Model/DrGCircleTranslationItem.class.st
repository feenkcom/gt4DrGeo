Class {
	#name : #DrGCircleTranslationItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGCircleTranslationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGCircleTranslationItem >> nodeType [
	^#Translation
]

{ #category : #updating }
DrGCircleTranslationItem >> update [
	self doParentsExist ifTrue:
		[self center: parents first center + parents second direction.
		self radius: parents first radius].

]
