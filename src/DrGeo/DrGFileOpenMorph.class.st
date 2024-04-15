"
I am a dialog window to browse, select and open a sketch.
My model is a DirectoryEntry instance. 
Possible models are:
- DrGeoSystem examplesPath,
- DrGeoSystem mySketchesPath
"
Class {
	#name : #DrGFileOpenMorph,
	#superclass : #DialogPanel,
	#instVars : [
		'previews',
		'panel'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'instance creation' }
DrGFileOpenMorph class >> open [
	^ self open: DrGeoSystem examplesPath label: 'Open a sketch' translated
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> buildPane [
	| sketches row |
	DrGeoSystem startSpinner.
	panel 
		ifNil: [panel := LayoutMorph newColumn] 
		ifNotNil: [	panel removeAllMorphs; morphExtent: panel minimumExtent ].
	previews do: [:each | each breakDependents].
	previews := OrderedCollection new.
	sketches := (	model 	filesMatches: [:file | '*.fgeo' match: file name]) 
		sort: [:f1 :f2 | f1 name asLowercase < f2 name asLowercase ].
	sketches groupsOf: 3 atATimeDo: [:sketchesBy3 | 
		row := LayoutMorph newRow 	separation: 8; adoptWidgetsColor: self widgetsColor.
		panel addMorph: row.
		sketchesBy3 do: [:sketch |		
			row addMorph: (self previewMorphFor: sketch) ]] .
	sketches size \\ 3 ifNotZero: ["there are some left over"
		row := LayoutMorph newRow separation: 8; adoptWidgetsColor: self widgetsColor.
		panel addMorph: row.
		(sketches allButFirst: (	sketches size // 3 * 3)) do: [:sketch|
			row addMorph: (self previewMorphFor: sketch )]	].
	DrGeoSystem stopSpinner.
	^ panel
]

{ #category : #states }
DrGFileOpenMorph >> canDelete [
	^ self isMySketches and: [self selectedFile notNil ]
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> computePreviewFor: aSketchFile [
	| stream drgeo form |
	stream := aSketchFile readStream.
	[[drgeo := (DrGeoXml new loadOnlyFigureFrom: stream for: #service) first]
		on: Error do: []] 
		ensure: [stream close].
	drgeo 
		ifNil: [form := Form extent: 1@1] 
		ifNotNil: [drgeo previewOnFile: ((aSketchFile pathName allButLast: 4), 'png') asFileEntry	].
	^ form
]

{ #category : #initialization }
DrGFileOpenMorph >> defaultColor [
	^ self windowColor 
]

{ #category : #actions }
DrGFileOpenMorph >> deleteSketch [
"Delete the selected sketch"
	self canDelete ifTrue: [ | file |
		file := self selectedFile.
		file delete.
		((file pathName allButLast: 4), 'png') asFileEntry delete.
		self selectedPreview delete		]
	
	
	
]

{ #category : #initialization }
DrGFileOpenMorph >> initialize [
	super initialize.
	previews := #()
]

{ #category : #states }
DrGFileOpenMorph >> isExamples [
	^ model asString includesSubString: 'examples'
]

{ #category : #states }
DrGFileOpenMorph >> isMySketches [
	^ model asString includesSubString: 'MySketches'
]

{ #category : #geometry }
DrGFileOpenMorph >> minimumExtent [
	^ Theme current scale: 1000@500
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> newButtonArea [
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
		addMorph: (PluggableButtonMorph 
			model: self
			stateGetter: #isMySketches
			action: #switchToMySketches
			label: 'My Sketches' translated).
	rowRight := LayoutMorph newRow.
	rowRight 
		axisEdgeWeight: #rowRight;		
		addMorph: (PluggableButtonMorph
			model: self
			action: #ok
			label: 'Open' translated).
	rowRight 
		addMorph: (PluggableButtonMorph
			model: self
			action: #delete
			label: 'Cancel' translated).
	rowRight 
		addMorph: ((PluggableButtonMorph 
			model: self
			action: #deleteSketch) icon: Theme current deleteIcon).		
	buttonArea 
		addMorph: rowLeft;
		addMorph: rowRight.
	^ buttonArea
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> newPane [
	^ PluggableScrollPane new scroller: self buildPane; 
		scrollDeltaHeight: 80; 
		yourself
]

{ #category : #actions }
DrGFileOpenMorph >> ok [
"Open the selected sketch"
	self selectedFile ifNotNil: [:selectedFile |
		self delete.
		DrGeo file: selectedFile]
]

{ #category : #actions }
DrGFileOpenMorph >> open: previewMorph [
"Open the selected sketch"
	self delete.
	DrGeo file: previewMorph fileEntry
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> previewFor: aSketchEntry [
	| imageFilename form |
	imageFilename := ((aSketchEntry pathName allButLast: 4), 'png') asFileEntry.
	imageFilename exists 
		ifTrue: [	form := Form fromFileEntry: imageFilename]
		ifFalse: [form := self computePreviewFor: aSketchEntry ].
	^ form magnifyBy: (Theme current scale: Theme current previewSize x) / form width
]

{ #category : #'GUI building' }
DrGFileOpenMorph >> previewMorphFor: sketchEntry [
	| preview  |
	preview := (FilePreviewMorph 		
		file: sketchEntry 
		image: (self previewFor: sketchEntry ) 
		buttons: nil)
		when: #selected send: #update: to: self;
		when: #doubleClick send: #open: to: self.
	previews add: preview.
	preview layoutSpec offAxisEdgeWeight: #center.
	^ preview

]

{ #category : #accessing }
DrGFileOpenMorph >> selectedFile [
	^ self selectedPreview ifNotNil: [:aPreview | aPreview fileEntry]
]

{ #category : #accessing }
DrGFileOpenMorph >> selectedPreview [
"Detect the selected preview morph, if any"
	^ previews detect: [:preview | preview isSelected] ifFound: [:preview | preview] ifNone: [nil]
]

{ #category : #actions }
DrGFileOpenMorph >> switchToExamples [
	model := DrGeoSystem examplesPath.
	self updateButtonsAndPreviews 
]

{ #category : #actions }
DrGFileOpenMorph >> switchToMySketches [
	model := DrGeoSystem mySketchesPath.
	self updateButtonsAndPreviews 
]

{ #category : #update }
DrGFileOpenMorph >> update: aPreview [
 "aPreview is now the user selected preview, update all the previews accordingly"
	previews do: [:each | each selected: each == aPreview].
	self redrawNeeded 
]

{ #category : #update }
DrGFileOpenMorph >> updateButtonsAndPreviews [
	self changed: #isExamples.
	self changed: #isMySketches.
	self buildPane
]

{ #category : #initialization }
DrGFileOpenMorph >> windowColor [
	^ Theme current transcript 
]
