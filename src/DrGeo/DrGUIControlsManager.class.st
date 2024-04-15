"
A manager for the DrGeo user interface controls (main view, menu, button, tree, etc.). 
- My subclasses may change how the tools are presented and accessed
- I hold the data and methods to build the UI
- I build the main Dr. Geo view (Window or simpler view)

"
Class {
	#name : #DrGUIControlsManager,
	#superclass : #Object,
	#instVars : [
		'presenter',
		'tools',
		'statusBar',
		'tree',
		'treeView',
		'editPanel',
		'quickToolbar',
		'view'
	],
	#category : #'DrGeo-View'
}

{ #category : #'instance creation' }
DrGUIControlsManager class >> exportIconSet [
"Export the icon set: name, description and icon as a PNG file
 See addButton:to: for icon data description"
	| buttons data path|
	path := '/tmp/DrGeoIcons/' asDirectoryEntry recursiveDelete assureExistence.
	data := self new.
	buttons := OrderedCollection new
		addAll: data miscTools;
		addAll: data pointTools; 		addAll: data curveTools; 		addAll: data transformationTools;
		addAll: data numericTools; 		addAll: data scriptTools;		addAll: data macroTools;
		addAll: data animateTools; 		yourself.
	buttons do: [:aButton | | iconDescription iconName |  		
		iconDescription := data perform: (aButton, #ButtonData) asSymbol.
		iconName := iconDescription second.
		(path / iconName) assureExistence.
		(path / iconName // 'description.txt') assureExistence 
			fileContents: iconDescription fourth.
		PNGReadWriter 
			putForm: (DrGIcons scale: iconDescription second to: 48) 
			onFile: path / iconName // (iconName, '.png')	 ].
	
]

{ #category : #'instance creation' }
DrGUIControlsManager class >> for: aPresenter [
	^ self basicNew
		presenter: aPresenter;
		initialize
]

{ #category : #'widget access' }
DrGUIControlsManager >> addChevron: symbolOrArray to: aToolbar [
	"array first = menu label or button label
	array second = button form = selection mode
	array third = symbol callback
	array fourth = help string	"	
	| array |
	symbolOrArray isSymbol 
		ifTrue: [	array := self perform: (symbolOrArray, #ButtonData) asSymbol]
		ifFalse: [ array := symbolOrArray].
	^ (aToolbar addButton: (DrGIcons for: array second))
		model: presenter;
		action: array third;
		state: (array at: 5 ifAbsent: [ #isTool: ]);
		argument: array second;
		setBalloonText: array fourth;
		yourself	
]

{ #category : #'tools data' }
DrGUIControlsManager >> angleBisectorButtonData [
	^ {DrGAngleBisectorBuilder  title. #angleBisector. #createAngleBisector. DrGAngleBisectorBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> angleGeometricButtonData [
	^ {DrGAngleGeometricBuilder title. #geometricAngle. #createAngleGeometric. DrGAngleGeometricBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> angleOrientedButtonData [
	^ {DrGAngleOrientedBuilder title. #orientedAngle. #createAngleOriented. DrGAngleOrientedBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> animate1ButtonData [
	^ {'Animate x1' translated. #animate1. #animate1. 'Animate at speed 1.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> animate2ButtonData [
	^ {'Animate x2' translated. #animate2. #animate2. 'Animate at speed 2.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> animate3ButtonData [
	^ {'Animate x3' translated. #animate3. #animate3. 'Animate at speed 3.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> animate4ButtonData [
	^ {'Animate x4' translated. #animate3. #animate3. 'Animate at speed 4.' translated}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> animateTools [
	^ #(#animate1 #animate2 #animate3 #animate4)
]

{ #category : #'tools data' }
DrGUIControlsManager >> arcButtonData [
	^ {DrGArcBuilder title. #arc. #createArc. DrGArcBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> arcCenterButtonData [
	^ {DrGArcCenterBuilder title. #arcCenter. #createArcCenter. DrGArcCenterBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> axesButtonData [
	^ {#axesWording. #axes. #axesOnOff. 'Show or hide the ox and oy axes.' translated. #isAxesVisible}
]

{ #category : #'widget access' }
DrGUIControlsManager >> button: symbolOrArray [
	"array first = menu label or button label
	array second = button form = selection mode
	array third = symbol callback
	array fourth = help string	"	
	| array stateGetter |
	array := self perform: (symbolOrArray, #ButtonData) asSymbol.
	^ (ButtonMorph 
		model: presenter
		stateGetter: (stateGetter := array at: 5 ifAbsent: [ #isTool: ])
		action: array third)
		stateArgument: (stateGetter isUnary ifTrue: [nil] ifFalse: [array second]);
		icon: (DrGIcons for: array second);
		setBalloonText: array fourth;
		color: Theme current drgeoButtonColor ;
		selectedColor: Theme current drgeoButtonSelectedColor ;
		borderColor: Theme current drgeoButtonColor muchDarker;
		borderWidth: 2;
		morphExtent: (Theme current toolbarIconSize + 4) asPoint;
		yourself	
]

{ #category : #'tools data' }
DrGUIControlsManager >> circleButtonData [
	^ {DrGCircleBuilder title. #circle. #createCircle. DrGCircleBuilder description}
]

{ #category : #'widget helpers' }
DrGUIControlsManager >> contextualEditingFor: panel [
"Ensure the panel is located close to the user mouse action"
	| mousePosition |
	mousePosition := self activeHand morphPosition.
	mousePosition x > (self runningWorld morphWidth - panel morphWidth - 20)
		ifTrue: [panel morphPosition: mousePosition 
			+ (-20 - panel morphWidth @ ((panel morphHeight  // -2)))]
		ifFalse: [panel 	morphPosition: mousePosition 
			+ (20@ (panel morphHeight // -2) )].
	(panel respondsTo: #fitInWorld) ifTrue: [panel fitInWorld]
]

{ #category : #'tools data' }
DrGUIControlsManager >> coordinatesButtonData [
	^ {DrGCoordinatesBuilder title. #coordinates. #createCoordinates. DrGCoordinatesBuilder description}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> curveTools [
	^ #(#line #parallel #perpendicular #perpendicularBisector #angleBisector #ray #segment #vector #circle #arc #arcCenter #polygon #polygonRegular #locus)
]

{ #category : #'tools data' }
DrGUIControlsManager >> distanceButtonData [
	^ {DrGValueBuilder title. #distance. #createDistance. DrGValueBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> eraserButtonData [
	^ {DrGDeleteTool title. #eraser. #eraser. DrGDeleteTool description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> exportImageButtonData [
	^ {'Save as image' translated. #exportToImage. #exportToImageAs. 'Export this sketch as SVG image.' translated }
]

{ #category : #'tools data' }
DrGUIControlsManager >> freePointButtonData [
	^ {DrGFlyPointBuilder title. #freePoint. #createFreePoint. DrGFlyPointBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> gridButtonData [
	^ {#gridWording. #grid. #gridOnOff. 'Show or hide grid.' translated. #isGridVisible}
]

{ #category : #'tools data' }
DrGUIControlsManager >> homothetyButtonData [
	^ {DrGHomothetyBuilder title. #scale. #createHomothety. DrGHomothetyBuilder description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> horizontalWheel [ 
	| array |
	array := self wheelXButtonData.
	^ (WheelMorph target: presenter actionSelector: array third)
		beHorizontal; 
		factor: 0.05; 
		setBalloonText: array first;
		borderWidth: 3;
		color: Theme current drgeoButtonColor;
		borderColor: Theme current drgeoButtonColor muchDarker;
		yourself
]

{ #category : #initialization }
DrGUIControlsManager >> installTools [
" Install menu, toolbar, tree, wheels, statusbar "
	| row col wheelHeight wheelWidth |
	wheelHeight := Theme current wheelHeight .
	wheelWidth := Theme current wheelWidth.
	view := DrGeoView for: presenter.
	view 
		addMorph: self quickToolbar layoutSpec: (LayoutSpec fixedHeight: Theme current toolbarIconSize + 4).
	row := LayoutMorph newRow.
	row 
		addMorph: self treeView proportionalWidth: 0.1;
		addAdjusterMorph;
		addMorphUseAll: view drawable.
	"Install the wheels at the right"
	col := LayoutMorph newColumn name: #wheelsYZ.
	col addMorph: self zoomWheel layoutSpec: (
		LayoutSpec fixedExtent: wheelWidth @ wheelHeight).
	col addMorphUseAll: self transparentMorph.
	col addMorph: self verticalWheel layoutSpec: (
		LayoutSpec fixedExtent: wheelWidth @ wheelHeight).			
	""	
	row addMorph: col layoutSpec: (LayoutSpec fixedWidth: (wheelWidth + 1) proportionalHeight: 1).	
	view addMorph: row.
	"Install wheel at the bottom"
	
	row := LayoutMorph newRow name: #wheelX; yourself.
	row addMorphUseAll: self statusBarInScroller;
		addMorph:self horizontalWheel layoutSpec: 
			(LayoutSpec 	fixedExtent:  wheelHeight @ wheelWidth);
		addMorph: self transparentMorph layoutSpec: 
			(LayoutSpec 		fixedExtent: wheelWidth asPoint) .
	
	view addMorph: row layoutSpec: (LayoutSpec fixedHeight: wheelWidth)

]

{ #category : #'tools data' }
DrGUIControlsManager >> intersectionButtonData [
	^ {DrGPointIntersectionBuilder title. #intersection. #createPointIntersection. DrGPointIntersectionBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> keepButtonData [
	^ {'Save' translated. #keep. #saveSketch. 'Keep this sketch permanently.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> lineButtonData [
	^ {DrGLineBuilder title. #line. #createLine. DrGLineBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> locusButtonData [
	^ {DrGLocusBuilder title. #locus. #createLocus. DrGLocusBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> macroBuildButtonData [
	^ {DrGMacroBuilder title. #macroBuild. #createMacro. DrGMacroBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> macroDeleteButtonData [
	^ {'Delete macro' translated.
	#eraser .
	#deleteMacro .
	'Delete a macro-construction from the registry.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> macroExecuteButtonData [
	^ {DrGMacroPlayer title. #macroExecute. #executeMacro. DrGMacroPlayer description}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> macroTools [
	^ #(#macroBuild #macroExecute)
]

{ #category : #'tools data' }
DrGUIControlsManager >> magneticGridButtonData [
	^ {#magneticGridWording. #gridMagnet. #gridStuckOnOff. 'Snap to grid.' translated. #isGridded}
]

{ #category : #'tools data' }
DrGUIControlsManager >> menuButtonData [ 
	^ {'Menu' translated. nil . nil . 'An unobtrusive menu with all Dr. Geo tools.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> middleButtonData [
	^ {DrGMiddleBuilder title. #middle. #createMiddlePoint. DrGMiddleBuilder description}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> miscTools [
	^ #(#new #open #keep #exportImage
	#undo #redo 
	#axes #grid #magneticGrid 
	#multipleMode #move
	#eraser #style #property)
]

{ #category : #'tools data' }
DrGUIControlsManager >> moveButtonData [
	^ {DrGSelectTool title. #move. #move. DrGSelectTool description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> multipleModeButtonData [
	^ {#createMultipleModeWording. #createMultiple. #createMultipleOnOff. 'Toggle between the build of several geometric objects and the build of one geometric object then move it.' translated. #isCreateMultipleMode}
]

{ #category : #'tools data' }
DrGUIControlsManager >> newButtonData [
	^ {'New' translated. #newSketch. #newFigure. 'Open a new blank sketch.' translated}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> numericTools [
	^ #(#distance #angleOriented #angleGeometric #coordinates #text)
]

{ #category : #'tools data' }
DrGUIControlsManager >> openButtonData [
	^ {'Open' translated. #open. #openFigureThumbnail. 'Open a sketch.' translated}
]

{ #category : #'widget access' }
DrGUIControlsManager >> openTools [
" Open the toolbox to manipulate items in the canvas "
	self tools 
		morphPosition: self activeHand morphPosition ;
		openInWorld
]

{ #category : #'tools data' }
DrGUIControlsManager >> parallelButtonData [
	^ {DrGParallelBuilder title. #parallel. #createParallel. DrGParallelBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> perpendicularBisectorButtonData [
	^ {DrGPerpendicularBisectorBuilder  title. #perpendicularBisector. #createPerpendicularBisector. DrGPerpendicularBisectorBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> perpendicularButtonData [
	^ {DrGPerpendicularBuilder title. #perpendicular. #createPerpendicular. DrGPerpendicularBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> pointByCoordinatesButtonData [
	^ {DrGPointByCoordinatesBuilder title. #pointDefinedByCoordinates. #createPointByCoordinates. DrGPointByCoordinatesBuilder description}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> pointTools [
	^ #(#freePoint #middle #intersection #pointByCoordinates)
]

{ #category : #'tools data' }
DrGUIControlsManager >> polygonButtonData [
	^ {DrGPolygonBuilder title. #polygon. #createPolygon. DrGPolygonBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> polygonRegularButtonData [
	^ {DrGPolygonRegularBuilder title. #polygonRegular. #createPolygonRegular. DrGPolygonRegularBuilder  description}
]

{ #category : #accessing }
DrGUIControlsManager >> presenter: aPresenter [
	presenter := aPresenter
]

{ #category : #'tools data' }
DrGUIControlsManager >> propertyButtonData [
	^ {DrGPropertyTool title.
	#property .
	#property .
	DrGPropertyTool description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> propertyFor: aMathItem [
"Open a property Panel to edit the math item"
	editPanel 	ifNotNil: [
		editPanel delete.
		editPanel := nil].
	aMathItem ifNotNil: [
		editPanel := 		aMathItem editPropertyIn: presenter.
		self contextualEditingFor: editPanel]
		
]

{ #category : #'widget access' }
DrGUIControlsManager >> quickToolbar [
	quickToolbar ifNotNil: [^ quickToolbar].
	quickToolbar := LayoutMorph newRow
		separation: 5;
		yourself.
	self miscTools do: [:dataTool | 		quickToolbar addMorph: (self button: dataTool )		].
	^ quickToolbar
	

]

{ #category : #'tools data' }
DrGUIControlsManager >> rayButtonData [
	^ {DrGRayBuilder title. #ray. #createRay. DrGRayBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> redoButtonData [
	^ {'Redo' translated.
	#redo .
	#redo .
	'Redo last action.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> reflectionButtonData [
	^ {DrGReflectionBuilder title. #axialSymmetry. #createReflection.DrGReflectionBuilder description}
]

{ #category : #initialization }
DrGUIControlsManager >> release [
	presenter := nil.
	tools ifNotNil: [
		tools delete.
		tools := nil].
	view release.
	view := nil
]

{ #category : #'tools data' }
DrGUIControlsManager >> rotationButtonData [
	^ {DrGRotationBuilder title. #rotation. #createRotation. DrGRotationBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> scriptCreateButtonData [
	^ {'Create a script' translated. #createScript . #createScript . 'Create a Smalltalk script.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> scriptEditButtonData [
	^ {'Edit a script' translated.	#editScript.	#editScript .	'Edit a Smalltalk script.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> scriptRunButtonData [
	^ {DrGScriptPlayer title. #useScript. #useScript. DrGScriptPlayer description}
]

{ #category : #'tools collections' }
DrGUIControlsManager >> scriptTools [
	^ #(#scriptRun #scriptEdit #scriptCreate)
]

{ #category : #'tools data' }
DrGUIControlsManager >> segmentButtonData [
	^ {DrGSegmentBuilder title. #segment. #createSegment. DrGSegmentBuilder description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> setStatusBarMessage: aString [
	statusBar ifNotNil: [
		statusBar contents: aString;
			adjustExtent ;
			redrawNeeded]
		
]

{ #category : #'widget access' }
DrGUIControlsManager >> statusBar [
"A bar to print contextual information"
	^ statusBar ifNil: [
		statusBar := TextParagraphMorph new
			color: Color transparent;
			borderWidth: 0;
			setHeightOnContent ;
			yourself	]
	
	
]

{ #category : #'widget access' }
DrGUIControlsManager >> statusBarInScroller [
	^ PluggableScrollPane new scroller: self statusBar; 
		borderWidth: 2;
		borderColor: Color transparent ;
		color: Color transparent;
		yourself
]

{ #category : #'tools data' }
DrGUIControlsManager >> styleButtonData [
	^ {DrGStyleTool title. #style. #style. DrGStyleTool description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> stylerFor: aStyle [
"Open a style Panel to edit aStyle"
	editPanel 	ifNotNil: [
		editPanel delete.
		editPanel := nil].
	aStyle ifNotNil: [
		editPanel := 		DrGStylePanel open: aStyle label: 'Edit style' translated.
		self contextualEditingFor: editPanel ]
		
]

{ #category : #'tools data' }
DrGUIControlsManager >> symmetryButtonData [
	^ {DrGSymmetryBuilder title. #centralSymmetry. #createSymmetry. DrGSymmetryBuilder description}
]

{ #category : #'tools data' }
DrGUIControlsManager >> textButtonData [
	^ {DrGTextBuilder title. #text. #createText. DrGTextBuilder description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> tools [
	| toolsData dropDown |
	tools ifNotNil: [^ tools].
	toolsData := OrderedCollection new
		add: self pointTools; 		add: self curveTools; 		add: self transformationTools;
		add: self numericTools; 		add: self scriptTools;		add: self macroTools;
		add: self animateTools; 		yourself.
	tools := CircularToolbarMorph new.
	tools 
		color: Theme current drgeoButtonColor;
		selectedColor: Theme current drgeoButtonSelectedColor;
		buttonSize: Theme current toolbarIconSize;
		dropDownHeight: Theme current circularToolbarDropDownHeight ;
		dropDownGap: Theme current circularToolbarDropDownGap ;
		extent: Theme current circularToolbarExtent.
	toolsData do: [:dataTool | 
		dropDown := (self addChevron: dataTool first to: tools) addDropDown.
		dataTool do: [:tool | self addChevron: tool to: dropDown subtoolbar]].
	^ tools
	

]

{ #category : #'tools collections' }
DrGUIControlsManager >> transformationTools [
	^ #(#symmetry #reflection #translation #rotation #homothety)
]

{ #category : #'tools data' }
DrGUIControlsManager >> translationButtonData [
	^ {DrGTranslationBuilder title. #translation. #createTranslation. DrGTranslationBuilder description}
]

{ #category : #'widget helpers' }
DrGUIControlsManager >> transparentMorph [
	^ BoxedMorph new 
		borderWidth: 0;
		color: Color transparent; 
		yourself
]

{ #category : #'widget access' }
DrGUIControlsManager >> tree [
" I am the model of a tree presenting the math item "
	^ tree ifNil: [ tree := DrGeoTree on: presenter]
]

{ #category : #'tools data' }
DrGUIControlsManager >> treeButtonData [ 
	^ {'Construction tree' translated. nil . nil . 'The hierarchy tree presenting the visible constructed items.' translated}
]

{ #category : #'widget access' }
DrGUIControlsManager >> treeView [
	^ treeView ifNil: [treeView := HierarchicalListMorph 
		model: self tree
		listGetter: #pool
		indexGetter: #selectedItem
		indexSetter: #selectedItem:
		mainView: self view
		menuGetter: nil
		keystrokeAction: nil]
]

{ #category : #'tools data' }
DrGUIControlsManager >> undoButtonData [
	^ {'Undo' translated.
	#undo .
	#undo .
	'Undo last action' translated}
]

{ #category : #'widget helpers' }
DrGUIControlsManager >> updateStylerFor: aStyle [
"Update the styler if any matching the given style"
	(editPanel 	notNil and: [editPanel model == aStyle]) ifTrue: [ | position |
		position := editPanel morphPosition.
		self stylerFor: aStyle.
		editPanel morphPosition: position]
		
]

{ #category : #'tools data' }
DrGUIControlsManager >> vectorButtonData [
	^ {DrGVectorBuilder title. #vector. #createVector. DrGVectorBuilder description}
]

{ #category : #'widget access' }
DrGUIControlsManager >> verticalWheel [ 
	| array |
	array := self wheelYButtonData.
	^  (WheelMorph target: presenter actionSelector: array third)
		beVertical; 
		factor: 0.05; 
		setBalloonText: array first; 
		borderWidth: 3;
		color: Theme current drgeoButtonColor;
		borderColor: Color  black ;
		yourself		
		
]

{ #category : #accessing }
DrGUIControlsManager >> view [
	^ view
]

{ #category : #'tools data' }
DrGUIControlsManager >> wheelXButtonData [ 
	^ {'Horizontal wheel' translated. nil . #moveOx: . 'A wheel to move horizontally the sketch.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> wheelYButtonData [
	 ^ {'Vertical wheel' translated . nil . #moveOy: . 'A wheel to move vertically the sketch.' translated}
]

{ #category : #'tools data' }
DrGUIControlsManager >> wheelZButtonData [
	 ^ {'Zoom wheel' translated . nil . #scale: . 'A wheel to zoom in, zoom out the sketch.' translated}
]

{ #category : #'widget access' }
DrGUIControlsManager >> zoomWheel [ 
	| array |
	array := self wheelZButtonData.
	^  (WheelMorph target: presenter actionSelector: array third)
		beVertical; 
		factor: 1; 
		setBalloonText: array first; 
		borderWidth: 3;
		color: Theme current drgeoButtonSelectedColor;
		borderColor: Color black;
		yourself
]
