Class {
	#name : #DrGCircleReflexionItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGCircleReflexionItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGCircleReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGCircleReflexionItem >> update [
	self doParentsExist ifTrue:
		[self radius: parents first radius.
		self center: (parents first center
							reflexionBy: parents second origin 
							direction: parents second direction)].

]
