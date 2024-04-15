"
An editor to edit Smalltalk sketch. 
- There is an editor view to edit the Smalltalk code of the sketch and a DrGeo view where is rendered the sketch resulting from the compilation and execution of the Smalltalk code.
- There is a tool bar to load, save and execute the code.
- model : source code of the edited Smalltalk sketch
- file : file entry of the Smalltalk sketch
- drgeoView : a morph where to plug the view of the compiled model
- codeView : editor of the model
- docView : view of the Erudite DrGeo tutorial
- sketchProcess: the Smalltalk sketch is executed in its own thread
- playButton: the button to play and pause the Smalltalk sketch execution

"
Class {
	#name : #DrGSmalltalkSketchEditor,
	#superclass : #DialogPanel,
	#instVars : [
		'file',
		'drgeoView',
		'codeView',
		'pane',
		'sketchProcess',
		'playButton',
		'codeAndViewPanel',
		'debugger',
		'docView'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> autoCompleterClassFor: textGetter [
	^SmalltalkCompleter
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> browseSketches [
| browser |
	self stopSketch.
	browser := DrGSmalltalkSketchBrowser 
		open: DrGeoSystem smalltalkSketchesPath 
		label: 'Select a Smalltalk sketch' translated.
	browser when: #editSmalltalkSketch send: #loadSketch: to: self.
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> buildMorphicWindow [
	super buildMorphicWindow.
	titleMorph showButtonsNamed: #(close collapse expand).
	self toggleHelp.
	self activeHand newKeyboardFocus: codeView scroller
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> button: iconSymbol action: actionSelector help: helpString [
	^ (ButtonMorph model: self action: actionSelector)
			icon: (DrGIcons for: iconSymbol );
			setBalloonText: helpString ;
			color: Theme current drgeoButtonColor;
			selectedColor: Theme current drgeoButtonSelectedColor;
			borderColor: Theme current drgeoButtonColor muchDarker;
			borderWidth: 2;
			morphExtent: (Theme current toolbarIconSize + 4) asPoint;
			yourself
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> button: iconSymbol action: actionSelector state: getStateSel help: helpString [
	^ (ButtonMorph model: self stateGetter: getStateSel action: actionSelector)
			icon: (DrGIcons for: iconSymbol );
			setBalloonText: helpString ;
			color: Theme current drgeoButtonColor;
			selectedColor: Theme current drgeoButtonSelectedColor;
			borderColor: Theme current drgeoButtonColor muchDarker;
			borderWidth: 2;
			morphExtent: (Theme current toolbarIconSize + 4) asPoint;
			yourself
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> compiledSketch: aSketch [
	self releaseMiniView.
	drgeoView 
		removeAllMorphs;
		addMorph: aSketch view.
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> computeMessageEntriesIn: aDynamicTypingSmalltalkCompleter ofBlockArgNamed: aString [ 
	aDynamicTypingSmalltalkCompleter 
		computeMessageEntriesForClassOrNil: (DrGeoSystem preferences at: #programmingCodeCompletion)
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> computeMessageEntriesIn: aDynamicTypingSmalltalkCompleter ofBlockTempVarNamed: aString [ 
	aDynamicTypingSmalltalkCompleter 
		computeMessageEntriesForClassOrNil: (DrGeoSystem preferences at: #programmingCodeCompletion)
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> computeMessageEntriesIn: aDynamicTypingSmalltalkCompleter ofInstVarNamed: aString [ 
	aDynamicTypingSmalltalkCompleter 
		computeMessageEntriesForClassOrNil: (DrGeoSystem preferences at: #programmingCodeCompletion)
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> computeMessageEntriesIn: aDynamicTypingSmalltalkCompleter ofTempVarNamed: aString [ 
	aDynamicTypingSmalltalkCompleter 
		computeMessageEntriesForClassOrNil: (DrGeoSystem preferences at: #programmingCodeCompletion)
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> debugSketch [
" Execute the sketch step by step in a debugger "
	model ifEmpty: [^ self].
	self stopSketch.
	self isDocVisible ifTrue: [self toggleHelp].
	codeView scroller acceptContents.
	DrGeoSketch when: #newSmalltalkSketch send: #compiledSketch: to: self.
	codeView editor 
		afterCompiling: model 
		do:  [ :compiler :method :receiver :context | 
			(method notNil and: [method isQuick not]) ifTrue: [
				debugger := Debugger 
					openMinimalDebugging: [
						method
							valueWithReceiver: receiver 
							arguments: (context ifNil: [ #() ] ifNotNil: [ { context } ])]
					to: method.
				self plugDebugger ]			]
		ifFail: [].
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> debugWindowSketch [
	self stopSketch.
	codeView scroller acceptContents.
	codeView editor 
		afterCompiling: model 
		do:  [ :compiler :method :receiver :context | method ifNotNil: [ | window |
			window := Debugger 
				openMinimalDebugging: [
					method
						valueWithReceiver: receiver 
						arguments: (context ifNil: [ #() ] ifNotNil: [ { context } ])]
				to: method.
			window 	contextVariableInspector selectionIndex: 3.]
			]
		ifFail: [].
]

{ #category : #initialization }
DrGSmalltalkSketchEditor >> defaultColor [
	^ self windowColor 
]

{ #category : #'submorphs-add/remove' }
DrGSmalltalkSketchEditor >> delete [
	self stopSketch .
	super delete.
	self releaseMiniView 
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> editorClassFor: textGetter [
    ^SmalltalkEditor
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> executeSketch [
	self stopSketch.
	codeView scroller acceptContents.
	self switchToPauseButton.
	DrGeoSketch when: #newSmalltalkSketch send: #compiledSketch: to: self.
	sketchProcess := [ | t |
		t := DateAndTime now.
		(DrGeoSystem preferences at: #advancedDebugger) 
			ifTrue: [Compiler evaluate: model]
			ifFalse: [
				[Compiler evaluate: model] 
					on: Exception 
					do: [:ex | | myContext |
						myContext := ex signalerContext findContextSuchThat: [:aContext | 
							aContext method defaultSelector == #DoIt].
						debugger := Debugger 
							openMinimalDebuggingProcess: sketchProcess 
							context: myContext.
						self plugDebugger ]
			].
		" When we get there, sketch has been entirely executed, switch back to play button "
		self switchToPlayButton.
		Transcript show: DateAndTime now - t ;cr] newProcess.
	sketchProcess 
		priority: Processor userSchedulingPriority ;
		name: '[DrGeo] Smalltalk Sketch execution';
		resume.
]

{ #category : #geometry }
DrGSmalltalkSketchEditor >> expand [
	super expand.
	self fullScreen
]

{ #category : #initialization }
DrGSmalltalkSketchEditor >> initialize [
	| book |
	super initialize.
	book := EruditeBookReaderMorph new.
	docView := book
		model: DrGeoTutorial new; 
		buildMorphicWindow;
		layoutMorph.
	book when: #askToCopyCode send: #sourceCode: to: self.
	
	codeView := (TextModelMorph textProvider: self textGetter: #sourceCode textSetter: #sourceCode:)
		askBeforeDiscardingEdits: false;
		yourself.
	drgeoView :=  LayoutMorph new
		color: self color;
		borderWidth: 1;
		layoutSpec: LayoutSpec useAll
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> isDocVisible [
	^ docView visible
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> keepSketch [
| modelName |
	DrGeoSystem showVirtualKeyboard: true.
	codeView scroller acceptContents.
	modelName := (ValueHolder with: self sketchName)
	action: [:aString | 
		self setLabel: aString.
		file := DrGeoSystem mySmalltalkSketchesPath // (aString, '.st').
		file < model].
	(StringEntryPanel openWide: modelName label: 'Name the sketch to keep.' translated)
		morphCenter: self fullBoundsInOwner center;
		setProperty: #layerNumber toValue: 20
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> loadSketch: afileEntry [
" we are informed by the browser we want a file "
	file := afileEntry.
	self setLabel: self sketchName.
	self sourceCode: file fileContents
]

{ #category : #geometry }
DrGSmalltalkSketchEditor >> minimumExtent [
	^ Theme current scale: 800@600
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> model: sourceCode [
"Set an initial source code (string)"
	model := sourceCode

]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> newButtonArea [
	buttonArea := LayoutMorph newRow 
		axisEdgeWeight: #rowRight;
		addMorph: (PluggableButtonMorph
			model: self
			action: #delete
			label: 'Cancel' translated).
	^ buttonArea
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> newCodeAndView [
	^ LayoutMorph newRow
		separation: self defaultSeparation;
		addMorph: (codeAndViewPanel := LayoutMorph newColumn
			addMorph: codeView proportionalHeight: 0.7;
			addAdjusterMorph;
			addMorph: docView proportionalHeight: 0.3) 
		proportionalWidth: 0.5;
		addAdjusterMorph ;
		addMorph: drgeoView proportionalWidth: 0.5;
		yourself
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> newPane [
	^ LayoutMorph newColumn
		separation: self defaultSeparation ;
		addMorphKeepMorphHeight: self newToolbar;
		addMorphUseAll: self newCodeAndView;
		yourself
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> newToolbar [
	^ LayoutMorph newRow
		separation: 5@0 ;
		addMorph: (self button: #open action: #browseSketches help: 'Edit a Smalltalk sketch.' translated);
		addMorph: (self button: #keep action: #keepSketch help: 'Save this Smalltalk sketch.' translated);
		addMorph: (playButton := self button: #play action: #executeSketch help: 'Play the Smalltalk sketch.' translated);
		addMorph: (self button: #debug action: #debugSketch help: 'Debug the Smalltalk sketch.' translated);
		addMorph: (self button: #stop action: #stopSketch help: 'Stop the execution of the Smalltalk sketch.' translated);
		addMorph: self transparentMorph layoutSpec: (LayoutSpec proportionalWidth: 1.0);
		addMorph: (self button: #doc action: #toggleHelp state: #isDocVisible help: 'Dr. Geo tutorial' translated)
		yourself
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> pauseSketch [
    sketchProcess isTerminated ifTrue: [
        self stopSketch.
        ^self ].
    sketchProcess suspend.
    self switchToResumeButton.
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> plugDebugger [
" Install the debugger window at the place of the code viewer "
	debugger layoutMorph borderWidth: 1.
	codeAndViewPanel replaceSubmorph: codeView by: debugger layoutMorph.			
	debugger model when: #closeViews send: #stopDebbuger to: self.
	debugger 	contextVariableInspector selectionIndex: 3
]

{ #category : #'submorphs-add/remove' }
DrGSmalltalkSketchEditor >> releaseMiniView [
	drgeoView submorphCount = 1 ifTrue: [
		drgeoView firstSubmorph ifNotNil: [:miniView| 	
			miniView  presenter ifNotNil: [:p | p release] ]]
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> resumeSketch [
	sketchProcess resume.
	self switchToPauseButton
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> separator [
"The adjuster/separator between the codeView and docView"
	^ codeView owner submorphs second

]

{ #category : #testing }
DrGSmalltalkSketchEditor >> shouldAutoHighlight [
	^ false
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> shouldStyle: aText with: aSHTextStylerST80 [ 
	
	^true
]

{ #category : #testing }
DrGSmalltalkSketchEditor >> shoutMustKeepContentsSize [
	^ true
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> sketchName [
	^ file 	ifNil: [''] ifNotNil: [file baseName]
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> sourceCode [
	^ model 
		ifNotNil: [model]
		ifNil: ['']
]

{ #category : #accessing }
DrGSmalltalkSketchEditor >> sourceCode: aText [
	self model: aText asString.
	self changed: #clearUserEdits.
	self changed: #acceptedContents.
	self releaseMiniView.
	drgeoView removeAllMorphs

]

{ #category : #actions }
DrGSmalltalkSketchEditor >> stopDebbuger [
	debugger ifNotNil: [
		codeAndViewPanel replaceSubmorph: debugger layoutMorph by: codeView.
		debugger closeView.
		debugger := nil]
		
		
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> stopSketch [
	"DrGeoSketch removeActionsWithReceiver: self."	
	DrGeoSketch releaseActionMap .
	sketchProcess 	ifNotNil: [
		sketchProcess terminate.
		sketchProcess := nil	].
	self switchToPlayButton .
	self stopDebbuger 
	
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> styleByParagraphs [
	^ false
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> switchToPauseButton [
" 
Switch to pause sketch action 
"
	playButton 
		icon: (DrGIcons for: #pause);
		action: #pauseSketch;
		setBalloonText: 'Pause the Smalltalk sketch.' translated;
		redrawNeeded 
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> switchToPlayButton [
" 
Switch to play sketch action 
"
	playButton 
		icon: (DrGIcons for: #play);
		action: #executeSketch;
		setBalloonText: 'Play the Smalltalk sketch.' translated;
		redrawNeeded.
]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> switchToResumeButton [
" 
Switch to resume sketch action
"
	playButton 
		icon: (DrGIcons for: #resume);
		action: #resumeSketch;
		setBalloonText: 'Resume the Smalltalk sketch.' translated;
		redrawNeeded 
]

{ #category : #'user interface support' }
DrGSmalltalkSketchEditor >> textStylerClassFor: object [
	^ SHTextStylerST80 
]

{ #category : #actions }
DrGSmalltalkSketchEditor >> toggleHelp [
"Show/unshow the doc pane"
	debugger ifNotNil: [^ self]. "No doc while debugging, the pane does not like it"
	self isDocVisible 		ifTrue: [
		docView hide.
		codeView layoutSpec proportionalHeight: 1.0.
		docView layoutSpec proportionalHeight: 0.
		self separator hide			]
	ifFalse: [
		docView show.
		docView layoutSpec proportionalHeight: 0.3.
		codeView layoutSpec proportionalHeight: 0.7.
		self separator show		].
	self changed: #isDocVisible

]

{ #category : #'GUI building' }
DrGSmalltalkSketchEditor >> transparentMorph [
	^ BoxedMorph new 
		borderWidth: 0;
		color: Color transparent; 
		yourself
]

{ #category : #initialization }
DrGSmalltalkSketchEditor >> windowColor [
	^ Theme current workspace 
]
