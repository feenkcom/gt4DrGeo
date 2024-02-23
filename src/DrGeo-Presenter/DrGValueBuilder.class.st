Class {
	#name : #DrGValueBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'curveItem',
		'pointA',
		'pointB'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGValueBuilder class >> description [ 
	^ 'Distance between objects, curve length, free value.' translated
]

{ #category : #documentation }
DrGValueBuilder class >> title [
	^ 'Distance, length, value' translated
]

{ #category : #private }
DrGValueBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection ifEmpty: [^self].
	aMathItemCollection first isPointItem 
		ifTrue: 
			[pointA ifNil:
				[pointA := aMathItemCollection first.
				^self].
			pointB ifNil:
				[pointB := aMathItemCollection first.
				^self]]
		ifFalse: [curveItem := aMathItemCollection first]
]

{ #category : #accessing }
DrGValueBuilder >> arguments [
	(pointA notNil and: [curveItem notNil]) 
		ifTrue: [^{pointA . curveItem. point}].
	curveItem ifNotNil: [^{curveItem. point}].
	pointB ifNotNil: [^{pointA . pointB. point}].
	^{point}
]

{ #category : #testing }
DrGValueBuilder >> isWanted: aMathItemCollection [ 
	aMathItemCollection
		ifEmpty: [^ true].
	aMathItemCollection first isPointItem
		ifTrue: [^ true].
	((aMathItemCollection first isLineItem
				or: [aMathItemCollection first isSegmentItem
				or: [aMathItemCollection first isVectorItem
				or: [aMathItemCollection first isCircleItem
				or: [aMathItemCollection first isArcItem
				or: [aMathItemCollection first isPolygonItem]	]]]])
			and: [pointA isNil])
		ifTrue: [^ true].
	(pointA notNil	and: [aMathItemCollection first isLineItem])
		ifTrue: [^ true].
	^ false
]

{ #category : #xml }
DrGValueBuilder >> itemInstanceFrom: node [
	(self parentsById: node) do: [:each |	self addItem: {each} at: 0@0].
	"give a chance to a Free value (ValueValueItem) to be instantiated, otherwise it does not hurt"
	self addItem: #() at: 0@0.
	^ self getItem first.

]

{ #category : #constant }
DrGValueBuilder >> mathItemClass [
	pointA
		ifNotNil: [curveItem
				ifNotNil: [curveItem isLineItem
						ifTrue: [^ DrGValueDistanceptlineItem]]].
	curveItem
		ifNotNil: [curveItem isLineItem
				ifTrue: [^ DrGValueSlopeItem].
			curveItem isSegmentItem
				ifTrue: [^ DrGValueSegmentlengthItem].
			curveItem isCircleItem
				ifTrue: [^ DrGValueCircleperimeterItem].
			curveItem isVectorItem
				ifTrue: [^ DrGValueVectornormItem].
			curveItem isArcItem
				ifTrue: [^ DrGValueArclengthItem].
			curveItem isPolygonItem
				ifTrue: [ ^ DrGValuePolygonperimeterItem]
				].
	pointB
		ifNotNil: [^ DrGValueDistance2ptsItem].
	^ DrGValueValueItem
]

{ #category : #xml }
DrGValueBuilder >> postProcess: item from: node [
	super postProcess: item from: node.
	self parseValuePosition: node of: item.
	(node attributeAt: #type) asSymbol == #value 
		ifTrue: [item valueItem: (node contentStringAt: #value) asNumber]
]

{ #category : #testing }
DrGValueBuilder >> readyToBuild [
	^(point notNil 
		and: [curveItem isNil
			and: [pointA isNil
				and: [pointB isNil]]])
		or: [pointB notNil
			or: [curveItem notNil]]
]

{ #category : #updating }
DrGValueBuilder >> reset [
	super reset.
	pointA := pointB := curveItem := nil
]
