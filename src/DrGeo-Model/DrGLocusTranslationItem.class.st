Class {
	#name : #DrGLocusTranslationItem,
	#superclass : #DrGLocus2ptsItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGLocusTranslationItem >> constrainedPoint [
	self shouldNotImplement 
]

{ #category : #testing }
DrGLocusTranslationItem >> doParentsExist [
"As a locus is sampled from its view, we need to check if the sampling occured in the view.
If not we will wait for the next round of view update"
	^ exist := super doParentsExist and: [parents first isSampled]
]

{ #category : #accessing }
DrGLocusTranslationItem >> freePoint [
	self shouldNotImplement 
]

{ #category : #accessing }
DrGLocusTranslationItem >> morphClass [
	^ DrGLocusTransformedMorph
]

{ #category : #'xml writing' }
DrGLocusTranslationItem >> nodeType [
	^ #Translation
]

{ #category : #accessing }
DrGLocusTranslationItem >> points: aCollection [
	self shouldNotImplement 
]

{ #category : #accessing }
DrGLocusTranslationItem >> samplesQty: anInteger [
	self shouldNotImplement 
]

{ #category : #updating }
DrGLocusTranslationItem >> update [
	self doParentsExist ifTrue: [| locusPoints direction|
		direction := parents second direction.
		locusPoints := parents first points.
		samplesQty := parents first samplesQty.
		p := Array new: samplesQty.
		1 to: samplesQty do: [:i |
			p at: i put: (locusPoints at: i) + direction]]
]
