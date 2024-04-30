"
I am a prototype for a Sktech Element.
"
Class {
	#name : #DGSketchElementDemo,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #accessing }
DGSketchElementDemo >> demo [
	<gtExample>
	| sketchContainer sketchGraph sketchHolder |
	
	sketchGraph := self sketchGraph.

	sketchHolder := BlPinchableElement new
			zoomLevel: 2;
			clipChildren: false;
			contentElement: sketchGraph;
			border: (BlBorder paint: Color lightGray).

	sketchContainer := sketchHolder asPannableElement
			border: (BlBorder paint: Color orange);
			padding: (BlInsets all: self padding);
			margin: (BlInsets all: self margin);
			when: BlDoubleClickEvent
				do: [ :evt | 
					| newNode |
					newNode := self makeNode asElement.
					sketchGraph addChild: newNode.
					newNode relocate: (sketchHolder globalPointToLocal: evt position) ];
			aptitude: (BrGlamorousWithContextMenuAptitude
					content: [ BrGlamorousSimpleContextMenuContent new
							items: {'Inspect graph' -> [ sketchGraph inspect ]};
							yourself ]).


	^ sketchContainer
]

{ #category : #accessing }
DGSketchElementDemo >> makeNode [
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
DGSketchElementDemo >> margin [
	| margin |
	margin := self padding.
	^ margin
]

{ #category : #accessing }
DGSketchElementDemo >> padding [
	| padding |
	padding := 2.
	^ padding
]

{ #category : #accessing }
DGSketchElementDemo >> sketchGraph [
	^ BlElement new
		layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: self padding);
		margin: (BlInsets all: self margin);
		background: Color white;
		effect: BrGlamorousShadowEffect new
]
