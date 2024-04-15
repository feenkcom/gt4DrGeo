"
A builder for to build:
- the coordinates of a point
- the equation of a circle
- the equation of a line
"
Class {
	#name : #DrGCoordinatesBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'pointA',
		'vector',
		'circle',
		'line'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGCoordinatesBuilder class >> description [
	^ 'Vector or point coordinates, circle or line equation.' translated
]

{ #category : #documentation }
DrGCoordinatesBuilder class >> title [
	^ 'Coordinates, equation' translated
]

{ #category : #private }
DrGCoordinatesBuilder >> addItem: aMathItemCollection at: aPoint [
	| item |
	point := aPoint.
	item := aMathItemCollection first.
	item isPointItem ifTrue: [^ pointA := item].
	item isCircleItem ifTrue: [^ circle := item].
	item isLineItem ifTrue: [^ line := item].
	item isVectorItem ifTrue: [^ vector := item]
]

{ #category : #accessing }
DrGCoordinatesBuilder >> arguments [
	^ Array with: ({pointA. vector . line . circle } detect: [:i | i isNil not] ifNone: [nil]) with: point
]

{ #category : #testing }
DrGCoordinatesBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty 
		and: [aMathItemCollection first isPointItem
			or: [aMathItemCollection first isLineItem
			or: [aMathItemCollection first isCircleItem
			or: [aMathItemCollection first isVectorItem]]]]
]

{ #category : #'as yet unclassified' }
DrGCoordinatesBuilder >> itemInstanceFrom: node [
"build an item from a XML description"
"this builder can create multiple item at once (coordinates X and Y), so we need
to select the one we want"
	| nodeType |
	(self parentsById: node) do: [:each |	self addItem: {each} at: 0@0].
	nodeType := (node  attributeAt: #type) asSymbol.
	^ self getItem detect: [:item | item nodeType = nodeType]

]

{ #category : #constant }
DrGCoordinatesBuilder >> mathItemClass [ 
	pointA ifNotNil: [^{DrGValuePtabscissaItem	. DrGValuePtordinateItem}].
	vector ifNotNil: [^{DrGValueVectorabscissaItem . DrGValueVectorordinateItem}].
	circle ifNotNil: [^ DrGEquationCircleItem].
	line ifNotNil: [^ DrGEquationLineItem]
]

{ #category : #xml }
DrGCoordinatesBuilder >> postProcess: item from: node [
	super postProcess: item from: node.
	self parseValuePosition: node of: item.
]

{ #category : #testing }
DrGCoordinatesBuilder >> readyToBuild [ 
	^ {pointA. vector . line . circle } anySatisfy: [:i | i isNil not]
		
]

{ #category : #updating }
DrGCoordinatesBuilder >> reset [
	super reset.
	pointA := vector := circle := line := nil
]
