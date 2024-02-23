Class {
	#name : #DrGPointTranslationItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'testing-model' }
DrGPointTranslationItem >> isConstrainedPointItem [
	^true
]

{ #category : #'xml writing' }
DrGPointTranslationItem >> nodeType [
	^#Translation
]

{ #category : #updating }
DrGPointTranslationItem >> update [
	self doParentsExist ifTrue:
		[self point: parents first point + parents second direction].

]
