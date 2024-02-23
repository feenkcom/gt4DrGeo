Class {
	#name : #DrGLocus2ptsItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'samplesQty',
		'p'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGLocus2ptsItem >> abscissaOf: aPoint [ 
	| i distance |
	distance := self squareNorm: aPoint - (p at: 1).
	i := 1.
	2 to: samplesQty do: [:n | 
		(self squareNorm: (p at: n) - aPoint)	< distance ifTrue: 
			[distance := self squareNorm: aPoint - (p at: n).
			i := n]].
	^ (i / samplesQty) asFloat
]

{ #category : #private }
DrGLocus2ptsItem >> adaptiveDescriptiveName [
	^ 'This locus %1' translated
]

{ #category : #accessing }
DrGLocus2ptsItem >> basicType [
	^ #locus
]

{ #category : #accessing }
DrGLocus2ptsItem >> closestPointTo: aPoint [ 
	| distance d m |
	m := p at: 1.
	distance := self squareNorm: aPoint - m.
	2 to: samplesQty do: [:n | 
		d := self squareNorm: (p at: n) - aPoint.
		d < distance ifTrue: 
			[m := p at: n.
			distance := d]].
	^ m
]

{ #category : #accessing }
DrGLocus2ptsItem >> constrainedPoint [
	^ parents second
]

{ #category : #accessing }
DrGLocus2ptsItem >> freePoint [
	^ parents first
]

{ #category : #'testing-model' }
DrGLocus2ptsItem >> isCurveItem [
	^ true
]

{ #category : #'testing-model' }
DrGLocus2ptsItem >> isGeometricItem [
	^ true
]

{ #category : #'testing-model' }
DrGLocus2ptsItem >> isIntersectableItem [
	^ false
]

{ #category : #'testing-model' }
DrGLocus2ptsItem >> isLocusItem [
	^ true
]

{ #category : #testing }
DrGLocus2ptsItem >> isSampled [
	^ samplesQty notNil
]

{ #category : #accessing }
DrGLocus2ptsItem >> morphClass [ 
	^ DrGLocusMorph
]

{ #category : #'xml writing' }
DrGLocus2ptsItem >> nodeType [
	^#'2pts'
]

{ #category : #accessing }
DrGLocus2ptsItem >> pointAt: anAbscissa [ 
	| m |
	samplesQty ifNil: [^0@0].
	m := (anAbscissa * samplesQty) rounded.
	m = 0 ifTrue: [m := 1].
	^ p at: m
]

{ #category : #accessing }
DrGLocus2ptsItem >> points [
	^ p
]

{ #category : #accessing }
DrGLocus2ptsItem >> points: aCollection [ 
	p := aCollection
]

{ #category : #printing }
DrGLocus2ptsItem >> printOn: aStream [
	self printType: DrGLocusBuilder title on: aStream
]

{ #category : #accessing }
DrGLocus2ptsItem >> samplesQty [
	^ samplesQty
]

{ #category : #accessing }
DrGLocus2ptsItem >> samplesQty: aNumber [ 
	samplesQty := aNumber
]

{ #category : #private }
DrGLocus2ptsItem >> squareNorm: aPoint [ 
	^ aPoint x * aPoint x + (aPoint y * aPoint y)
]

{ #category : #updating }
DrGLocus2ptsItem >> update [
"Special: update does not occure there but in the view.
Indeed, a Locus is sampled from its view, because it depends on the visible portion of the drawable"
]
