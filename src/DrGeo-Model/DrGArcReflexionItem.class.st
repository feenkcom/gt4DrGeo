Class {
	#name : #DrGArcReflexionItem,
	#superclass : #DrGArcItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGArcReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGArcReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGArcReflexionItem >> update [
|pointA|
	self doParentsExist ifTrue:
		[origin := parents first origin.
		radius := parents first radius.
		center := parents first center.
		length := parents first length negated.
		pointA := center + (radius * (origin cos @ origin sin)).
		pointA := pointA reflexionBy: parents second origin 
						direction: parents second direction.
		center := center reflexionBy: parents second origin 
						direction: parents second direction.
		pointA := pointA - center.
		origin := pointA y asFloat arcTan: pointA x].

]
