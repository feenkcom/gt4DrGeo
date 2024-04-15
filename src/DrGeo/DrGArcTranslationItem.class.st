Class {
	#name : #DrGArcTranslationItem,
	#superclass : #DrGArcItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGArcTranslationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGArcTranslationItem >> nodeType [
	^#Translation
]

{ #category : #updating }
DrGArcTranslationItem >> update [
	self doParentsExist ifTrue:
		[origin := parents first origin.
		radius := parents first radius.
		center := parents first center + parents second direction.
		length := parents first length].

]
