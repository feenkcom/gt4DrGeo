Class {
	#name : #DrGLocusReflexionItem,
	#superclass : #DrGLocusTranslationItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGLocusReflexionItem >> nodeType [
	^#Reflexion
]

{ #category : #updating }
DrGLocusReflexionItem >> update [
	self doParentsExist ifTrue: [| locusPoints axe|
		axe := parents second.
		locusPoints := parents first points.
		samplesQty := parents first samplesQty.
		p := Array new: samplesQty.
		1 to: samplesQty do: [:i |
			p at: i put: ((locusPoints at: i) reflexionBy: axe origin direction: axe direction)]]
]
