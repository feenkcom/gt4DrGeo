Class {
	#name : #DrGPointReflexionItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'testing-model' }
DrGPointReflexionItem >> isConstrainedPointItem [
	^true
]

{ #category : #'xml writing' }
DrGPointReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGPointReflexionItem >> update [
	self doParentsExist	ifTrue:
		[self point: (parents first point
				reflexionBy: parents second origin 
				direction: parents second direction)].

]
