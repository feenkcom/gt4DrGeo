Class {
	#name : #DrGLocusRotationItem,
	#superclass : #DrGLocusTranslationItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGLocusRotationItem >> nodeType [
	^#Rotation
]

{ #category : #updating }
DrGLocusRotationItem >> update [
	self doParentsExist ifTrue: [| locusPoints center angle|
		center := parents second point.
		angle := parents third valueItem.
		locusPoints := parents first points.
		samplesQty := parents first samplesQty.
		p := Array new: samplesQty.
		1 to: samplesQty do: [:i |
			p at: i put: ((locusPoints at: i) rotateBy: angle about: center)]]
]
