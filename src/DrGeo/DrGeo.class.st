"
A presenter for the DrGeo app.
It is the interface to callback, state of the application

- notInteractive: indicates if the app is under the user interaction or is used by the system (for example to load a sketch), in that case no user interaction are authorized.
- saved: is the sketch saved
- stSketch: if not nil DrGeo was initialized from a Smalltalk Sketch
"
Class {
	#name : #DrGeo,
	#superclass : #Object,
	#instVars : [
		'domain',
		'controlsManager',
		'tool',
		'gridStuck',
		'isCreateMultipleMode',
		'selectedTool',
		'selection',
		'sketchName',
		'exportImageName',
		'saved',
		'notInteractive',
		'stSketch'
	],
	#category : #'DrGeo-Presenter'
}

{ #category : #'user interface' }
DrGeo class >> aboutDrgeo [
	UISupervisor whenUIinSafeState: [
		(PopUpMenu labels: ' Ok ' icons: {DrGIcons drgeo}) 
			startUpNonModalWithCaption:  self drgeoInformationString ]
]

{ #category : #'user interface' }
DrGeo class >> drgeoCopyright [
	^ 'Source code application: Copyright 1996-2024 Hilaire Fernandes
Icons: Copyright 1999 Frédéric Toussaint
Icons: Copyright 2021-2022 David Caula (imppao)'
]

{ #category : #'user interface' }
DrGeo class >> drgeoInformationString [
	|text |
	text := 'Dr. Geo is about interactive geometry and programming.
{1}

It allows one to create geometric figure plus the interactive manipulation 
It is usable in teaching situation, in mathematics, physics and
programming, with students from primary school to university levels.

It is simple and effective with some unique features as Smalltalk scripts 
and programmed interactive sketches. 

{2}

LICENSE: GPL' translated format: {self drgeoVersion. self drgeoCopyright}.
	^ text
]

{ #category : #'user interface' }
DrGeo class >> drgeoVersion [
	^ 'Installed version: ' translated, 
		'24.05a beta (code revision ', 
		(String streamContents: [:str | 	(CodePackage installedPackages at: 'DrGeo') featureSpec provides printVersionRevisionOn: str]),
		')'
]

{ #category : #'saved status' }
DrGeo class >> figuresArray [
	|items activeViews|
	activeViews := OrderedCollection new.
	DrGeoView allInstances do: [:each | 
		each owner isNil ifFalse: [activeViews add: each]].
	items := OrderedCollection new.
	activeViews do: [:aView |
		items add: (Array 
			with:  aView 
			with:  'Fig. - ' translated, aView label 
			with: (ValueHolder with: aView presenter isSaved not))].
	^ items

]

{ #category : #file }
DrGeo class >> file: fileEntry [
	|answer|
	DrGeoSystem startSpinner.
	answer := DrGeoXml new load: fileEntry for: #new.
	DrGeoSystem stopSpinner.
	^ answer
]

{ #category : #'user interface' }
DrGeo class >> getMenuIn: aWorld at: aHand [
	| menu |
	menu :=  (CommandBuilder on: #drgeoWorldMenu) getMenu.
	menu addStayUpIcons ;
		addTitle: 'System menu' translated.
	^ menu
]

{ #category : #'saved status' }
DrGeo class >> macrosArray [
	|items|
	items := OrderedCollection new.
	DrGMacroFactory new pool do: [:macro |
		items add: (Array 
			with: macro 
			with: 'Macro - ' translated, macro title 
			with: (ValueHolder with: macro isSaved not) )].
	^ items
]

{ #category : #'user interface' }
DrGeo class >> preferencesMenu: builder [
	<drgeoWorldMenu>
	(builder newEntry: 'Settings' translated in: 'Preferences' translated)
		icon: #graphicsIcon;
		action: [PreferenceBrowser open: DrGeoSystem preferences label: 'Dr. Geo Preferences' translated.];
		order: 1.
	(builder newEntry: 'Size of GUI elements' translated in: 'Preferences' translated)
		target: Theme; selector: #changeFontSizes;
		icon: #preferencesDesktopFontIcon;
		order: 2.
	(builder newEntry: 'Theme' translated in: 'Preferences' translated)
		target: Theme; selector: #changeTheme;
		icon: #appearanceIcon;
		order: 3.
		
]

{ #category : #'user interface' }
DrGeo class >> quit [
	self unsavedData isEmpty ifFalse: [ 
		(self confirm: 'There is unsaved data! 
Are you sure to quit Dr. Geo environment?' translated) ifFalse: [ ^ self]].
	Smalltalk quitPrimitive
]

{ #category : #'instance creation' }
DrGeo class >> service [
"instanciate a DrGeo service, to embbed in third party Morph. It is just the canvas without surounding menu and icon"
	^ self basicNew
		initializeService;
		yourself
]

{ #category : #file }
DrGeo class >> serviceXml: fileEntry [
	^ DrGeoXml new load: fileEntry for: #service

]

{ #category : #'user interface' }
DrGeo class >> toolsMenu: builder [
	<drgeoWorldMenu>
	(builder newEntry: 'System Browser' translated in: 'Tools' translated)
		icon: #developmentIcon;
		action: [HierarchyBrowserWindow onClass: DrGeoSketch selector: nil];
		help:'A source code browser to view, edit and save Dr. Geo code. I open the browser on the DrGeoSketch class you can study to design your own Smalltalk sketch.' translated;
		order: 40.

	(builder newEntry: 'Smalltalk Sketch Editor' translated in: 'Tools' translated)
		icon: #textEditorIcon;
		help: 'An editor to write and to test new Smalltalk sketch.' 	translated;
		action: [DrGSmalltalkSketchEditor open: '' label: 'Edit Smalltalk Sketch' translated.];
		order: 20.

	(builder newEntry: 'Browse Smalltalk Sketches' translated in: 'Tools' translated)
		icon: #scriptIcon;
		help: 'A tool to browse and to test both system and personal Smalltalk Sketches.' 	translated;
		action: [DrGSmalltalkSketchBrowser open: DrGeoSystem smalltalkSketchesPath label: 'Browse' translated.];
		order: 10.

	(builder newEntry: 'Workspace' translated in: 'Tools' translated)
		icon: #terminalIcon;
		action: [Workspace open ];
		help: 'A window used as a scratchpad area where fragments of Cuis-Smalltalk code can be entered, stored, edited, and evaluated.'	translated;
		order: 30.
		
	(builder newEntry: 'Open a file' translated in: 'Tools' translated)
		icon: #systemFileManagerIcon;
		action: [FileList open];
		help: 'Open the filer on your personal sketches collection.' translated;
		order: 50.
		
	(builder newEntry: 'Save session' translated in: 'Tools' translated)
		order: 999;
		action: [Smalltalk saveImage];
		icon:	 #saveIcon;
		help: 'Save this Dr. Geo session.' translated
]

{ #category : #'saved status' }
DrGeo class >> unsavedData [
"Answer a collection of unsaved data"
	| unsavedData |
	unsavedData := OrderedCollection new.
	unsavedData 
		addAll: (self figuresArray select: [:each | each third propertyValue]);
		addAll: (self macrosArray select: [:each | each third propertyValue]).
	^ unsavedData
]

{ #category : #'user interface' }
DrGeo class >> worldMenu: builder [
	<drgeoWorldMenu>
	(builder newEntry: 'New sketch' translated)
		icon: #newIcon;
		action: [DrGeo new];
		order: 0.
	(builder newEntry: 'Open a sketch' translated)
		icon: #openIcon;
		action: [DrGFileOpenMorph open];
		order: 1.
	(builder newEntry: 'Preferences' translated)
		icon: #preferencesIcon;
		order: 2.
	(builder newEntry: 'Toggle full screen mode' translated)
		icon: #viewFullscreenIcon;
		action: [DrGeoSystem toggleFullscreen];
		help: 'Turn full screen mode on when it is off, off when it is on.'	translated;
		order: 3.
	(builder newEntry: 'Tools' translated)
		icon:	 #systemIcon.
	(builder newEntry: 'About' translated)
		action: [ DrGeo aboutDrgeo ];
		order: 7.
	(builder newEntry:  'Quit' translated)
		action: [ DrGeo quit ];
		icon: #quitIcon;
		order: 999
]

{ #category : #'callback canvas' }
DrGeo >> animate [
	selectedTool == #animate 	ifFalse: [
		self selectTool: DrGAnimateTool.
		selectedTool := #animate].
	self changed
]

{ #category : #'callback canvas' }
DrGeo >> animate1 [
	self animate.
	self tool animateStep: 0.01.

]

{ #category : #'callback canvas' }
DrGeo >> animate2 [
	self animate.
	self tool animateStep: 0.043.

]

{ #category : #'callback canvas' }
DrGeo >> animate3 [
	self animate.
	self tool animateStep: 0.076.

]

{ #category : #'callback canvas' }
DrGeo >> animate4 [
	self animate.
	self tool animateStep: 0.1

]

{ #category : #'callback canvas' }
DrGeo >> axesOnOff [
	self drawable axesVisibleOnOff
	
]

{ #category : #accessing }
DrGeo >> axesWording [
	^self isAxesVisible
		ifTrue: ['<yes> Axes' translated]
		ifFalse: ['<no> Axes' translated]
]

{ #category : #accessing }
DrGeo >> controlsManager [
	^ controlsManager
]

{ #category : #accessing }
DrGeo >> controlsManager: aClass [
	controlsManager := aClass for: self.
	controlsManager installTools
]

{ #category : #'callback create' }
DrGeo >> createAngleBisector [
	self selectTool: DrGFlyBuildTool with: DrGAngleBisectorBuilder.
	selectedTool := #angleBisector.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createAngleGeometric [
	self selectTool: DrGBuildTool with: DrGAngleGeometricBuilder.
	selectedTool := #geometricAngle.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createAngleOriented [
	self selectTool: DrGBuildTool with: DrGAngleOrientedBuilder.
	selectedTool := #orientedAngle.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createArc [
	self selectTool: DrGFlyBuildTool with: DrGArcBuilder.
	selectedTool := #arc.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createArcCenter [
	self selectTool: DrGFlyBuildTool with: DrGArcCenterBuilder.
	selectedTool := #arcCenter.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createCircle [
	self selectTool: DrGFlyBuildTouchTool with: DrGCircleBuilder.
	selectedTool := #circle.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createCoordinatePoint [
	self selectTool: DrGBuildTool with: DrGPointByCoordinatesBuilder.
	selectedTool := #pointDefinedByCoordindates.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createCoordinates [
	self selectTool: DrGBuildTool with: DrGCoordinatesBuilder.
	selectedTool := #coordinates.
	self changed

]

{ #category : #'callback create' }
DrGeo >> createDistance [
	self selectTool: DrGBuildTool with: DrGValueBuilder.
	selectedTool := #distance.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createFreePoint [
	self selectTool: DrGFlyPointBuildTool with: DrGFlyPointBuilder.
	selectedTool := #freePoint.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createHomothety [
	self selectTool: DrGBuildTool with: DrGHomothetyBuilder.
	selectedTool := #scale.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createLine [
	self selectTool: DrGFlyBuildTouchTool with: DrGLineBuilder.
	selectedTool := #line.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createLocus [
	self selectTool: DrGBuildTool with: DrGLocusBuilder.
	selectedTool := #locus.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createMacro [
	self selectTool: DrGMacroBuildTool with: DrGMacroBuilder.
	selectedTool := #macroBuild.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createMiddlePoint [
	self selectTool: DrGBuildTool with: DrGMiddleBuilder.
	selectedTool := #middle.
	self changed
]

{ #category : #accessing }
DrGeo >> createMultipleModeWording [
	^isCreateMultipleMode
		ifTrue: ['<yes> Create Multiple' translated]
		ifFalse: ['<no> Create Multiple' translated]
]

{ #category : #'callback canvas' }
DrGeo >> createMultipleOnOff [
	isCreateMultipleMode := isCreateMultipleMode not
]

{ #category : #'callback create' }
DrGeo >> createParallel [
	self selectTool: DrGFlyBuildTouchTool with: DrGParallelBuilder.
	selectedTool := #parallel.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPerpendicular [
	self selectTool: DrGFlyBuildTouchTool with: DrGPerpendicularBuilder.
	selectedTool := #perpendicular.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPerpendicularBisector [
	self selectTool: DrGFlyBuildTouchTool with: DrGPerpendicularBisectorBuilder.
	selectedTool := #perpendicularBisector.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPointByCoordinates [
	self selectTool: DrGBuildTool with: DrGPointByCoordinatesBuilder.
	selectedTool := #pointDefinedByCoordinates.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPointIntersection [
	self selectTool: DrGBuildTool with: DrGPointIntersectionBuilder.
	selectedTool := #intersection.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPolygon [
	self selectTool: DrGFlyBuildTool with: DrGPolygonBuilder.
	selectedTool := #polygon.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createPolygonRegular [
	self selectTool: DrGFlyBuildTool with: DrGPolygonRegularBuilder.
	selectedTool := #polygonRegular.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createRay [
	self selectTool: DrGFlyBuildTouchTool with: DrGRayBuilder.
	selectedTool := #ray.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createReflection [
	self selectTool: DrGBuildTool with: DrGReflectionBuilder.
	selectedTool := #axialSymmetry.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createRotation [
	self selectTool: DrGBuildTool with: DrGRotationBuilder.
	selectedTool := #rotation.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createScript [
	"We force to select/move mode as we do not interact with the sketch"	
	self move.
	self changed.
	DrGScriptDesignerDialog open: self label: 'Build a new script' translated
]

{ #category : #'callback create' }
DrGeo >> createSegment [
	self selectTool: DrGFlyBuildTouchTool with: DrGSegmentBuilder.
	selectedTool := #segment.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createSymmetry [
	self selectTool: DrGBuildTool with: DrGSymmetryBuilder.
	selectedTool := #centralSymmetry.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createText [
	self selectTool: DrGBuildTool with: DrGTextBuilder.
	selectedTool := #text.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createTranslation [
	self selectTool: DrGBuildTool with: DrGTranslationBuilder.
	selectedTool := #translation.
	self changed
]

{ #category : #'callback create' }
DrGeo >> createVector [
	self selectTool: DrGFlyBuildTouchTool with: DrGVectorBuilder.
	selectedTool := #vector.
	self changed
]

{ #category : #'callback create' }
DrGeo >> deleteMacro [
	self selectTool: DrGSelectTool.
	selectedTool := #deleteMacro.
	self changed
]

{ #category : #updating }
DrGeo >> deleteMathItem: aCostume [
	self domain deleteMathItem: aCostume mathItem.
	self domain updateAllMathItems
]

{ #category : #accessing }
DrGeo >> domain [
	^ domain 
]

{ #category : #accessing }
DrGeo >> drawable [
	^ self view ifNotNil: [self view drawable]
]

{ #category : #'callback create' }
DrGeo >> editScript [
	| menu |
	"We force to select mode, then open a browser on the script classes"
	self move.
	menu := MenuMorph entitled: 'Edit or create scripts' translated.
	DrGWizardScript sortedScripts do: [:aScriptClass |
		(menu 
			add: aScriptClass scriptName 
			target: self 
			action: #editScript: 
			argument: aScriptClass)
			setBalloonText: aScriptClass description].
	menu popUpInWorld.
	self changed
]

{ #category : #'callback create' }
DrGeo >> editScript: aScriptClass [
	|  browser |
	browser := Browser new setClass: aScriptClass selector: #compute.
	browser when: #annotationChanged send: #updateAllMathItems to: self domain.
	^ BrowserWindow openNoSysCat: browser label:  'Edit or create scripts' translated
		
	
]

{ #category : #'callback create' }
DrGeo >> eraser [
	selectedTool := #eraser.
	self selectTool: DrGDeleteTool.
	self changed: #selectedTool.
	self drawable redrawNeeded .
]

{ #category : #'callback create' }
DrGeo >> executeMacro [
	self selectTool: DrGMacroPlayTool with: DrGMacroPlayer.
	selectedTool := #macroExecute.
	self changed
]

{ #category : #'callback create' }
DrGeo >> executeMacro: aMacro [
	self selectTool: DrGMacroPlayTool with: DrGMacroPlayerHeadless.
	selectedTool := #macroExecute. 
	self tool builder selectedMacro: aMacro.
	self tool switchState: DrGMacroPlayToolStateSelect.
	self changed
]

{ #category : #'callback UI' }
DrGeo >> exportToClipboard: isBackgroundTransparent [
"	| command |
	self 
		exportToBitmap: (DrGeoSystem myExportsPath / 'clipboard.png') ensureDelete binaryWriteStream
		transparent: isBackgroundTransparent.
	command := String streamContents: [ :str | 
		str << 'xclip -selection clipboard -t image/png '
			<< (DrGeoSystem myExportsPath / 'clipboard.png') pathString].
	OSPlatform current runCommand: command."
]

{ #category : #'callback UI' }
DrGeo >> exportToImage: aFilename [
	| stream |
	[stream := (DrGeoSystem myExportsPath // (aFilename, '.svg')) forceWriteStream.
	DrGeoXml new 
		presenter: self; 
		exportToSvg: stream
	] ensure: [stream close]


"	
	[self saveWithinLimitedTime: [
		DrGeoSystem startSpinner.
		stream := (DrGeoSystem myExportsPath // (aFilename, '.svg')) forceWriteStream.
		DrGeoXml new 
			app: self app; 
			exportToSvg: stream].
	stream close]
		on: Error 
		do: [:ex | DrGeoSystem stopSpinner.
			stream ifNotNil: [stream close].
			Transcript show: ex.
			PopUpMenu  inform: 'I can''t export the sketch.
Check the local resource or the server.' translated].
	DrGeoSystem stopSpinner.
"
]

{ #category : #'callback UI' }
DrGeo >> exportToImageAs [
	| model |
	DrGeoSystem showVirtualKeyboard: true.
	model := (ValueHolder with: (exportImageName ifNotNil: [:name | name] ifNil: ['']))
	action: [:aString | 
		exportImageName := aString.
		self exportToImage: exportImageName ].
	(StringEntryPanel openWide: model label: 'Name the image to keep.' translated)
		morphCenter: self view fullBoundsInOwner center;
		setProperty: #layerNumber toValue: 20
]

{ #category : #'callback canvas' }
DrGeo >> gridOnOff [
	self drawable gridVisibleOnOff
]

{ #category : #'callback canvas' }
DrGeo >> gridStuckOnOff [
	gridStuck := gridStuck not.
]

{ #category : #accessing }
DrGeo >> gridWording [
	^self isGridVisible
		ifTrue: ['<yes> Grid' translated]
		ifFalse: ['<no> Grid' translated]
]

{ #category : #'initialize-release' }
DrGeo >> initialize [
	self initializeBasic.
	self controlsManager: DrGUIControlsManager.
	self move.
	self view openInWorld 
]

{ #category : #'initialize-release' }
DrGeo >> initializeBasic [
	super initialize.
	isCreateMultipleMode := false.
	gridStuck := false.
	"because empty at initialize, no save is needed, so we marked as saved"
	saved := true. 
	notInteractive := false.
	domain := DrGeoDomain new.
]

{ #category : #'initialize-release' }
DrGeo >> initializeService [
	self initializeBasic.
	self controlsManager: DrGUIMinimalControlsManager.
	self move.
]

{ #category : #testing }
DrGeo >> isAxesVisible [
	^ self drawable 
		ifNotNil: [self drawable axesVisible]
		ifNil: [false]
]

{ #category : #testing }
DrGeo >> isCreateMultipleMode [
	^isCreateMultipleMode
]

{ #category : #testing }
DrGeo >> isForceVisible [
	"We force unvisible costume to be visible when in style mode only"
	^ (self isTool: #style) or: [self isTool: #eraser]
]

{ #category : #testing }
DrGeo >> isGridVisible [
	^ self drawable 
		ifNotNil: [self drawable gridVisible]
		ifNil: [false]
]

{ #category : #testing }
DrGeo >> isGridded [
	^ gridStuck
]

{ #category : #testing }
DrGeo >> isNotInteractive [
	^ notInteractive 
]

{ #category : #testing }
DrGeo >> isSaved [
	^ saved
]

{ #category : #testing }
DrGeo >> isTool: symbolTool [
"Do we have this symbolTool selected"
	^ selectedTool == symbolTool 
]

{ #category : #accessing }
DrGeo >> magneticGridWording [
	^self isGridded 
		ifTrue: ['<yes> Magnetic Grid' translated]
		ifFalse: ['<no> Magnetic Grid' translated]
]

{ #category : #'callback canvas' }
DrGeo >> move [
	self selectTool: DrGSelectTool.
	selectedTool := #move.
	self changed
]

{ #category : #'callback canvas' }
DrGeo >> moveOx: increment [
	self drawable moveOx: increment.
]

{ #category : #'callback canvas' }
DrGeo >> moveOy: increment [
	self drawable moveOy: increment negated.
]

{ #category : #'callback UI' }
DrGeo >> newFigure [
	DrGeo new
]

{ #category : #accessing }
DrGeo >> notInteractive: boolean [
	notInteractive := boolean
]

{ #category : #'callback UI' }
DrGeo >> openFigureThumbnail [
	DrGFileOpenMorph open
]

{ #category : #tool }
DrGeo >> openTools [
	controlsManager openTools
]

{ #category : #canvas }
DrGeo >> previewOnFile: aFileEntry [
"compute a preview and save it in the file entry"
	| stream |
	[ 	[stream := aFileEntry forceWriteStream.
		self drawable previewOn: stream] 				
			on: Error
			do:[: e| self halt.] 
	] 
		ensure: [	stream close]
		 

]

{ #category : #'callback create' }
DrGeo >> property [ 
	self selectTool: DrGPropertyTool.
	selectedTool := #property.
	self changed
]

{ #category : #updating }
DrGeo >> readyToBuild [
	|answer|
	"readyToBuild event, the builder is ready to build, request to the domain the construction of the math item under the builder"
	answer := self domain createMathItem: self tool builder.
	self flag: #drgeoTodo. "Pourquoi faut-il unhide ?"
	answer last ifFalse: [(self drawable viewOf: answer first) unhide].
	self selectionCleanUp.
	self domain updateAllMathItems.
	self saved: false.
]

{ #category : #updating }
DrGeo >> readyToBuildClone [
	|answer|
	"readyToBuild event sent from the SelectTool. The builder is ready to clone an items and its parents,
	 request to the domain the construction of the math item under the builder"
	answer := self domain createMathItem: self tool builder.
	self tool grabClone: answer first last.
]

{ #category : #updating }
DrGeo >> readyToBuildMacro [
	"readyToBuild event, the builder is ready to build a macro, request to the domain the construction of the math item under the builder"
	self domain createMacro: self tool builder.
	self move
]

{ #category : #updating }
DrGeo >> readyToPlayMacro [
	"readyToBuild event, the builder is ready to play a macro (enought input items), request to the domain the construction of the math items under the builder"
	self domain playMacro: self tool builder in: self.
	self move
]

{ #category : #'callback canvas' }
DrGeo >> redo [
	self domain redo.
	self domain updateAllMathItems.
	self saved: false
]

{ #category : #'initialize-release' }
DrGeo >> release [
	tool release.
	self drawable ifNotNil: [:dr | dr release].
	self domain release.
	stSketch ifNotNil: [stSketch terminateDo].
	controlsManager release.
	domain := nil.
	controlsManager := nil.
	sketchName := nil
]

{ #category : #'callback UI' }
DrGeo >> save [
"Save the sketch with the current filename"
| stream |
	[self saveWithinLimitedTime: [
		DrGeoSystem startSpinner.
		stream := (DrGeoSystem mySketchesPath // (sketchName, '.fgeo')) forceWriteStream.
		DrGeoXml new 
			presenter: self; 
			saveOn: stream.
		self previewOnFile: DrGeoSystem mySketchesPath // (sketchName, '.png')].
	self saved: true.
	stream close]
		on: Error 
		do: [:ex | DrGeoSystem stopSpinner.
			stream ifNotNil: [stream close].
			Transcript show: ex.
			PopUpMenu  inform: 'I can''t save the sketch.
Check the local resource or the server.' translated].
	DrGeoSystem stopSpinner.
]

{ #category : #'callback UI' }
DrGeo >> saveSketch [
	sketchName 
		ifNil: [self saveSketchAs]
		ifNotNil: [	self save]

]

{ #category : #'callback UI' }
DrGeo >> saveSketchAs [
| model |
	DrGeoSystem showVirtualKeyboard: true.
	model := (ValueHolder with:'')
	action: [:aString | 
		sketchName := aString.
		self saveSketch].
	(StringEntryPanel openWide: model label: 'Name the sketch to keep.' translated)
		morphCenter: self view fullBoundsInOwner center;
		setProperty: #layerNumber toValue: 20
]

{ #category : #'callback UI' }
DrGeo >> saveWithinLimitedTime: aBlock [
	[aBlock value]
		valueWithin: 10 seconds
		onTimeout: 	
			[DrGeoSystem stopSpinner..
			PopUpMenu inform: 'I can''t save the sketch.
Check the local resource or the server.' translated].
]

{ #category : #accessing }
DrGeo >> saved: bool [
	| title |
	title := (sketchName ifNil: ['Dr. Geo --  ' , Date today yyyymmdd]) 	capitalized.
	bool ifFalse: [title := '* ', title].
	self view setLabel: title.
	saved := bool.

]

{ #category : #'callback canvas' }
DrGeo >> scale: increment [
	self drawable scale: increment negated.
]

{ #category : #tool }
DrGeo >> selectTool: aToolClassName [
	self tool: nil.
	self tool: (aToolClassName presenter: self)
]

{ #category : #tool }
DrGeo >> selectTool: aToolClassName with: aBuilderClass [
	self tool: (aToolClassName builder: aBuilderClass presenter: self).
	self domain changed: #selectedTool
]

{ #category : #tool }
DrGeo >> selectToolAfterBuilding [
	self isCreateMultipleMode
		ifFalse: 	[self move]
]

{ #category : #accessing }
DrGeo >> selection [
	^selection
]

{ #category : #tool }
DrGeo >> selectionCleanUp [
|createdItem|
	"a mathItem is just been created, do some clean up"
	self tool reset.
	createdItem := self domain factory last.
	"eventually if not in createMultipleMode we escape from this tool"
	(createdItem isFreePointItem 
		or: [createdItem isIntersectionPointItem 
		or: [createdItem isPointItemOnCurve]])
			ifFalse: [self selectToolAfterBuilding].
	((tool class = DrGFlyPointBuildTool) or: [selectedTool = #intersection]) ifTrue: [
		self selectToolAfterBuilding].

]

{ #category : #accessing }
DrGeo >> sketchName [
	^ sketchName
]

{ #category : #accessing }
DrGeo >> stSketch: aDrGeoSketch [
	stSketch := aDrGeoSketch 
]

{ #category : #'callback canvas' }
DrGeo >> style [
	selectedTool := #style.
	self selectTool: DrGStyleTool.
	self changed: #selectedTool.
	self drawable redrawNeeded .

]

{ #category : #accessing }
DrGeo >> tool [
	^tool
]

{ #category : #accessing }
DrGeo >> tool: aTool [ 
	tool ifNotNil: [tool release].
	tool := aTool.
	tool ifNotNil: [tool registerDependant: self].
	(tool notNil and: [self view notNil])  ifTrue: [
		controlsManager setStatusBarMessage: tool description]
]

{ #category : #'callback canvas' }
DrGeo >> undo [
	self tool resetForFreshStart.
	self domain undo.
	self domain updateAllMathItems.
	self saved: false
]

{ #category : #updating }
DrGeo >> updateSelection [
	(self isTool: #move) ifTrue: [|aMathItem| 
		aMathItem := controlsManager tree selectedItem withoutListWrapper.
		aMathItem isNil 
			ifTrue: [self tool morph: nil]
			ifFalse: [	self tool morph: (self drawable viewOf: aMathItem)]]
]

{ #category : #'callback create' }
DrGeo >> useScript [
	self selectTool: DrGScriptPlayTool with: DrGScriptPlayer.
	selectedTool := #useScript.
	self changed
]

{ #category : #'callback create' }
DrGeo >> useScript: aScript [
	self selectTool: DrGScriptPlayTool with: DrGScriptPlayerHeadless.
	selectedTool := #useScript.
	self tool builder scriptClass: aScript.
	self tool switchState: DrGMacroPlayToolStateSelect.
	self changed
]

{ #category : #accessing }
DrGeo >> view [
	^ controlsManager view
]
