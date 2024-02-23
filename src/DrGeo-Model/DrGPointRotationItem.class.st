Class {
	#name : #DrGPointRotationItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'testing-model' }
DrGPointRotationItem >> isConstrainedPointItem [
	^true
]

{ #category : #'xml writing' }
DrGPointRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGPointRotationItem >> update [
	self doParentsExist	ifTrue:
		[self point: (parents first point
				rotateBy: parents third valueItem negated 
				about: parents second point)].

]
