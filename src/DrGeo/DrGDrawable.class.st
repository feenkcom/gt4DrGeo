"
I represent the area/place where a Drgeo figure is drawn. It is a subpart of the GeometricView
- valueItem, dottedLines: we can display dotted line between a selected value and its parents
- itemViews, undoneViews, lastView: represent my submorph who are item's morphs
"
Class {
	#name : #DrGDrawable,
	#superclass : #BoxedMorph,
	#instVars : [
		'balloonTarget',
		'tipOn',
		'selection',
		'ox',
		'oy',
		'scale',
		'underMouse',
		'prevMousePos',
		'valueItem',
		'dottedLines',
		'gridScale',
		'itemViews',
		'undoneViews',
		'lastView',
		'presenter'
	],
	#category : #'DrGeo-View'
}

{ #category : #'new-morph participation' }
DrGDrawable class >> includeInNewMorphMenu [
	^ false
]

{ #category : #'instance creation' }
DrGDrawable class >> newOn: aPresenter [
	^self basicNew presenter: aPresenter ; initialize 
]

{ #category : #'dropping/grabbing' }
DrGDrawable >> acceptDroppingMorph: dropped event: evt [
"Here we encapsulated the image morph (dropped) in a DrGBitmapItem.
We do not really need a builder to do so but we have to process it in the command stack"
	| item |
	item := (DrGBitmapItem newWith: {self morphToWorld: evt eventPosition})
		data: (self resizeImage: dropped form);
		insertAtScale: self scale.
	self domain createFromMathItem: item.
]

{ #category : #'submorphs-add/remove' }
DrGDrawable >> addMorph: newMorph [
	| aLabel |
	newMorph class == DrGLabel ifTrue: [^ self addMorphFront: newMorph].
	aLabel := self mostBehindLabel.
	aLabel 
		ifNil: [self addMorphFront: newMorph]  
		ifNotNil: [self addMorph: newMorph behind: aLabel]
]

{ #category : #'event handling testing' }
DrGDrawable >> allowsSubmorphDrag [
"We are managing by our self item dragging"
	^ false
]

{ #category : #'axes/grid' }
DrGDrawable >> axesVisible [
	^ self valueOfProperty: #axesVisible ifAbsent: [false]
]

{ #category : #'axes/grid' }
DrGDrawable >> axesVisibleOnOff [
	self setProperty: #axesVisible toValue: self axesVisible not.
	self updateGrid.
	self redrawNeeded 
]

{ #category : #'geometry testing' }
DrGDrawable >> clipsSubmorphs [
	^ true
]

{ #category : #coordinates }
DrGDrawable >> defaultScalePosition [
	ox := oy := 0.0.
	scale := 34.0.
	self updateGrid.
	self redrawNeeded
]

{ #category : #'item-view' }
DrGDrawable >> deleteItemView: aMorph [
	aMorph release.
	undoneViews add: aMorph.
	itemViews := itemViews copyWithout: aMorph.
	
]

{ #category : #'initialize-release' }
DrGDrawable >> dismissMorph [
	super dismissMorph.
	presenter view dismissMorph 
]

{ #category : #accessing }
DrGDrawable >> domain [
	^ presenter domain
]

{ #category : #drawing }
DrGDrawable >> dottedLinesToParentsOf: anItem [
	| point pointWorld | 
	(anItem isValueItem not or: [anItem parents isEmptyOrNil]) ifTrue: [^self ].
	valueItem := anItem.
	point := (self viewOf: valueItem) morphCenter.
	pointWorld := self morphToWorld: point.
	dottedLines := valueItem parents collect: [:item |
		(DrGPolylineMorph 
			from: point
			to: (self worldToMorph: (item closestPointTo: pointWorld)) 
			color: Color red 
			width: 0.5
			in: self) 
			arrow: #forward;
			dashedBorder:  {1. 5};
			yourself].
	dottedLines do: [:line | self addMorphFront: line].
]

{ #category : #'drawing axes & grid' }
DrGDrawable >> drawAxesOn: aCanvas [
	| origin worldBound font p start |
	origin := self worldToMorph: 0@0.
	worldBound := self worldBound.
	font := DrGeoSystem canvasFont.
	
	"x-axis"
	(origin y > 0 and: [origin y < extent y]) ifTrue: [
		aCanvas line: 0 @ origin y  to: extent x @ origin y width: 1 color: Color lightGray.		
		"x labels in [0 ; +inf["
		start := worldBound origin x > gridScale 
			ifTrue: [worldBound origin x roundUpTo: gridScale] 
			ifFalse: [gridScale].
		start to: (worldBound corner x roundDownTo: gridScale) by: gridScale do: [:x | 
			self drawGradX: x origin: origin on: aCanvas font: font].
		"x labels in ]-inf ; 0["
		gridScale negated to: (worldBound origin x roundUpTo: gridScale) by: gridScale negated do: [:x |
			self drawGradX: x origin: origin on: aCanvas font: font].
		"orientation"
		p := extent x - 2 @ origin y.
		aCanvas line: p  to: p - (4 @ 4) width: 1 color: Color lightGray;
			line: p to: p - (4 @ -4) width: 1 color: Color lightGray].
	
	"y-axis"
	(origin x > 0 and: [origin x < extent x]) ifTrue: [
		aCanvas 	line: origin x @ 0 to: origin x @ extent y width: 1 color: Color lightGray.
		"y labels in [0 ; +inf["
		gridScale to: (worldBound corner y roundDownTo: gridScale) by: gridScale do: [:y | 
			self drawGradY: y origin: origin on: aCanvas font: font].
		"y labels in ]-inf ; 0["
		start := worldBound corner y < gridScale negated
			ifTrue: [worldBound corner y roundDownTo: gridScale] 
			ifFalse: [gridScale negated].
		start to: (worldBound origin y roundUpTo: gridScale) by: gridScale negated do: [:y |
			self drawGradY: y origin: origin on: aCanvas font: font].
		"orientations"
		p :=  origin x @ 0.
		aCanvas line: p  to: p + (4 @ 4) width: 1 color: Color lightGray;
			line: p to: p + (-4 @ 4) width: 1 color: Color lightGray].

	"The origin"
	(self morphLocalBounds containsPoint: origin) ifTrue: [
		aCanvas drawString: '0'  at: (origin + (2@2)) font: font color: Color lightGray].

]

{ #category : #'drawing axes & grid' }
DrGDrawable >> drawGradX: x origin: origin on: canvas font: font [
"Draw a tick on the (ox) axis with a graduation value"
	| str pos shift |
	pos := (self worldAbscissaToMorph: x asFloat) @ origin y.
	str := self labelForAxes: x.
	shift := self gridVisible ifTrue: [2@6] ifFalse: [(font widthOfString: str) / -2.0 @6].
	canvas drawString: str  at: pos + shift font: font color: Color lightGray.
	canvas line: pos - (0@2) to: pos + (0@2) width: 1.5 color: Color lightGray.
]

{ #category : #'drawing axes & grid' }
DrGDrawable >> drawGradY: y origin: origin on: canvas font: font [
"Draw a tick on the (oy) axis with a graduation value"
	| pos shift |
	pos := origin x @ (self worldOrdinateToMorph: y asFloat).
	shift := self gridVisible ifTrue: [5@2] ifFalse: [5 @ (font lineSpacing / -2.0)].
	canvas 
		drawString: (self labelForAxes: y)  
		at: pos + shift 
		font: font 
		color: Color lightGray.
	canvas line: pos - (2@0) to: pos + (2@0)  width: 1.5 color: Color lightGray.
]

{ #category : #'drawing axes & grid' }
DrGDrawable >> drawGridOn: aCanvas [
	| worldBound end start length step |
	worldBound := self worldBound.
	step := self worldToPixel: gridScale.
	"horizontal lines"
	length := extent x.
	start := self worldOrdinateToMorph: (worldBound corner y 	roundTo: gridScale).
	start < 0 ifTrue: [start := start + step].
	end := extent y.
	start to: end by: step do: [:y |
		aCanvas line: 0 @ y to: length @ y  width: 0.4 color: Color lightGray].
	""
	"vertical lines"
	length := extent y.
	start := self worldAbscissaToMorph: (worldBound origin x 	roundTo: gridScale).
	start < 0 ifTrue: [start := start + step].
	end := extent x.
	start to: end by: step do: [:x |
		aCanvas line: x @ 0 to: x @ length width: 0.4 color: Color lightGray]
]

{ #category : #drawing }
DrGDrawable >> drawOn: aCanvas [ 
	super drawOn: aCanvas.
	self gridVisible ifTrue: [self drawGridOn: aCanvas].
	self axesVisible ifTrue: [ self drawAxesOn: aCanvas].
]

{ #category : #'item-view' }
DrGDrawable >> fastLastItemView [
"Find the morph in the factory last mathItem, cahed version, may not update to date"
	^ lastView 
]

{ #category : #'item-view' }
DrGDrawable >> forcedVisibility: aBoolean [
"Force or not the visibility of hidden morph"
	aBoolean ifTrue: [self redrawNeeded ].
	itemViews do: [:morph |
		morph forcedVisibility: aBoolean].
]

{ #category : #gridding }
DrGDrawable >> gridPoint: ungriddedPoint [
	self presenter isGridded ifFalse: [^ungriddedPoint].
	"do it the easy way"
	^self worldToMorph: ((self morphToWorld: ungriddedPoint) roundTo: gridScale)
]

{ #category : #'axes/grid' }
DrGDrawable >> gridVisible [
	^ self 	valueOfProperty: #gridVisible ifAbsent: [false]

]

{ #category : #'axes/grid' }
DrGDrawable >> gridVisibleOnOff [
	self setProperty: #gridVisible toValue: self gridVisible not.
	self updateGrid.
	self redrawNeeded 
]

{ #category : #gridding }
DrGDrawable >> gridWorldPoint: ungriddedPoint [
	self presenter isGridded ifFalse: [^ self morphToWorld: ungriddedPoint].
	"do it the easy way"
	^(self morphToWorld: ungriddedPoint) roundTo: gridScale
]

{ #category : #gridding }
DrGDrawable >> gridWorldVector: ungriddedPoint [
	self presenter isGridded ifFalse: [^ self morphToVector: ungriddedPoint].
	"do it the easy way"
	^(self morphToVector: ungriddedPoint) roundTo: gridScale
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesKeyboard [
	^ true
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesMouseDown: evt [
	^ true
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesMouseHover [
	^ true
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesMouseOver: evt [
	^ true
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesMouseScroll: scrollEvent [
	^ true
]

{ #category : #'event handling testing' }
DrGDrawable >> handlesMouseStillDown: evt [
	^ true
]

{ #category : #tip }
DrGDrawable >> hideTip [
	balloonTarget deleteBalloon.
	self removeMorph: balloonTarget.
]

{ #category : #'initialize-release' }
DrGDrawable >> initialize [
	super initialize.
	self color: Theme current canvasBackground.
	self borderWidth: 0.
	tipOn := true.
	self defaultScalePosition.
	balloonTarget := BoxedMorph new 
		color: Color transparent;
		borderWidth: 0; 
		morphExtent: 6 @ 6;
		yourself.
	itemViews := OrderedCollection new.
	undoneViews := OrderedCollection new.
	self registerEvents .
	self flag: #drgeoTodo.
	"For tablet to see what is under the finger"
	"morphExtent: DrGeoSystem replicateDisplayWidth asPoint;
		yourself.
	self addMorphBack: underMouse.
	underMouse 
		morphPosition: self morphPosition;
		hide."	
]

{ #category : #'item-view' }
DrGDrawable >> itemView: aMathItem [ 
	"new math item event : A new math item has been created, create its morph"
	lastView := itemViews add: (DrGMorph for: aMathItem in: self)
]

{ #category : #'item-view' }
DrGDrawable >> itemViews [
	^ itemViews 
]

{ #category : #'drawing axes & grid' }
DrGDrawable >> labelForAxes: number [
	gridScale isFloat 
		ifTrue: [|integer|
			integer := number asInteger.
			integer = number ifTrue: [^ integer printString]].
		^ (number isInteger not and: [number isFraction]) 
			ifTrue: [number printString allButFirst allButLast]
			ifFalse: [ number printString]
]

{ #category : #accessing }
DrGDrawable >> labels [
	^ submorphs select: [:aMorph| aMorph class == DrGLabel].
		
]

{ #category : #'item-view' }
DrGDrawable >> lastItemView [
"Find the morph in the factory last mathItem"
	| lastMathItem morph |
	morph := itemViews last.
	morph mathItem = self domain factory last ifTrue: [^ morph].
	lastMathItem := self domain factory last.
	^ itemViews 
		detect: [:aMorph | aMorph mathItem = lastMathItem]
		ifFound: [ :aMorph | aMorph ]
		ifNone: [ nil]
]

{ #category : #coordinates }
DrGDrawable >> morphAbscissaToWorld: abscissa [
	"Transform abscissa from DrGeo-Morph to World  system"
	^ ox + ((abscissa - (extent x / 2.0)) / scale)

]

{ #category : #coordinates }
DrGDrawable >> morphOrdinateToWorld: ordinate [
	"Transform point coordinate from DrGeo-Morph to World  system"
	^ oy - ((ordinate  - (extent y / 2.0)) / scale)
]

{ #category : #coordinates }
DrGDrawable >> morphToVector: aPoint [
"Transform vector coordinates in the morph system to the DrGeo system"
	^ Point 
		x: aPoint x asFloat / scale
		y: aPoint y negated asFloat / scale.

]

{ #category : #coordinates }
DrGDrawable >> morphToWorld: aPoint [
	"Transform point coordinate from DrGeo-Morph to World  system"
	^ Point 
		x: (self morphAbscissaToWorld: aPoint x)
		y: (self morphOrdinateToWorld: aPoint y)
]

{ #category : #accessing }
DrGDrawable >> mostBehindLabel [
^ submorphs reverse detect: [:aMorph| aMorph class == DrGLabel] ifNone: [nil].
		
]

{ #category : #events }
DrGDrawable >> mouseButton1Down: evt localPosition: localPosition [
	evt shiftPressed 
		ifTrue: [self tool handlePressShiftKey: localPosition ]
		ifFalse: 	[self tool handlePress: localPosition].
	self showUnderMouseMorph
]

{ #category : #events }
DrGDrawable >> mouseButton1Up: evt localPosition: localPosition [
	evt shiftPressed 
		ifTrue: [self tool handleReleaseShiftKey: localPosition]
		ifFalse: [self tool handleRelease: localPosition ].
	"underMouse hide." self flag: #drgeoTodo.
	(self morphLocalBounds containsPoint: localPosition) 
		ifFalse: [Cursor normalCursorWithMask activateCursor.]

]

{ #category : #events }
DrGDrawable >> mouseButton2Up: evt localPosition: localPosition [
	self presenter openTools
]

{ #category : #events }
DrGDrawable >> mouseEnter: evt [
	(Preferences at: #focusFollowsMouse) ifTrue: [
	    evt hand newKeyboardFocus: self.
	    self redrawNeeded ].
]

{ #category : #events }
DrGDrawable >> mouseHover: evt localPosition: localEventPosition [
"handle mouse move with button up"
	localEventPosition = prevMousePos ifTrue: [^ self]. "nothing to process"
	evt shiftPressed 
		ifTrue: [self tool handleShiftKeyMouseAt: localEventPosition]
		ifFalse: [self tool handleMouseAt: localEventPosition].
	prevMousePos := localEventPosition
]

{ #category : #events }
DrGDrawable >> mouseLeave: evt [
	super mouseLeave: evt.
	Cursor normalCursorWithMask activateCursor.
	
]

{ #category : #events }
DrGDrawable >> mouseMove: evt localPosition: localEventPosition [
"Mouse move with pressed button"
	evt shiftPressed 
		ifTrue: [self tool handleShiftKeyMouseAt: localEventPosition ]
		ifFalse: [	
			((self tool handleMouseAt: localEventPosition) or: [self tool isBuilding]) 
				ifFalse: [self mouseMoveOxy: localEventPosition]
		].		
	self updateUnderMouseMorphPosition.
	prevMousePos := localEventPosition.

]

{ #category : #events }
DrGDrawable >> mouseMoveOxy: newPosition [
"move the whole sketch in the Oxy plane"
	|delta| 
	delta := newPosition - prevMousePos.
	delta r  < 100 ifTrue: "we need to check because in tablet mode, previous mouse position can be far away"
		[self moveOxy: (self pixelVectorToWorldVector: delta)]
]

{ #category : #events }
DrGDrawable >> mouseScroll: evt localPosition: localEventPosition [
	| increment orginalWorldCursorPoint |
	orginalWorldCursorPoint := self morphToWorld: localEventPosition.
"	WAIT for proper wheel event with modifier keys always on
	increment := evt shiftPressed ifTrue: [10] ifFalse: [2]."
	increment := 0.5.
	evt direction == #down
		ifTrue: [ self scaleNoRedraw: increment ].
	evt direction == #up
		ifTrue: [ self scaleNoRedraw: increment negated ].
	"cursor point is at a constant world position"
	self updateGrid.
	self
		moveOxy: (self morphToWorld: localEventPosition) - orginalWorldCursorPoint
]

{ #category : #events }
DrGDrawable >> mouseStillDown [
	self tool handleStillPress: prevMousePos
]

{ #category : #events }
DrGDrawable >> mouseStillDownThreshold [ 
	^ 1500
]

{ #category : #callback }
DrGDrawable >> moveOx: increment [
	ox := ox - increment.
	self redrawNeeded
]

{ #category : #callback }
DrGDrawable >> moveOxy: pointIncrement [
	ox := ox - pointIncrement x.
	oy := oy - pointIncrement y.
	self redrawNeeded.
]

{ #category : #callback }
DrGDrawable >> moveOy: increment [
	oy := oy + increment.
	self redrawNeeded
]

{ #category : #accessing }
DrGDrawable >> ox [
"abscisa of the center of the visible canvas, in world coordinates, at start up it is equal 0"
	^ ox
]

{ #category : #accessing }
DrGDrawable >> ox: integer [
	ox := integer asNumber
]

{ #category : #accessing }
DrGDrawable >> oy [
"ordinate of the center of the visible canvas, in world coordinates, at start up it is equal 0"
	^ oy
]

{ #category : #accessing }
DrGDrawable >> oy: integer [
	oy := integer asNumber
]

{ #category : #coordinates }
DrGDrawable >> pixelToWorld: pixels [
"Transform morph pixel unit to Dr. Geo world unit"
	^ pixels asFloat / scale


]

{ #category : #coordinates }
DrGDrawable >> pixelVectorToWorldVector: pixelVector [
"Transform morph pixel unit to Dr. Geo world unit"
	^ (pixelVector asFloatPoint / scale) * (1 @ -1)

]

{ #category : #accessing }
DrGDrawable >> presenter [
	^ presenter
]

{ #category : #accessing }
DrGDrawable >> presenter: aPresenter [
	presenter := aPresenter 
]

{ #category : #accessing }
DrGDrawable >> preview [
"Return a form preview"
	^ self previewOn: ByteArray new writeStream
]

{ #category : #accessing }
DrGDrawable >> previewOn: aStream [
"compute an PNG preiview, put it in the stream and return its form"
	|form |
	form := (self imageForm: 32) magnifyBy: Theme current previewSize x / self morphExtent x.
	PNGReadWriter putForm: form onStream: aStream.
	^ form
]

{ #category : #events }
DrGDrawable >> processMouseMove: aMouseMoveEvent localPosition: localEventPosition [
"Overwritten to prevent superfluous mouseStillDown events"
	aMouseMoveEvent wasHandled ifTrue: [ ^self ]. 
	aMouseMoveEvent hand hasSubmorphs ifTrue: [ ^self ].
	(aMouseMoveEvent anyButtonPressed and: [ self hasMouseFocus ]) ifFalse: [ ^self ].
	aMouseMoveEvent wasHandled: true.
	self mouseMove: aMouseMoveEvent localPosition: localEventPosition.
]

{ #category : #'item-view' }
DrGDrawable >> recoverViewOf: aMathItem [ 
	"a redo math item event : a math item has been recalled, find its morph "
	| itemMorph |
	itemMorph := undoneViews 
		detect: [:morph | morph mathItem == aMathItem]
		ifFound: [:morph | morph ]
		ifNone: [^ self itemView: aMathItem].
	itemMorph mathItem: aMathItem.
	itemMorph reInitialize.
	undoneViews := undoneViews copyWithout: itemMorph.
	itemViews add: itemMorph
]

{ #category : #'item-view' }
DrGDrawable >> redrawNeeded [
	"View resized, update the area without recomputing the items"
	self updateGrid.
	super redrawNeeded.
	presenter tool ifNotNil: [:aTool | aTool redrawFlyingMorph ]
]

{ #category : #'initialize-release' }
DrGDrawable >> registerEvents [
	self domain
		when: #redoMathItem
		send: #recoverViewOf:
		to: self.
	self domain
		when: #newMathItem
		send: #itemView:
		to: self.
	self domain
		when: #updatedItems
		send: #redrawNeeded
		to: self.
	self domain
		when: #updatedDirtyItems
		send: #redrawNeeded
		to: self.
]

{ #category : #'initialize-release' }
DrGDrawable >> release [
	self domain removeActionsWithReceiver: self.
	itemViews do: [:each | each release]
]

{ #category : #drawing }
DrGDrawable >> removeDottedLinesToParents [
	valueItem ifNil: [^self].
	dottedLines do: [:line | self removeMorph: line].
	dottedLines := nil.
	valueItem := nil
]

{ #category : #'geometry testing' }
DrGDrawable >> requiresVectorCanvas [
	^ true
]

{ #category : #'dropping/grabbing' }
DrGDrawable >> resizeImage: aForm [
"Reszie the image to a maximum pixel number"
	| resizedForm maxPixels size ratio |
	maxPixels := 250000.
	size := aForm extent x * aForm extent y.
	size > maxPixels 
		ifTrue: [ratio := (maxPixels  / size) sqrt.
			resizedForm := aForm magnifyBy: ratio]
		ifFalse: [resizedForm  := aForm].
	^ resizedForm 
]

{ #category : #events }
DrGDrawable >> restartMouseStillDownHandle [
"We reset the timer"
	prevMousePos ifNotNil: [	
		self startStepping: #processMouseStillDown 
			in: 1500
			stepTime: self mouseStillDownStepRate]
]

{ #category : #accessing }
DrGDrawable >> scale [
	^ scale
]

{ #category : #accessing }
DrGDrawable >> scale: increment [
	self scaleNoRedraw: increment.
	self updateGrid.
	self redrawNeeded 
]

{ #category : #accessing }
DrGDrawable >> scaleNoRedraw: increment [
	scale := (scale + increment) .
	scale < 1 ifTrue: [scale := 1.0].
	scale > 1000 ifTrue: [scale := 1000.0].

]

{ #category : #accessing }
DrGDrawable >> setScaleTo: number [
	scale := number asNumber.
	self updateGrid.
	self redrawNeeded 
]

{ #category : #'under mouse' }
DrGDrawable >> showUnderMouseMorph [
	DrGeoSystem ifTablet: [
		self updateUnderMouseMorphPosition.
		underMouse 
			comeToFront;
			show].
]

{ #category : #stepping }
DrGDrawable >> step [
	self tool animate
]

{ #category : #stepping }
DrGDrawable >> stepTime [ 
	^ 300
]

{ #category : #tip }
DrGDrawable >> tip: aText at: aPoint [
	tipOn ifFalse: [^self].
	self addMorphBack: balloonTarget.
	DrGeoSystem isTablet
		ifTrue: [balloonTarget morphCenter: aPoint + (40 @ -40)]
		ifFalse: [balloonTarget morphCenter: aPoint].
	balloonTarget setBalloonText: aText.
	balloonTarget showBalloon: (balloonTarget balloonText)
]

{ #category : #tip }
DrGDrawable >> toggleTip [
	tipOn := tipOn not
]

{ #category : #accessing }
DrGDrawable >> tool [
	^self presenter tool
]

{ #category : #drawing }
DrGDrawable >> updateDottedLinesToParents [
	| point pointWorld |
	valueItem ifNil: [^self].
	point := (self viewOf: valueItem) morphCenter.
	pointWorld := self morphToWorld: point.
	dottedLines with: valueItem parents do: [:line :parent|
		line vertices: (
			Array 
				with: point 
				with: (self worldToMorph: (parent closestPointTo: pointWorld)))]
]

{ #category : #gridding }
DrGDrawable >> updateGrid [
	self axesVisible 
		ifTrue: [ self updateGridScaleForAxes]
		ifFalse: [ self updateGridScaleForGrid]
]

{ #category : #gridding }
DrGDrawable >> updateGridScaleForAxes [
	gridScale := 50 / scale.
	gridScale >= 1 
		ifTrue: [
			gridScale := gridScale roundTo: 0.5.
			gridScale asInteger = gridScale ifTrue: [gridScale := gridScale asInteger]] 
		ifFalse: [
			gridScale := 1 / ((1 / gridScale) rounded)]
]

{ #category : #gridding }
DrGDrawable >> updateGridScaleForGrid [
	gridScale := 5
]

{ #category : #'under mouse' }
DrGDrawable >> updateUnderMouseMorph [
	DrGeoSystem ifTablet: [underMouse changed]
]

{ #category : #'under mouse' }
DrGDrawable >> updateUnderMouseMorphPosition [
	DrGeoSystem ifTablet: 
		[self activeHand morphPosition x - self morphPosition x > (self morphWidth // 2 )
			ifTrue: [underMouse position: self morphPosition] 
			ifFalse: [underMouse position: (self morphWidth - underMouse width) @ self morphPosition y]]
]

{ #category : #coordinates }
DrGDrawable >> vectorToMorph: aVector [
"Transform vector coordinates in the Dr. Geo system to the morph system"
	^ Point 
		x: aVector x asFloat * scale
		y: aVector y negated asFloat * scale.

]

{ #category : #accessing }
DrGDrawable >> view [
	^presenter view
]

{ #category : #'item-view' }
DrGDrawable >> viewOf: aMathItem [
"Find the view of the given mathItem"
	^ itemViews 
		detect: [:morph | morph mathItem == aMathItem]
		ifFound: [ :morph | morph ]
		ifNone: [ nil]
]

{ #category : #'item-view' }
DrGDrawable >> viewsOf: aMathItemCollection [
"Find the morphs of the given mathItem collection"
	^ aMathItemCollection collect: [:aMathItem | self viewOf: aMathItem]

]

{ #category : #'halos and balloon help' }
DrGDrawable >> wantsHalo [
	^true
]

{ #category : #stepping }
DrGDrawable >> wantsSteps [
	^ (self presenter isTool: #animate) and: [self tool isAnimating]
]

{ #category : #coordinates }
DrGDrawable >> worldAbscissaToMorph: x [
	"Transform point abscissa from DrGeo-World to Morph system"
	^extent x / 2.0 + (scale * (x - ox))
]

{ #category : #coordinates }
DrGDrawable >> worldBound [
	^ Rectangle
		origin: (self morphToWorld: 0 @ extent y)
		corner: (self morphToWorld: extent x @ 0)
]

{ #category : #coordinates }
DrGDrawable >> worldOrdinateToMorph: y [
	"Transform point ordinate from DrGeo-World to Morph system"
	^ extent y / 2.0 + (scale * (oy - y))
]

{ #category : #coordinates }
DrGDrawable >> worldToMorph: aPoint [
	"Transform point coordinate from DrGeo-World to Morph system"
	^ (self worldAbscissaToMorph: aPoint x) @ (self worldOrdinateToMorph: aPoint y)
]

{ #category : #coordinates }
DrGDrawable >> worldToPixel: aFloat [
"Transform Dr. Geo world unit to morph unit"
	^ aFloat * scale


]

{ #category : #callback }
DrGDrawable >> zoom: anExtent [
	scale := (scale + ((anExtent x + anExtent y) / 5)) asInteger.
	scale := scale min: 200.
	self updateGrid.
	self redrawNeeded
]
