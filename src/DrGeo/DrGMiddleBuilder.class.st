Class {
	#name : #DrGMiddleBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'pointA',
		'pointB',
		'segment'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGMiddleBuilder class >> description [ 
	^ 'The midpoint of a segment or between two points.' translated
]

{ #category : #documentation }
DrGMiddleBuilder class >> title [ 
	^ 'Middle' translated. 
]

{ #category : #private }
DrGMiddleBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection first isPointItem 
		ifTrue:
			[pointA ifNil: 
				[pointA := aMathItemCollection first.
				^self].
			pointB ifNil:
				[pointB := aMathItemCollection  first.
				^self]]
		ifFalse: [segment := aMathItemCollection  first]
]

{ #category : #accessing }
DrGMiddleBuilder >> arguments [
	segment ifNotNil: [^{segment}].
	^{pointA . pointB}
]

{ #category : #testing }
DrGMiddleBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection  notEmpty 
		and: [(aMathItemCollection first isPointItem	
		and: [aMathItemCollection first ~= pointA])
			or: [aMathItemCollection first isSegmentItem and: [pointA isNil]]]
]

{ #category : #constant }
DrGMiddleBuilder >> mathItemClass [
	segment ifNotNil: [^DrGPointMiddlesegmentItem].
	^DrGPointMiddle2ptsItem
]

{ #category : #testing }
DrGMiddleBuilder >> readyToBuild [
	^ segment notNil or: [pointA notNil and: [pointB notNil]]
]

{ #category : #updating }
DrGMiddleBuilder >> reset [
	super reset.
	pointA := pointB := segment := nil
]
