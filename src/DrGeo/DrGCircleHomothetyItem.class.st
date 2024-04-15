Class {
	#name : #DrGCircleHomothetyItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGCircleHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGCircleHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGCircleHomothetyItem >> update [
|centerHomothety|
	self doParentsExist ifTrue:
		[centerHomothety := parents second point.
		radius := parents first radius * parents third valueItem abs.
		center := centerHomothety +
			(parents third valueItem * (parents first center - centerHomothety))].
]
