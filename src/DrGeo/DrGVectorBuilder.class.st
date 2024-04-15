Class {
	#name : #DrGVectorBuilder,
	#superclass : #DrGSegmentBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGVectorBuilder class >> description [ 
	^'Vector defined by two points.' translated
]

{ #category : #documentation }
DrGVectorBuilder class >> title [
	^'Vector' translated 
]

{ #category : #'flying costume' }
DrGVectorBuilder >> flyingMorphClass [
	^ DrGVectorMorph
]

{ #category : #constant }
DrGVectorBuilder >> mathItemClass [
	^DrGVector2ptsItem
]
