Class {
	#name : #DrGLocusBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'freePoint',
		'constrainedPoint'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGLocusBuilder class >> description [
	^ 'Locus defined by a free point on a curve and a relative point.' translated
]

{ #category : #documentation }
DrGLocusBuilder class >> title [ 
	^ 'Locus' translated.
]

{ #category : #private }
DrGLocusBuilder >> addItem: aMathItemCollection at: aPoint [ 
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection first isPointItemOnCurve
		ifTrue: [freePoint
				ifNil: [freePoint := aMathItemCollection first.
					^ self].
			constrainedPoint
				ifNil: [constrainedPoint := aMathItemCollection first]]
		ifFalse: [constrainedPoint
				ifNil: [constrainedPoint := aMathItemCollection first.
					^ self].
			freePoint
				ifNil: [freePoint := aMathItemCollection first]]
]

{ #category : #accessing }
DrGLocusBuilder >> arguments [
	^ {freePoint. constrainedPoint}
]

{ #category : #testing }
DrGLocusBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty
		and: [(aMathItemCollection first isPointItemOnCurve
				and: [aMathItemCollection first ~= freePoint
				and: [aMathItemCollection first ~= constrainedPoint]])
			or: [aMathItemCollection first isConstrainedPointItem 
				and: [aMathItemCollection first ~= freePoint
				and: [aMathItemCollection first ~= constrainedPoint]]]]
]

{ #category : #constant }
DrGLocusBuilder >> mathItemClass [
	^ DrGLocus2ptsItem
]

{ #category : #testing }
DrGLocusBuilder >> readyToBuild [
	^ freePoint notNil
		and: [constrainedPoint notNil]
]

{ #category : #updating }
DrGLocusBuilder >> reset [
	super reset.
	freePoint := constrainedPoint := nil
]
