Class {
	#name : #DrGCircle2ptsItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGCircle2ptsItem >> nodeType [
	^#'2pts'
]

{ #category : #updating }
DrGCircle2ptsItem >> update [
	self doParentsExist
		ifTrue: [center := parents first point.
					radius := center dist: parents second point].
]
