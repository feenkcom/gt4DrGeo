Class {
	#name : #DrGLocusHomothetyItem,
	#superclass : #DrGLocusTranslationItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGLocusHomothetyItem >> nodeType [
	^#Scale
]

{ #category : #updating }
DrGLocusHomothetyItem >> update [
	self doParentsExist ifTrue: [| locusPoints center factor|
		center := parents second point.
		factor := parents third valueItem.
		locusPoints := parents first points.
		samplesQty := parents first samplesQty.
		p := Array new: samplesQty.
		1 to: samplesQty do: [:i |
			p at: i put: center + (factor * ((locusPoints at: i) - center))]]
]
