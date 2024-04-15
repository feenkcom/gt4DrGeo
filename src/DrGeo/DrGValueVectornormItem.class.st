Class {
	#name : #DrGValueVectornormItem,
	#superclass : #DrGValueSegmentlengthItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueVectornormItem >> adaptiveDescriptiveName [
	^ 'This Vector''s norm %1' translated
]

{ #category : #'xml writing' }
DrGValueVectornormItem >> nodeType [
	^#'vector_norm'
]
