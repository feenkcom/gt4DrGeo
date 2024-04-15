Class {
	#name : #DrGPolygonHomothetyItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPolygonHomothetyItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGPolygonHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGPolygonHomothetyItem >> update [
|center factor|
	self doParentsExist ifTrue: [
		center := parents second point.
		factor := parents third valueItem.
		points := OrderedCollection new.
		parents first points do: [:point | 			points add: (center + (factor * (point - center)))].
		self computeLength].
]
