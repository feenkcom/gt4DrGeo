"
A wizard to plug a script instance in the canvas.
"
Class {
	#name : #DrGWizardScript,
	#superclass : #WizardPanel,
	#instVars : [
		'scripts'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'as yet unclassified' }
DrGWizardScript class >> sortedScripts [
" Return a list of the user script sorted by their scriptName "
	^ DrGeoUserScript subclasses 
		sorted: [:script1 :script2 | script1 scriptName asLowercase < script2 scriptName asLowercase]
]

{ #category : #pages }
DrGWizardScript >> addPages [
	self addPage: self firstPage ;
		addPage: self secondPage 
]

{ #category : #accessing }
DrGWizardScript >> argumentsName [
	| labels |
	^ model scriptClass 
		ifNil: [ #() ]
		ifNotNil: [
			labels := DrGScriptDesignerDialog classesAndLabels.
			model scriptClass argumentsType collect: [ :type | labels at: type ]
		]
]

{ #category : #'open/close' }
DrGWizardScript >> delete [
	super delete.
	model := nil
]

{ #category : #pages }
DrGWizardScript >> firstPage [
	^ (WizardPage firstPage: 'Use a script in the sketch' translated on: self) 	contents: 
'To use a script,

 1. First select a script from the list,
 2. Select items in the sketch,
 3. Click somewhere in the background. 
 Once enough items are selected, the script is
 inserted in the sketch, at the user selected position.
 To start press the ''next'' button.' translated
]

{ #category : #navigation }
DrGWizardScript >> goPage: integer [
	super goPage: integer.
	self changed: #scriptsName
]

{ #category : #accessing }
DrGWizardScript >> scripts [
	^ scripts 	ifNil: [ 	scripts := DrGWizardScript sortedScripts ]
]

{ #category : #accessing }
DrGWizardScript >> scriptsName [
	^ self scripts collect: [:class | class scriptName]
]

{ #category : #pages }
DrGWizardScript >> secondPage [
	| list argumentList page textMorph |
	list := PluggableListMorph 
		model: self listGetter: #scriptsName indexGetter: #selectedScript 		indexSetter: #selectedScript:. 
	argumentList := (PluggableListMorph 
		model: self listGetter: #argumentsName indexGetter: nil indexSetter: nil)
		setBalloonText: 'The arguments accepted by this script.' translated;
		yourself.
	textMorph := (TextModelMorph textProvider: model textGetter: #description textSetter: #description:)
		askBeforeDiscardingEdits: false;
		yourself.
	page := LabelGroup with: { 
		'Script name' translated -> list.
		'Description' translated -> textMorph.
		'Arguments' translated -> argumentList}.

	^ (WizardPage applyPage: 'Select a script then items in the sketch' translated on: self)
		 contents: page
]

{ #category : #accessing }
DrGWizardScript >> selectedScript [
	^ model scriptClass
		ifNil: [0]
		ifNotNil: [self scripts indexOf: model scriptClass]
]

{ #category : #accessing }
DrGWizardScript >> selectedScript: anIndex [ 
	model scriptClass: (self scripts at: anIndex ifAbsent: [nil]).
	self changed: #selectedScript.
	self changed: #argumentsName.
	model changed: #description
]
