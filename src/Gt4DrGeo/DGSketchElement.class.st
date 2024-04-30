Class {
	#name : #DGSketchElement,
	#superclass : #BlElement,
	#instVars : [
		'sketch'
	],
	#category : #'Gt4DrGeo-View'
}

{ #category : #'instance creation' }
DGSketchElement class >> for: aSketch [
	^ self new
		sketch: aSketch;
		yourself
]

{ #category : #conversion }
DGSketchElement >> asPinchable [
	^ BlPinchableElement new
		zoomLevel: 2;
		clipChildren: false;
		contentElement: self;
		border: (BlBorder paint: Color lightGray)
]

{ #category : #conversion }
DGSketchElement >> asPinchablePannable [
	| sketchPannable  sketchPinchable |
	sketchPinchable := self asPinchable.
	sketchPannable := sketchPinchable asPannableElement
			border: (BlBorder paint: Color orange);
			padding: (BlInsets all: self padding);
			margin: (BlInsets all: self margin);
			when: BlDoubleClickEvent
				do: [ :evt | 
					| newNode |
					newNode := self makeNode asElement.
					self addChild: newNode.
					newNode relocate: (sketchPinchable globalPointToLocal: evt position) ];
			aptitude: (BrGlamorousWithContextMenuAptitude
					content: [ BrGlamorousSimpleContextMenuContent new
							items: {'Inspect graph' -> [ self inspect ]};
							yourself ]).
	^ sketchPannable
]

{ #category : #example }
DGSketchElement >> demo [
	<gtExample>
	^ self class new asPinchablePannable
]

{ #category : #view }
DGSketchElement >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 0;
		object: [ self asPinchablePannable ];
		view: #gtLiveFor:
]

{ #category : #initialization }
DGSketchElement >> initialize [
	super initialize.
	self initializeLayout
]

{ #category : #initialization }
DGSketchElement >> initializeLayout [
	self
		layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: self padding);
		margin: (BlInsets all: self margin);
		background: Color white;
		effect: BrGlamorousShadowEffect new
]

{ #category : #accessing }
DGSketchElement >> makeNode [
	| makeNode |
	makeNode := [ | node |
		node := BlElement new.
		node
			layout: BlFrameLayout new;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			background: Color white;
			constraintsDo: [ :c | 
				c horizontal fitContent.
				c vertical fitContent ];
			padding: (BlInsets all: 10).
		node graph beNode.
		node
			aptitude: (BrStyleCommonAptitude new
					default: [ :aStyle | aStyle border: (BlBorder paint: Color black width: 1) ];
					hovered: [ :aStyle | aStyle border: (BlBorder paint: Color red width: 1) ])
					+ ((BrGlamorousWithContextMenuAptitude
							content: [ BrGlamorousSimpleContextMenuContent new
									items: {'Inspect node' -> [ node inspect ]};
									yourself ])
							useSecondaryMouseButton;
							yourself).
		node addEventHandler: BlPullHandler new.
		node
			addEventHandler: (BlEventHandler
					on: BlDoubleClickEvent
					do: [ :evt | 
						evt consumed: true.
						node phlow spawnObject: node ]).
		node ] asStencil.
	^ makeNode
]

{ #category : #accessing }
DGSketchElement >> margin [
	| margin |
	margin := self padding.
	^ margin
]

{ #category : #accessing }
DGSketchElement >> padding [
	| padding |
	padding := 2.
	^ padding
]

{ #category : #accessing }
DGSketchElement >> sketch [
	^ sketch
]

{ #category : #accessing }
DGSketchElement >> sketch: anObject [
	sketch := anObject
]
