Class {
	#name : #DGSketchHolder,
	#superclass : #Object,
	#category : #'Gt4DrGeo-View'
}

{ #category : #accessing }
DGSketchHolder >> demo [
	<gtExample>
	| graph graphHolder graphContainer  |
	"The graph element (white with shading) holds the actual graph nodes. It adapts its size to its children with a BlWrapAroundChildrenLayout layout."
	"The graphContainer (orange border) supports panning and handles the background events for the graph (context menu and node creation)."
	"A constructor stencil in lieu of a method. Note that we use a stencil instead of just a block so we can have a live view of it."
	graph := self sketchGraph.
	
	
	graphHolder := self sketchHolder: graph.
	graphContainer := self sketchContainer: graphHolder.

	graphContainer
		when: BlDoubleClickEvent
		do: [ :evt | 
			| newNode |
			newNode := self makeNode asElement.
			graph addChild: newNode.
			newNode relocate: (graphHolder globalPointToLocal: evt position) ].
	graphContainer
		aptitude: (BrGlamorousWithContextMenuAptitude
				content: [ BrGlamorousSimpleContextMenuContent new
						items: {'Inspect graph' -> [ graph inspect ]};
						yourself ]).

	^ graphContainer
]

{ #category : #accessing }
DGSketchHolder >> makeNode [
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
DGSketchHolder >> margin [
	| margin |
	margin := self padding.
	^ margin
]

{ #category : #accessing }
DGSketchHolder >> padding [
	| padding |
	padding := 2.
	^ padding
]

{ #category : #accessing }
DGSketchHolder >> sketchContainer: graphHolder [
	| graphContainer |
	graphContainer := graphHolder asPannableElement
			border: (BlBorder paint: Color orange);
			padding: (BlInsets all: self padding);
			margin: (BlInsets all: self margin).
	^ graphContainer
]

{ #category : #accessing }
DGSketchHolder >> sketchGraph [
	| graph |
	graph := BlElement new.
	graph
		layout: (BlWrapAroundChildrenLayout new addLayout: BlBasicNodeBasedLayout new);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: self padding);
		margin: (BlInsets all: self margin).

	graph
		background: Color white;
		effect: BrGlamorousShadowEffect new.
	^ graph
]

{ #category : #accessing }
DGSketchHolder >> sketchHolder: graph [
	| graphHolder |
	graphHolder := BlPinchableElement new
			zoomLevel: 2;
			clipChildren: false;
			contentElement: graph;
			border: (BlBorder paint: Color lightGray).
	^ graphHolder
]
