Class {
	#name : #DrGArcHomothetyItem,
	#superclass : #DrGArcItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGArcHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGArcHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGArcHomothetyItem >> update [
|arcItem centerHomothety|
	self doParentsExist ifTrue:
		[arcItem := parents first.
		centerHomothety := parents second point.
		center := centerHomothety +
			(parents third valueItem * (arcItem center - centerHomothety)).
		radius := arcItem radius * parents third valueItem abs.
		origin := arcItem origin + (parents third valueItem sign -1 * Float halfPi).
		length := arcItem length].
]
