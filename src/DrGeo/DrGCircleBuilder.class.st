Class {
	#name : #DrGCircleBuilder,
	#superclass : #DrGSegmentBuilder,
	#instVars : [
		'radius',
		'segment'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGCircleBuilder class >> description [ 
	^ 'Circle defined by its center and a point or by its center and radius, a value.' translated
]

{ #category : #documentation }
DrGCircleBuilder class >> title [
	^ 'Circle' translated 
]

{ #category : #private }
DrGCircleBuilder >> addItem: aMathItemCollection at: aPoint [ 
	|item|
	point := aPoint.
	(item := aMathItemCollection first) isSegmentItem ifTrue: [
		^ segment ifNil: [segment := item]].
	item isValueItem ifTrue: [
		^ radius ifNil: [radius := item]].
	^ pointA 
		ifNil: [pointA := item.
			self addToFlyingItem: pointA]
		ifNotNil: [pointB := item]
]

{ #category : #accessing }
DrGCircleBuilder >> arguments [
	pointB
		ifNil: 
			[radius ifNotNil: [^{pointA. radius}].
			segment ifNotNil: [^{pointA. segment}]]
		ifNotNil: [^{pointA. pointB}]
]

{ #category : #'flying costume' }
DrGCircleBuilder >> flyingMorphClass [
	^ DrGCircleMorph
]

{ #category : #testing }
DrGCircleBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty
		and: [(aMathItemCollection first isPointItem
				and: [aMathItemCollection first ~= pointA])
			or: [(aMathItemCollection first isValueItem
				and: [pointA isNil not
				and: [aMathItemCollection first ~= radius]])
			or: [aMathItemCollection first isSegmentItem 
				and: [pointA isNil not
				and: [aMathItemCollection first ~= segment]]]]]
]

{ #category : #constant }
DrGCircleBuilder >> mathItemClass [
	^ radius
		ifNil: [
			segment 
				ifNil: [DrGCircle2ptsItem]
				ifNotNil: [DrGCircleSegmentItem]]
		ifNotNil: [DrGCircleRadiusItem]
]

{ #category : #testing }
DrGCircleBuilder >> readyToBuild [
	^ (radius notNil and: [pointA notNil])
		or: [(pointA notNil and: [pointB notNil])
			or: [pointA notNil and: [segment notNil]]]
]

{ #category : #updating }
DrGCircleBuilder >> reset [
	super reset.
	radius := nil.
	segment := nil.
]
