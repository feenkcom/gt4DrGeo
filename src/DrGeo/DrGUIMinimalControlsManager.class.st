Class {
	#name : #DrGUIMinimalControlsManager,
	#superclass : #DrGUIControlsManager,
	#category : #'DrGeo-View'
}

{ #category : #menus }
DrGUIMinimalControlsManager >> addMenuItem: toolSymbol to: menu [
	| array |
	"access the buttonData method from the tool symbol"
	array := toolSymbol isSymbol
		ifTrue: [ self perform: (toolSymbol , #ButtonData) asSymbol ]
		ifFalse: [ toolSymbol ].
	(menu add: array first action: array third) 		setBalloonText: array fourth.
	"do we have an icon for this tool?"
	(DrGIcons respondsTo: array second)
		ifTrue: [	 menu lastItem setIcon: (DrGIcons perform: array second) ]
]

{ #category : #menus }
DrGUIMinimalControlsManager >> addUpdatingMenuItem: array to: menu [
	(menu addUpdating: array first action: array third)
		setBalloonText: array fourth.
]

{ #category : #menus }
DrGUIMinimalControlsManager >> animateMenu [
	| menu |
	menu := self newMenu.
	self animateTools do: [ :symbol | self addMenuItem: symbol to: menu ].
	^ menu
		
]

{ #category : #menus }
DrGUIMinimalControlsManager >> curveMenu [
	| lineMenu |
	lineMenu := self newMenu.
	self curveTools  do: [ :symbol | self addMenuItem: symbol to: lineMenu ].
	^ lineMenu
]

{ #category : #menus }
DrGUIMinimalControlsManager >> editMenu [
	| menu |
	menu := self newMenu.
	self addMenuItem: self moveButtonData to: menu.
	menu addLine.
	self addMenuItem: self undoButtonData to: menu.
	self addMenuItem: self redoButtonData to: menu.
	menu addLine.
	"Only work on X Window (GNU/Linux)"
	self flag: #drgeoTodo.
	menu add: 'Copy' translated 
		target: presenter 
		action: #exportToClipboard: 		
		argument: false.
	menu add: 'Copy with transparency' translated 
		target: presenter
		action: #exportToClipboard:
		argument: true.
	menu addLine.
	self addMenuItem: self eraserButtonData to: menu.
	self addMenuItem: self styleButtonData to: menu.
	self addMenuItem: self propertyButtonData  to: menu.
	menu addLine.
	self addUpdatingMenuItem: self gridButtonData to: menu.
	self addUpdatingMenuItem: self axesButtonData to: menu.
	self addUpdatingMenuItem: self magneticGridButtonData to: menu.
	^ menu
		
]

{ #category : #menus }
DrGUIMinimalControlsManager >> fileMenu [
	| fileMenu |
	fileMenu := self newMenu.
	self addMenuItem: #new to: fileMenu.
	self addMenuItem: #open to: fileMenu.
	fileMenu 	add: 'Open at...' translated action: #openFigureAt. 
	self addMenuItem: #keep to: fileMenu.
	(fileMenu add: 'Save as...' translated action: #saveSketchAs)
		setBalloonText: 'Keep this sketch under a different name.' translated.
	self addMenuItem: #exportImage to: fileMenu.
"	fileMenu addLine.
	fileMenu add: 'Close sketch' translated target: self window action: #delete.
	self addMenuItem: #quit to: fileMenu."
	^ fileMenu
		
]

{ #category : #initialization }
DrGUIMinimalControlsManager >> installTools [
" Install menu, toolbar, tree, wheels, statusbar "
	| row col wheelHeight wheelWidth |
	super initialize.		
	wheelHeight := Theme current wheelHeight .
	wheelWidth := Theme current smWheelWidth.
	view := DrGeoMiniView for: presenter.
	row := LayoutMorph newRow.
	row addMorphUseAll: self view drawable.
	"Install the wheels at the right"
	col := LayoutMorph newColumn name: #wheelsYZ; color: view defaultColor; yourself.
	col 
		addMorph: (self zoomWheel borderWidth: 2) 
		layoutSpec: (		LayoutSpec fixedExtent: wheelWidth @ wheelHeight);
		addMorphUseAll: self transparentMorph;
		addMorph: (self verticalWheel borderWidth: 2) 
		layoutSpec: (		LayoutSpec fixedExtent: wheelWidth @ wheelHeight).			
	""	
	row addMorph: col layoutSpec: (LayoutSpec fixedWidth: wheelWidth proportionalHeight: 1).	
	view addMorph: row.
	
	"Install wheel at the bottom"	
	row := LayoutMorph newRow name: #wheelX; color: view defaultColor; yourself.
	row addMorphUseAll: self statusBarInScroller;
		addMorph: (self horizontalWheel borderWidth: 2) 
		layoutSpec: 		(LayoutSpec 	fixedExtent:  wheelHeight @ wheelWidth );
		addMorph: self transparentMorph 
		layoutSpec: 	(LayoutSpec 		fixedExtent: wheelWidth asPoint) .
	
	view addMorph: row layoutSpec: (LayoutSpec fixedHeight: wheelWidth)
]

{ #category : #menus }
DrGUIMinimalControlsManager >> macroconstructionMenu [
	| menu |
	self view macroMenu: (menu := self newMenu).
	 self macroTools do: [ :symbol | self addMenuItem: symbol to: menu].
	^ menu
]

{ #category : #menus }
DrGUIMinimalControlsManager >> mainMenu [
	| mainMenu menu |
	mainMenu := MenuMorph entitled: self view label.
	" File menu "
	menu := mainMenu add: 'File' translated subMenu: self fileMenu.
	menu 	setBalloonText: 'Load, save or export Dr. Geo figure.' translated.
	" Edit menu "
	menu := mainMenu add: 'Edit' translated subMenu: self editMenu.
	menu setBalloonText: 'Erase or edit style and properties of items.' translated.
	" Points menu "
	menu := mainMenu 		add: 'Points' translated subMenu: self pointMenu.
	menu setBalloonText: 'Create points: free, on curve, intersection or middle point.' translated.
	" Lines menu "
	menu := mainMenu add: 'Lines' translated subMenu: self curveMenu.
	menu setBalloonText: 'Create different curve types: line, half-line, segment, vector, circle...' translated.
	" Transformations menu "
	menu := mainMenu add: 'Transformations' translated subMenu: self transformationMenu.
	menu setBalloonText: 'Transform an object with a geometric transformation: symmetry, reflexion, rotation, translation or homothety (scale).' translated.
	" Numerics and Text menu "
	mainMenu add: 'Numerics & Text' translated subMenu: self numericMenu.
	menu setBalloonText: 'Create several numeric objects: free value, distance, length, angle, coordinates, equation and text.' translated.
	" Script menu "
	menu := mainMenu add: 'Script' translated subMenu: self scriptMenu.
	menu setBalloonText: 'Script: use, edit or create script to plug in the sketch.' translated.
	self flag: #drgeoTodo.
	"menu	on: #mouseEnter send: #updateScriptMenu	to: self."	
	" Macro-construction menu "	
	menu := mainMenu add: 'Macro-construction' translated 		subMenu: self macroconstructionMenu.
	menu setBalloonText: 'Build or execute macro-construction. A macro is a construction template you can apply to items in the sketch area.' translated.
	self flag: #drgeoTodo.
	"menu	on: #mouseEnter send: #updateMacroMenu to: self."
	" Animation menu "	
	menu := mainMenu add: 'Animate' translated subMenu: self animateMenu.
	menu setBalloonText: 'Animate a free point on curve.' translated.
	^ mainMenu 

]

{ #category : #menus }
DrGUIMinimalControlsManager >> newMenu [
	^ MenuMorph new 
		defaultTarget: presenter;
		yourself
]

{ #category : #menus }
DrGUIMinimalControlsManager >> numericMenu [
	| menu |
	menu := self newMenu.
	self numericTools do: [ :symbol | self addMenuItem: symbol to: menu ].
	^ menu
		
]

{ #category : #'widget access' }
DrGUIMinimalControlsManager >> openTools [
	self tools popUpInWorld 
]

{ #category : #menus }
DrGUIMinimalControlsManager >> pointMenu [
	| pointMenu |
	pointMenu := self newMenu.
	self pointTools do: [ :symbol | self addMenuItem: symbol to: pointMenu ].
	^ pointMenu
		
]

{ #category : #menus }
DrGUIMinimalControlsManager >> scriptMenu [
	| menu |
	self view scriptMenu: (menu := self newMenu).
	 self scriptTools do: [ :symbol | self addMenuItem: symbol to: menu].
	^ menu 
		
]

{ #category : #'widget access' }
DrGUIMinimalControlsManager >> tools [
	^ tools ifNil: [tools := self mainMenu]
]

{ #category : #menus }
DrGUIMinimalControlsManager >> transformationMenu [
	| menu |
	menu := self newMenu.
	self transformationTools do: [ :symbol | self addMenuItem: symbol to: menu ].
	^ menu
		
]

{ #category : #menus }
DrGUIMinimalControlsManager >> updateMacroMenu [
	| macroMenu |
	macroMenu := self view macroMenu.
	macroMenu removeAllMorphs.
	self macroTools do: [ :symbol |  self addMenuItem: symbol to: macroMenu].
	DrGMacroFactory new pool ifNotEmpty: [ macroMenu addLine ].
	DrGMacroFactory new pool do: [:aMacro |
		macroMenu 
			add: aMacro title  
			target: presenter 
			selector: #executeMacro:
			argument: aMacro.
		macroMenu lastItem
			setBalloonText: aMacro description]

]

{ #category : #menus }
DrGUIMinimalControlsManager >> updateScriptMenu [
	| scripts scriptMenu |
	scriptMenu := self view scriptMenu.
	scriptMenu removeAllMorphs.
	self scriptTools do: [ :symbol |  self addMenuItem: symbol to: scriptMenu].
	scripts := DrGeoUserScript subclasses sorted: [:script1 :script2 | 
		script1 scriptName asLowercase < script2 scriptName asLowercase].
	scripts ifNotEmpty: [scriptMenu addLine].
	scripts do: [:aScript |
		scriptMenu 
			add: aScript scriptName  
			target: presenter 
			selector: #useScript:
			argument: aScript.
		scriptMenu lastItem
			setBalloonText: aScript description]

]
