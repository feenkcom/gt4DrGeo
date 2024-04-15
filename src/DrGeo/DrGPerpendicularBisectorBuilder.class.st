Class {
	#name : #DrGPerpendicularBisectorBuilder,
	#superclass : #DrGLineBuilder,
	#instVars : [
		'segment'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPerpendicularBisectorBuilder class >> description [
	^ 'Perpendicular bisector defined by a segment or two points.' translated
]

{ #category : #documentation }
DrGPerpendicularBisectorBuilder class >> title [
	^ 'Perpendicular bisector' translated
]

{ #category : #private }
DrGPerpendicularBisectorBuilder >> addItem: aMathItemCollection at: aPoint [
	| item |
	point := aPoint.
	(item := aMathItemCollection first) isSegmentItem ifTrue: 
		[^segment ifNil: [segment := item]].
	pointA 
		ifNil: [pointA := item.
			self addToFlyingItem: pointA.]
		ifNotNil: [pointB := item]
	
]

{ #category : #accessing }
DrGPerpendicularBisectorBuilder >> arguments [ 
	^ segment 
		ifNil: [{pointA . pointB}] 
		ifNotNil: [{segment}]
]

{ #category : #testing }
DrGPerpendicularBisectorBuilder >> isWanted: aMathItemCollection [
| item |
	^ aMathItemCollection notEmpty 
		and: [((item := aMathItemCollection first) isPointItem 
		and: [item ~= pointA])
			or: [item isSegmentItem and: [pointA isNil]]]
]

{ #category : #constant }
DrGPerpendicularBisectorBuilder >> mathItemClass [ 
	^ segment 
		ifNotNil: [DrGPerpendicularBisectorItem]
		ifNil: [DrGLinePerpendicularBisector2ptsItem].
]

{ #category : #testing }
DrGPerpendicularBisectorBuilder >> readyToBuild [
	^ segment notNil or:
		[pointA notNil and: [pointB notNil]]
]

{ #category : #updating }
DrGPerpendicularBisectorBuilder >> reset [
	super reset.
	segment := nil
]
