Class {
	#name : #DrGLineBuilder,
	#superclass : #DrGSegmentBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGLineBuilder class >> description [ 
	^ 'Line defined by two points' translated
]

{ #category : #documentation }
DrGLineBuilder class >> title [
	^ 'Line' translated
]

{ #category : #'flying costume' }
DrGLineBuilder >> flyingMorphClass [
	^ DrGLineMorph
]

{ #category : #constant }
DrGLineBuilder >> mathItemClass [
	^DrGLine2ptsItem
]
