"
This is the root class of the MathBuilder hierarchy responsible to create new mathematic items.
A builder instance is specialized to build one type of object: free point, constrained point, line, segment, transformed mathItem...
To effectively build a new mathItem, the builder need to be fed with mathItem with 
the add:at: message.
At any time it is possible to check wheter the build process is terminated or not with the readyToBuild message.
Related patterns: BUILD, TEMPLATE METHOD
"
Class {
	#name : #DrGMathItemBuilder,
	#superclass : #ActiveModel,
	#instVars : [
		'point',
		'flyingItem',
		'flyingMorph',
		'movingPoint',
		'presenter'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #xml }
DrGMathItemBuilder class >> basicItemFrom: node [
"create a basic item (unitialised) from this node and add it to the domain, return an item partially initialized. Used for macro node"
	| builder |
	builder := self new.
	^ builder basicItemFrom: node
]

{ #category : #documentation }
DrGMathItemBuilder class >> description [
	"A description how to use the tool"
	self subclassResponsibility
]

{ #category : #xml }
DrGMathItemBuilder class >> itemFrom: node in: aPresenter [
"create an item from this node and add it to the domain, return a couple {item. boolean}"
	| builder |
	builder := self new presenter: 	aPresenter ; yourself.
	^ builder itemFrom: node
]

{ #category : #documentation }
DrGMathItemBuilder class >> title [
	"One or two words describing the builder"
	self subclassResponsibility 
]

{ #category : #building }
DrGMathItemBuilder >> add: aMathItemCollection at: aPoint [
"Add a math item in the selection list of the builder,
aPoint is the position where the action took place
Return true if mathItem accepted"
	(self isWanted: aMathItemCollection at: aPoint) ifTrue:
		[self addItem: aMathItemCollection at: aPoint.
		"Are we done? If so notify our dependent"
		self readyToBuild ifTrue: 
			[self triggerEvent: #readyToBuild].
		^true].
	^false

]

{ #category : #private }
DrGMathItemBuilder >> addItem: aMathItemCollection at: aPoint [
	point := aPoint.
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> addToFlyingItem: anItem [
 "Add an item to the flying item representing the item built by this builder "
	self isNotInteractive ifTrue: [^self].
	movingPoint := DrGPointFreeItem new point: point + (0.1 @ 0.1).
	flyingItem := self mathItemClass newWith: self flyingMathItemArguments.
	self initializeFlyingMorph

]

{ #category : #private }
DrGMathItemBuilder >> addToggleItem: aMathItemCollection in: aCollection [
	aCollection 
		remove: aMathItemCollection first 
		ifAbsent: [aCollection add: aMathItemCollection first]

]

{ #category : #accessing }
DrGMathItemBuilder >> arguments [
"an argument list to give to the MathItem new method"
	self subclassResponsibility 
]

{ #category : #xml }
DrGMathItemBuilder >> basicItemFrom: node [
| type itemClass item|
	"build the item class name from the node description"
	type := ((node  attributeAt: #type) copyWithoutAll: '_') capitalized.
	itemClass := Smalltalk
		classNamed: ('DrG' , node tag capitalized , type , 'Item') asSymbol.
	item := itemClass new yourself.
	self postProcess: item from: node.
	^ item
]

{ #category : #building }
DrGMathItemBuilder >> buildItem [
	| itemDefinitions |
	itemDefinitions := self mathItemClass.
	^ itemDefinitions isCollection 
		ifFalse:	[{itemDefinitions newWith: self arguments in: presenter}]
		ifTrue: [point := point + (0.2@1.3).
			itemDefinitions collect: [:class | 
				point := point - (0@0.5).
				class newWith: self arguments in: presenter]]
]

{ #category : #accessing }
DrGMathItemBuilder >> domain [
	^ presenter domain
]

{ #category : #accessing }
DrGMathItemBuilder >> drawable [
	^ presenter drawable
]

{ #category : #accessing }
DrGMathItemBuilder >> factory [
	^ self domain factory
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> flyingMathItemArguments [
	self subclassResponsibility 
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> flyingMorphClass [
	self subclassResponsibility 
]

{ #category : #building }
DrGMathItemBuilder >> getItem [
	"return an instantiated mathItem or nil if not possible"
	self readyToBuild ifTrue:
		[^ self buildItem].
	^ nil.
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> initializeFlyingMorph [
	flyingMorph := self flyingMorphClass for: flyingItem in: presenter drawable.
	flyingMorph style 	color: Color lightRed
]

{ #category : #testing }
DrGMathItemBuilder >> isNotInteractive [
"Are we parsing the figure from a file"
	^ presenter isNotInteractive
]

{ #category : #testing }
DrGMathItemBuilder >> isWanted: aMathItemCollection [
"Check if the builder is interested by aMathItem"
	self subclassResponsibility 
]

{ #category : #testing }
DrGMathItemBuilder >> isWanted: aMathItemCollection at: aPoint [
"By default we don't need the point position of the click event'"
	^ self isWanted: aMathItemCollection 
]

{ #category : #xml }
DrGMathItemBuilder >> itemFrom: node [
	|item|
	item := self itemInstanceFrom: node.
	self postProcess: item from: node.
	^ {self domain createFromMathItemNoCommandNoFactoryCheck: item. true}
]

{ #category : #xml }
DrGMathItemBuilder >> itemInstanceFrom: node [
"build an item from a XML description"
	(self parentsById: node) do: [:each |	self addItem: {each} at: 0@0].
	^ self getItem first.

]

{ #category : #constant }
DrGMathItemBuilder >> mathItemClass [
"Answer the MathItem class for this builder (i.e. self FreePointItem,...)"
	self subclassResponsibility
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> moveFlyingMorphAt: aPoint [
	flyingMorph ifNotNil: [
		movingPoint moveAt: aPoint.
		flyingItem update.
		flyingMorph redrawNeeded]
]

{ #category : #xml }
DrGMathItemBuilder >> parentsById: node [
"return a collection of the item parent given theirs id in the attribute
elements <parent id=xxx>"
	|collection|
	collection := OrderedCollection new.
	node elementsDo: [:each | 
		(each tag = #parent) ifTrue: [
			collection add: (self factory findInPoolById: (each attributeAt: 'ref') asSymbol)]].
	^collection 
]

{ #category : #xml }
DrGMathItemBuilder >> parseValuePosition: node [
	| x y |
	x := (node contentStringAt: #x) asNumber.
	y := (node contentStringAt: #y) asNumber.
	^ x@y.
]

{ #category : #xml }
DrGMathItemBuilder >> parseValuePosition: node of: item [
	item position: (self parseValuePosition: node)
]

{ #category : #xml }
DrGMathItemBuilder >> postProcess: item from: node [
	item id: (node attributeAt: 'id') asSymbol.
	(item respondsTo: #isLocked) ifTrue: [
		(node attributeAt: #locked) = 'True'
			ifTrue: [item locked: true]
			ifFalse: [item locked: false]]
]

{ #category : #accessing }
DrGMathItemBuilder >> presenter: aPresenter [
	presenter := aPresenter 
]

{ #category : #testing }
DrGMathItemBuilder >> readyToBuild [
	"Can the builder build the math item now?"
	self subclassResponsibility 
]

{ #category : #'flying objects' }
DrGMathItemBuilder >> redrawFlyingMorph [ 
	flyingMorph ifNotNil: [flyingMorph redrawNeeded]
]

{ #category : #'as yet unclassified' }
DrGMathItemBuilder >> release [
	self releaseActionMap.
	self reset.
]

{ #category : #updating }
DrGMathItemBuilder >> reset [
	point := nil.
	flyingMorph ifNotNil:
		[flyingMorph release.
		flyingMorph := nil]
]
