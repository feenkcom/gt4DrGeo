Class {
	#name : #DrGSegmentBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'pointA',
		'pointB'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGSegmentBuilder class >> description [
	^ 'Segment defined by two points.' translated
]

{ #category : #documentation }
DrGSegmentBuilder class >> title [
	^ 'Segment' translated
]

{ #category : #private }
DrGSegmentBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection  at: aPoint.
	pointA ifNil: 
		[pointA := aMathItemCollection first.
		self addToFlyingItem: pointA.
		^ self].
	pointB ifNil: [	pointB := aMathItemCollection first]
	
]

{ #category : #accessing }
DrGSegmentBuilder >> arguments [
	^{pointA . pointB}
]

{ #category : #'flying costume' }
DrGSegmentBuilder >> flyingMathItemArguments [
	^ {pointA. movingPoint}.

]

{ #category : #'flying costume' }
DrGSegmentBuilder >> flyingMorphClass [
	^ DrGSegmentMorph
]

{ #category : #testing }
DrGSegmentBuilder >> isWanted: aMathItemCollection [
	^aMathItemCollection notEmpty
		and: [aMathItemCollection first isPointItem	
		and: [aMathItemCollection first ~= pointA]]
]

{ #category : #constant }
DrGSegmentBuilder >> mathItemClass [
	^DrGSegment2ptsItem
]

{ #category : #testing }
DrGSegmentBuilder >> readyToBuild [
	^ pointA notNil and: [pointB notNil]
]

{ #category : #updating }
DrGSegmentBuilder >> reset [
	super reset.
	pointA := pointB := nil
]
