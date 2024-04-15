"
A wizard to play (execute) a macro-construction. 
My model is a macro-construction player (DrGMacroPlayer instance)
"
Class {
	#name : #DrGWizardMacroPlay,
	#superclass : #WizardPanel,
	#instVars : [
		'macroFactories'
	],
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'initialize-release' }
DrGWizardMacroPlay >> addPages [

	^ self
		addPage: self firstPage;
		addPage: self secondPage
]

{ #category : #pages }
DrGWizardMacroPlay >> firstPage [
	^ (WizardPage firstPage: 'Execute a macro-construction' translated on: self) 	contents: 
'To execute a macro-construction,

 1. First select a macro-construction from the list,
 2. Select items on the figure. Only items relevant
 to the selected macro-construction are selectable.
 Once enough items are selected, the macro is
 automaticly executed.
 To start press the ''next'' button.' translated
]

{ #category : #'initialize-release' }
DrGWizardMacroPlay >> initialize [
	super initialize.
	macroFactories := DrGMacroFactory new
]

{ #category : #testing }
DrGWizardMacroPlay >> isReadyToApply [
"It is not relevant, apply button disabled"
	^ false
]

{ #category : #testing }
DrGWizardMacroPlay >> isSelectPage [
	^ currentPageIndex = 2
]

{ #category : #accessing }
DrGWizardMacroPlay >> macroList [
	^ macroFactories titles
]

{ #category : #pages }
DrGWizardMacroPlay >> secondPage [
| pane morph |
	morph := PluggableListMorph 
		model: self
		listGetter: #macroList
		indexGetter: #selectedMacro
		indexSetter: #selectedMacro:.
	pane  := self emptyPane
		addMorphKeepMorphHeight: (LabelMorph contents: 'Title:' translated);
		addMorph: morph proportionalHeight: 0.3;
		addMorphKeepMorphHeight: (LabelMorph contents: 'Description:' translated);		
		yourself.
	morph := TextModelMorph textProvider: model textGetter: #description textSetter: #description:.
	morph hideScrollBarsIndefinitely; askBeforeDiscardingEdits: false.
	pane addMorphUseAll: morph.
	^ (WizardPage applyPage: 'Select a macro-construction then the figure items' translated on: self)
		contents: pane;
		yourself
	
]

{ #category : #accessing }
DrGWizardMacroPlay >> selectedMacro [
	^ macroFactories indexOf: model selectedMacro
]

{ #category : #accessing }
DrGWizardMacroPlay >> selectedMacro: anIndex [
	model selectedMacro: (macroFactories at: anIndex).
	self changed: #selectedMacro.
	model changed: #description.
]
