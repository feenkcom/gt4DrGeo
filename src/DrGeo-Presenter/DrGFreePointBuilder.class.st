Class {
	#name : #DrGFreePointBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'curveItem'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #private }
DrGFreePointBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection  at: aPoint.
	aMathItemCollection 
		ifNotEmpty: [curveItem := aMathItemCollection first].
]

{ #category : #accessing }
DrGFreePointBuilder >> arguments [
	curveItem ifNotNil: 	
		[^ OrderedCollection new 
			add: curveItem; 
			add: point; 
			yourself].
	^ OrderedCollection new add: point; yourself
]

{ #category : #testing }
DrGFreePointBuilder >> isWanted: aMathItemCollection [
	"the user clicked on the background: we can build a free point" 
	aMathItemCollection ifEmpty: [^true].
	^aMathItemCollection first isCurveItem.
]

{ #category : #xml }
DrGFreePointBuilder >> itemInstanceFrom: node [
	"works both for free point and free point on a curve"
	self addItem: (self parentsById: node) at: 0@0.
	^ self getItem first.

]

{ #category : #constant }
DrGFreePointBuilder >> mathItemClass [
	curveItem ifNotNil: [^DrGPointOncurveItem].
	point ifNotNil: [^DrGPointFreeItem].
	self error: 'Should not be there!'
]

{ #category : #xml }
DrGFreePointBuilder >> postProcess: item from: node [
	super postProcess: item from: node.
	(node attributeAt: #type) asSymbol == #Free
		ifFalse: [
			item setCurveAbscissa: (node contentStringAt: #value) asNumber] 
		ifTrue: [ |x y|
			x := (node contentStringAt: #x) asNumber.
			y := (node contentStringAt: #y) asNumber.
			item point: x@y]

]

{ #category : #testing }
DrGFreePointBuilder >> readyToBuild [
	^ curveItem ~= nil or: [point ~= nil]
]

{ #category : #updating }
DrGFreePointBuilder >> reset [
	super reset.
	curveItem := nil.
]
