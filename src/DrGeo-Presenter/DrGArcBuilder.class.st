Class {
	#name : #DrGArcBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'pointA',
		'pointB',
		'pointC'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGArcBuilder class >> description [ 
	^  'Arc defined by three points.' translated
]

{ #category : #documentation }
DrGArcBuilder class >> title [
	^ 'Arc' translated
]

{ #category : #private }
DrGArcBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection  at: aPoint.
	pointA ifNil: [^ pointA := aMathItemCollection first].
	pointB ifNil: 
		[pointB := aMathItemCollection first.
		^ self addToFlyingItem: pointB].
	pointC ifNil: [pointC := aMathItemCollection first].
	
]

{ #category : #accessing }
DrGArcBuilder >> arguments [
	^{pointA . pointB . pointC}
]

{ #category : #'flying costume' }
DrGArcBuilder >> flyingMathItemArguments [
	^{pointA. pointB. movingPoint}.

]

{ #category : #'flying costume' }
DrGArcBuilder >> flyingMorphClass [
	^ DrGArcMorph
]

{ #category : #testing }
DrGArcBuilder >> isWanted: aMathItemCollection [ 
	^aMathItemCollection notEmpty
		and: [aMathItemCollection first isPointItem 
		and: [aMathItemCollection first ~= pointA 
		and: [aMathItemCollection first ~= pointB]]]
]

{ #category : #constant }
DrGArcBuilder >> mathItemClass [
	^DrGArc3ptsItem
]

{ #category : #testing }
DrGArcBuilder >> readyToBuild [
	^pointA notNil and: [pointB notNil and: [pointC notNil]]
]

{ #category : #updating }
DrGArcBuilder >> reset [
	super reset.
	pointA := pointB := pointC := nil
]
