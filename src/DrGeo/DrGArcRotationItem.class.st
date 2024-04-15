Class {
	#name : #DrGArcRotationItem,
	#superclass : #DrGArcItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGArcRotationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGArcRotationItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGArcRotationItem >> update [
|arcItem|
	self doParentsExist ifTrue:
		[arcItem := parents first.
		center := arcItem center
			rotateBy: parents third valueItem negated 
			about: parents second point.
		origin := arcItem origin + parents third valueItem.
		length := arcItem length.
		radius := arcItem radius].

]
