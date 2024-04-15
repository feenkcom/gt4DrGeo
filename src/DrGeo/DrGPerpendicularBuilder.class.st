Class {
	#name : #DrGPerpendicularBuilder,
	#superclass : #DrGParallelBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPerpendicularBuilder class >> description [ 
	^ 'Line passing through one point and orthogonal to a line, half-line, etc.' translated
]

{ #category : #documentation }
DrGPerpendicularBuilder class >> title [ 
	^ 'Perpendicular' translated
]

{ #category : #constant }
DrGPerpendicularBuilder >> mathItemClass [
	^DrGLinePerpendicularItem
]
