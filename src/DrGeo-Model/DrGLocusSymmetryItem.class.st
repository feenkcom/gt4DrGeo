Class {
	#name : #DrGLocusSymmetryItem,
	#superclass : #DrGLocusTranslationItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGLocusSymmetryItem >> nodeType [
	^#Symmetry
]

{ #category : #updating }
DrGLocusSymmetryItem >> update [
	self doParentsExist ifTrue: [| locusPoints center|
		center := parents second point.
		locusPoints := parents first points.
		samplesQty := parents first samplesQty.
		p := Array new: samplesQty.
		1 to: samplesQty do: [:i |
			p at: i put: 2 * center - (locusPoints at: i)]]
]
