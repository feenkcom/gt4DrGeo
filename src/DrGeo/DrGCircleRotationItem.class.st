Class {
	#name : #DrGCircleRotationItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGCircleRotationItem >> moveParent: aPoint [
	^false
]

{ #category : #'xml writing' }
DrGCircleRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGCircleRotationItem >> update [
	self doParentsExist ifTrue:
		[radius := parents first radius.
		center := parents first center
			rotateBy: parents third valueItem negated 
			about: parents second point].

]
