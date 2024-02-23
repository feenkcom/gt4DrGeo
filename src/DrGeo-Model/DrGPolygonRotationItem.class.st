Class {
	#name : #DrGPolygonRotationItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPolygonRotationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGPolygonRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGPolygonRotationItem >> update [
|center angle|
	self doParentsExist ifTrue: [
		center := parents second point.
		angle := parents third valueItem negated.
		points := OrderedCollection new.
		parents first points do: [:point |			points add: (point rotateBy: angle about: center)].
		self computeLength].

]
