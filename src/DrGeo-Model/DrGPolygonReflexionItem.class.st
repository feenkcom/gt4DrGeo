Class {
	#name : #DrGPolygonReflexionItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPolygonReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGPolygonReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGPolygonReflexionItem >> update [
|axe|
	self doParentsExist 	ifTrue: 		[
		axe := parents second.
		points := OrderedCollection new.
		parents first points do: [:point |
			points add: (point reflexionBy: axe origin direction: axe direction)].
		self computeLength].

]
