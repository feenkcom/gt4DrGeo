"
A wizard to define a macro-construction. 
My model is a macro-construction builder (DrGMacroBuilder instance)
"
Class {
	#name : #DrGWizardMacroBuild,
	#superclass : #WizardPanel,
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'initialize-release' }
DrGWizardMacroBuild >> addPages [
	self addPage: self firstPage;
		addPage: self secondPage ;
		addPage: self thirdPage ;
		addPage: self fourthPage 
]

{ #category : #pages }
DrGWizardMacroBuild >> firstPage [
	^ (WizardPage firstPage: 'Build a macro-construction' translated on: self) contents:
'To build a macro-construction,

 1. First select the input paramaters,
 2. Next select the output parameters,
 3. Next chose a name and a description,
 4. Last apply the selection.' translated
		
]

{ #category : #pages }
DrGWizardMacroBuild >> fourthPage [
| pane row titleLabel descriptionLabel tMorph descrMorph labelsWidth |
	pane := self emptyPane.
	row := LayoutMorph newRow separation: 4.
	titleLabel := LabelMorph contents: 'Title:' translated.
	descriptionLabel := LabelMorph contents: 'Description:' translated.
	labelsWidth := titleLabel morphWidth max: descriptionLabel morphWidth.
	row addMorph: titleLabel fixedWidth: labelsWidth.
	tMorph := (TextModelMorph textProvider: model textGetter: #title textSetter: #title:)
		hideScrollBarsIndefinitely; 
		askBeforeDiscardingEdits: false.
	tMorph scroller 
		setProperty: #keyStroke: 
		toValue: [:event | 
			tMorph scroller acceptContents.
			self changed: #isReadyToApply].
	row addMorphUseAll: tMorph.
	pane addMorph: row fixedHeight: titleLabel morphHeight.
	row :=  LayoutMorph newRow separation: 4.
	row addMorph: descriptionLabel fixedWidth: labelsWidth .
	descrMorph := (TextModelMorph textProvider: model textGetter: #description textSetter: #description:)
		askBeforeDiscardingEdits: false.
	descrMorph scroller 
		setProperty: #keyStroke: 
		toValue: [:event | 
			descrMorph scroller acceptContents.
			self changed: #isReadyToApply].
	row addMorphUseAll: descrMorph.
	pane addMorphUseAll: row.
	^(WizardPage applyPage: 'Give a name and a description' translated on: self)
		contents: pane;
		yourself
]

{ #category : #testing }
DrGWizardMacroBuild >> isInputPage [
	^ currentPageIndex = 2
]

{ #category : #testing }
DrGWizardMacroBuild >> isOutputPage [
	^ currentPageIndex = 3
]

{ #category : #testing }
DrGWizardMacroBuild >> isReadyToApply [
"Can we apply the macro-construction to the selected geometric items?"
	^ model isMacroValid 
]

{ #category : #pages }
DrGWizardMacroBuild >> secondPage [
| list pane |
	list := PluggableListMorph 
		model: model
		listGetter: #inputNames
		indexGetter:  nil
		indexSetter: nil.
	pane := self emptyPane 
		addMorphUseAll: list;
		yourself.
	^ (WizardPage standardPage: 'Select input parameters' translated on: self)
		contents: pane;
		yourself
	
]

{ #category : #pages }
DrGWizardMacroBuild >> thirdPage [
| list pane |
	list := PluggableListMorph 
		model: model
		listGetter: #outputNames
		indexGetter:  nil
		indexSetter: nil.
	pane := self emptyPane 
		addMorphUseAll: list;
		yourself.
	^ (WizardPage standardPage: 'Select output parameters' translated on: self)
		contents: pane;
		yourself
	
]
