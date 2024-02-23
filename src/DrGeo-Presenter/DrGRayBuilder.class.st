Class {
	#name : #DrGRayBuilder,
	#superclass : #DrGSegmentBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGRayBuilder class >> description [ 
	^ 'Half-Line defined by two points, the first selected point is the origin.' translated
]

{ #category : #documentation }
DrGRayBuilder class >> title [
	^'Ray' translated 
]

{ #category : #'flying costume' }
DrGRayBuilder >> flyingMorphClass [
	^ DrGRayMorph
]

{ #category : #constant }
DrGRayBuilder >> mathItemClass [
	^DrGRay2ptsItem
]
