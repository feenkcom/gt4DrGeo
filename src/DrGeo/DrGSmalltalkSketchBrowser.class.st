"
A browser to visualize Smalltalk sketches
- model : DirectoryEntry where to find the Smallltalk sketch files
- selectedFile : the selected Smalltalk sketch file
- sketches : the name of the Smalltalk Sketches in the path (name file without extention)
- drgeoView : a DrGeo view of the smalltalkSketchFile, it is plugged in the browser
- codeView : a code view of the smalltalkSketchFile, it is plugged in the browser when check button code
"
Class {
	#name : #DrGSmalltalkSketchBrowser,
	#superclass : #DialogPanel,
	#instVars : [
		'selectedFile',
		'drgeoView',
		'codeView',
		'sketches',
		'sketchesListMorph',
		'pane'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'GUI building' }
DrGSmalltalkSketchBrowser >> buildMorphicWindow [
	super buildMorphicWindow.
	titleMorph showButtonsNamed: #(close expand).
]

{ #category : #states }
DrGSmalltalkSketchBrowser >> canDelete [
	^ self isMySketches and: [selectedFile notNil ]
]

{ #category : #states }
DrGSmalltalkSketchBrowser >> canEdit [
" Is there any editor listening to edit a selected Smalltalk Sketch? "
	^ self actionMap includesKey: #editSmalltalkSketch
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> compiledSketch: aSketch [
	| oldView |
	self releaseMiniView.
	oldView := drgeoView.
	drgeoView := aSketch view.
	pane replaceSubmorph: oldView by: drgeoView.
	self runningWorld doOneCycleNow.
]

{ #category : #initialization }
DrGSmalltalkSketchBrowser >> defaultColor [
	^ self windowColor 
]

{ #category : #'submorphs-add/remove' }
DrGSmalltalkSketchBrowser >> delete [
	super delete.
	self releaseMiniView 
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> deleteSketch [
	self canDelete ifTrue: [
		selectedFile delete.
		self sketch: 0]
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> edit [
" Inform any interested party the user wants to edit the selected sketch "
	self triggerEvent: #editSmalltalkSketch with: 	selectedFile.
	self delete.
]

{ #category : #initialization }
DrGSmalltalkSketchBrowser >> emptyView [
	^ BoxedMorph new
		color: self color;
		borderWidth: 1;
		layoutSpec: LayoutSpec useAll
]

{ #category : #menus }
DrGSmalltalkSketchBrowser >> expand [
	super expand.
	self fullScreen
]

{ #category : #initialization }
DrGSmalltalkSketchBrowser >> initialize [
	super initialize.
	sketchesListMorph := PluggableListMorph 
		model: self 		listGetter: #sketches 		indexGetter: #sketch indexSetter: #sketch:.
	drgeoView := self emptyView.
	codeView := (TextModelMorph textProvider: self textGetter: #sourceCode)
		disableEditing;
		yourself.
]

{ #category : #states }
DrGSmalltalkSketchBrowser >> isExamples [
	^ self isMySketches not
]

{ #category : #states }
DrGSmalltalkSketchBrowser >> isMySketches [
	^ model asString includesSubString: 'MySmalltalk'
]

{ #category : #geometry }
DrGSmalltalkSketchBrowser >> minimumExtent [
	^ Theme current scale: 800@600
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> model: aDirectoryEntry [
	model := aDirectoryEntry .
	sketches := nil
]

{ #category : #'GUI building' }
DrGSmalltalkSketchBrowser >> newButtonArea [
	| rowLeft rowRight |	
	buttonArea := LayoutMorph newRow 
		separation: 8@0; 
		yourself.
	rowLeft := LayoutMorph newRow.
	rowLeft 
		axisEdgeWeight: #rowLeft;
		addMorph: (PluggableButtonMorph 
			model: self 
			stateGetter: #isExamples 
			action: #switchToExamples 
			label: 'Examples' translated);
		addMorph: ((PluggableButtonMorph 
			model: self
			stateGetter: #isMySketches
			action: #switchToMySketches
			label: 'My Sketches' translated) 
				setBalloonText: 'Browse my collection of Smalltalk sketches.' translated;
				yourself).
	rowRight := LayoutMorph newRow.
	rowRight 
		axisEdgeWeight: #rowRight;		
		addMorph: ((PluggableButtonMorph
			model: self
			action: #edit
			label: 'Edit' translated) enableSelector: #canEdit; yourself).
	rowRight 
		addMorph: (PluggableButtonMorph
			model: self
			action: #delete
			label: 'Cancel' translated).
	rowRight 
		addMorph: ((PluggableButtonMorph 
			model: self
			action: #deleteSketch
			label: 'Delete' translated) 
				setBalloonText: 'Delete permanently this Smalltalk Sketch from disk.' translated;
				enableSelector: #canDelete; 
				yourself).		
	buttonArea 
		addMorph: rowLeft;
		addMorph: rowRight.
	^ buttonArea
]

{ #category : #'GUI building' }
DrGSmalltalkSketchBrowser >> newDrGeoColumn [
" the DrGeo view and an optional code view"
	^ pane := LayoutMorph newColumn
		addMorph: drgeoView proportionalHeight: 1;
		addAdjusterMorph ;
		yourself
]

{ #category : #'GUI building' }
DrGSmalltalkSketchBrowser >> newPane [
	^ LayoutMorph newRow
		separation: self defaultSeparation ;
		addMorph: self newSketchesColumn layoutSpec: (LayoutSpec new useMorphWidth );
		addMorphUseAll: self newDrGeoColumn;
		yourself
]

{ #category : #'GUI building' }
DrGSmalltalkSketchBrowser >> newSketchesColumn [
" The list of the sketch and an option to view the code"
	| checkGtoup |
	checkGtoup := CheckGroup fromList: {'Code' translated}.
	checkGtoup buttons first when: #checkSelection send: #showCode: to: self.
	^ LayoutMorph newColumn
		addMorph: sketchesListMorph layoutSpec: (LayoutSpec new useMorphWidth);
		addMorphKeepMorphHeight: checkGtoup ;
		yourself
		
]

{ #category : #'submorphs-add/remove' }
DrGSmalltalkSketchBrowser >> releaseMiniView [
	(drgeoView respondsTo: #presenter) 
		ifTrue: [drgeoView presenter ifNotNil: [:pres | pres release] ]
]

{ #category : #testing }
DrGSmalltalkSketchBrowser >> shouldAutoHighlight [
	^ false
]

{ #category : #'user interface support' }
DrGSmalltalkSketchBrowser >> shouldStyle: aText with: aSHTextStylerST80 [ 
	
	^true
]

{ #category : #testing }
DrGSmalltalkSketchBrowser >> shoutMustKeepContentsSize [
	^ true
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> showCode: aCheckButtonMorph [ 
| drgeoFraction |
	aCheckButtonMorph isSelected 
		ifTrue: 	[
			drgeoFraction := 0.7.
			pane addMorph: codeView proportionalHeight: 1 - drgeoFraction.
			codeView adoptWidgetsColor: self widgetsColor ]
		 ifFalse: [
			drgeoFraction := 1.
			pane removeMorph: codeView].
	drgeoView layoutSpec: (LayoutSpec proportionalHeight: drgeoFraction)
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> sketch [
	^ selectedFile 
		ifNil: [0] 
		ifNotNil: [	sketches indexOf: selectedFile baseName]
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> sketch: anIndex [
	anIndex = 0 
		ifTrue:  [	| oldView |
			self releaseMiniView.
			oldView := drgeoView.
			drgeoView := self emptyView .
			pane replaceSubmorph: oldView by: drgeoView.
			selectedFile := nil.
			self changed: #sourceCode]
		ifFalse: [
			selectedFile := model // ( (sketches at: anIndex) , '.st' ).
			self changed: #sourceCode.
			DrGeoSketch when: #newSmalltalkSketch send: #compiledSketch: to: self.
			selectedFile readStream fileIn	.
			DrGeoSketch removeActionsWithReceiver: self	]
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> sketches [
" The skteches files in the current path"
	^ sketches ifNil: [sketches := (model files 
			select: [:aFile | aFile extension = 'st']
			thenCollect: [:aFile | aFile baseName ]) sorted ]
			
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> sourceCode [
	^ selectedFile 
		ifNotNil: [	selectedFile fileContents]
		ifNil: ['']
]

{ #category : #'user interface support' }
DrGSmalltalkSketchBrowser >> styleByParagraphs [
	^ false
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> switchToExamples [
	model := DrGeoSystem smalltalkSketchesPath.
	self updateButtonsAndPreviews
]

{ #category : #accessing }
DrGSmalltalkSketchBrowser >> switchToMySketches [
	model := DrGeoSystem mySmalltalkSketchesPath.
	self updateButtonsAndPreviews
]

{ #category : #'user interface support' }
DrGSmalltalkSketchBrowser >> textStylerClassFor: object [
	^ SHTextStylerST80 
]

{ #category : #update }
DrGSmalltalkSketchBrowser >> updateButtonsAndPreviews [
	sketches := nil.
	self changed: #isExamples.
	self changed: #isMySketches.
	self changed: #sketches.
	self changed: #sourceCode.
	self changed: #canDelete.
	self sketch: 0
]

{ #category : #initialization }
DrGSmalltalkSketchBrowser >> windowColor [
	^ Theme current transcript 
]
