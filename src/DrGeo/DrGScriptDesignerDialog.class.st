"
I am a dialog to design a DrGeo script: 
- my model is the presenter of my DrGeo app instance
- its name
- its description
- its attributes types (class of math items)
"
Class {
	#name : #DrGScriptDesignerDialog,
	#superclass : #DialogPanel,
	#instVars : [
		'scriptName',
		'description',
		'argumentsMorph'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'labels and classes' }
DrGScriptDesignerDialog class >> classesAndLabels [
	| dict |
	dict := Dictionary new.
	self labelsAndClasses associationsDo: [ :assoc | 
		dict add: assoc value -> assoc key ].
	^ dict
	
]

{ #category : #'labels and classes' }
DrGScriptDesignerDialog class >> indexOfLabel: string [
	self labels withIndexDo: [:label :i |
		label = string ifTrue: [ ^ i ]].
	self errorNotFound: string
]

{ #category : #'labels and classes' }
DrGScriptDesignerDialog class >> labels [
	^ self labelsAndClasses keys sorted
]

{ #category : #'labels and classes' }
DrGScriptDesignerDialog class >> labelsAndClasses [
	^ Dictionary newFrom: {
		'Any type' translated -> DrGMathItem.
		'Point' translated -> DrGPointItem.
		'Direction' translated -> DrGDirectionItem.
		'Line' translated -> DrGLineItem.
		'Ray' translated -> DrGRayItem.
		'Segment' translated -> DrGSegmentItem.
		'Polygon' translated -> DrGPolygonItem.
		'Vector' translated -> DrGVectorItem.
		'Circle' translated -> DrGCircleItem.
		'Arc' translated -> DrGArcItem.
		'Locus' translated -> DrGLocus2ptsItem.
		'Value' translated -> DrGValueItem.
		'Angle' translated -> DrGAngleItem}
]

{ #category : #action }
DrGScriptDesignerDialog >> addArgument [
	| newArgument |
	newArgument := LayoutMorph newRow
		adoptWidgetsColor: widgetsColor;
		borderWidth: 1;
		yourself.
	newArgument addMorph: ((PluggableButtonMorph model: self action: #removeArgument:)
			icon: Theme current deleteIcon;
			actionArgument: newArgument;
			borderWidth: 0;
			color: Color transparent;
			setBalloonText:  'Remove this script argument.' translated;
			yourself);		
		addMorph: ((DropDownListMorph 
			model: (ListModel with: self class labels)
			listGetter: #list
			indexGetter:  #listIndex
			indexSetter: #listIndex:)
			adoptWidgetsColor: widgetsColor).
	argumentsMorph addMorph: newArgument.
	self morphExtent: self minimumExtent 
]

{ #category : #accessing }
DrGScriptDesignerDialog >> arguments [ 
"The arguments as selected by the user"
|alignments|
	alignments := argumentsMorph submorphs select: [ :morph | morph class = LayoutMorph].
	^  alignments reverse collect: [ :each | each submorphs first selectedItem].
	
]

{ #category : #accessing }
DrGScriptDesignerDialog >> argumentsClass [
"The arguments type as selected by the user, tpye=class from the MathItem hierarchy"
|dict|
	dict := self class labelsAndClasses .
	^ self arguments collect: [:aLabel | dict at: aLabel]
]

{ #category : #action }
DrGScriptDesignerDialog >> build [
	| scriptClass stream |
	self delete.
	"Build a new script from the user specification"
	scriptClass := DrGeoUserScript 
		subclass: ('DrGeoScript', self scriptName hash printString) asSymbol
		instanceVariableNames: '' 
		classVariableNames: '' 
		poolDictionaries: ''
		category:  'DrGeo-Model-Script'.
	"name"
	stream := WriteStream on: String new.
	stream nextPutAll: 'scriptName';
		newLineTab: 1 ;
		nextPut: $^ ;
		nextPutAll: self scriptName printString.
	scriptClass class compile: stream contents classified: 'public'.
	"description"
	stream := WriteStream on: String new.
	stream nextPutAll: 'description';
		newLineTab: 1;
		nextPut:  $^ ;
		nextPutAll: self description printString.
	scriptClass class compile: stream contents classified: 'public'.
	"argumentsType"
	stream := WriteStream on: String new.
	stream nextPutAll: 'newArgumentsType';
		newLineTab: 1;
		nextPut: 	$^; nextPut: ${.
	self argumentsClass 
		do: [:aClass| stream nextPutAll: aClass printString] 
		separatedBy: [stream nextPut: $.].
	stream nextPut: $}.
	scriptClass class compile: stream contents classified: 'private'.
	"compute"
	stream := WriteStream on: String new.
	stream nextPutAll: 'compute';
		newLine;
		nextPutAll: '"Edit me"';
		newLineTab: 1;
		nextPut: $^;
		nextPutAll: '1+1'.
	scriptClass compile: stream contents classified: 'public'.
	"Browse the newly created script"
	model editScript: scriptClass
]

{ #category : #action }
DrGScriptDesignerDialog >> cancel [
	self delete
]

{ #category : #accessing }
DrGScriptDesignerDialog >> description [
	^ description asString
]

{ #category : #accessing }
DrGScriptDesignerDialog >> description: aString [
	description := aString 
]

{ #category : #initialization }
DrGScriptDesignerDialog >> initialize [
	super initialize.
	scriptName := ''.
	description := ''
]

{ #category : #action }
DrGScriptDesignerDialog >> isValid [
"respond wheter the given input data is valid to build a script"
	scriptName asString withBlanksCondensed isEmpty ifTrue: [ ^ false ].
	description asString withBlanksCondensed isEmpty ifTrue: [ ^ false ].
	(Smalltalk hasClassNamed: #DrGeoScript, scriptName asString hash printString) ifTrue: [ ^ false ].
	^ true
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newAddArgumentButton [
	^ (PluggableButtonMorph model: self action:  #addArgument label: 'Add argument' translated)
			setBalloonText: 'Add an argument to this script.' translated;
			yourself
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newArgumentMorph [
	^ LayoutMorph newRow
		color: Color transparent ;
		addMorph: self newAddArgumentButton;
		separation: 4@0;
		yourself
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newButtonArea [
	buttonArea := LayoutMorph newRow
		separation: 8@0;
		addMorph: ((PluggableButtonMorph model: self action: #build label: 'Build' translated)
				enableSelector: #isValid; 
				setBalloonText: 'Build a script with these settings.' translated;
				yourself)
		layoutSpec: (LayoutSpec new
			useMorphWidth ;
			proportionalHeight:  1;
			offAxisEdgeWeight: #center);
		addMorph: (PluggableButtonMorph model: self action:  #cancel label: 'Cancel' translated)
		layoutSpec: (LayoutSpec new
			useMorphWidth ;
			proportionalHeight:  1;
			offAxisEdgeWeight: #center);
		axisEdgeWeight: #rowRight;
		color: Color transparent.
	^ buttonArea 
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newDescriptionMorph [
| morph |
	morph := (TextModelMorph textProvider: self textGetter: #description textSetter: #description:)
		askBeforeDiscardingEdits: false;
		setBalloonText:  'A description of the script. To help the user, describe carefully what the script does and the input arguments to select to use it.' translated;
		yourself	.
	morph scroller setProperty: #keyStroke: toValue: [:event | 
		morph scroller acceptContents.
		self changed: #isValid]. 
	^ morph
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newPane [
	^ LabelGroup with: {
		'Name' translated -> self newScriptNameMorph .
		'Description' translated -> self newDescriptionMorph .
		'Arguments' translated -> (argumentsMorph :=  self newArgumentMorph)	
	}
]

{ #category : #'GUI building' }
DrGScriptDesignerDialog >> newScriptNameMorph [
| morph |
	morph := (TextModelMorph textProvider: self textGetter: #scriptName textSetter:  #scriptName:)
		hideScrollBarsIndefinitely;
		askBeforeDiscardingEdits: false;
		acceptOnCR: true;
		morphHeight: FontFamily defaultPointSize;
		setBalloonText:  'The name of the script.' translated;
		yourself	.
	morph scroller setProperty: #keyStroke: toValue: [:event | 
		morph scroller acceptContents.
		self changed: #isValid]. 
	^ morph
]

{ #category : #action }
DrGScriptDesignerDialog >> removeArgument: aRowArgument [
	argumentsMorph removeMorph: aRowArgument .
	self morphExtent: self minimumExtent 
]

{ #category : #accessing }
DrGScriptDesignerDialog >> scriptName [
	^ scriptName asString
]

{ #category : #accessing }
DrGScriptDesignerDialog >> scriptName: aString [
	scriptName := aString 
]
