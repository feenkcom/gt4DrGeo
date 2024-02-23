"
A DrGMacroPlayer is a builder used to play a macro-construction against a user provided list of input items.
It chekcs the validity of the input items against the macro-construction definition.
The input parameters type must be user selected in the same order as they appear in the macro inputNodes definition.
"
Class {
	#name : #DrGMacroPlayer,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'wizard',
		'selectedMacro',
		'input'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGMacroPlayer class >> description [ 
	^'Execute a pre-built macro-construction on selected input items. To edit a macro description, edit its text and apply with the keys [alt/ctrl]+s.' translated
]

{ #category : #documentation }
DrGMacroPlayer class >> title [
	^ 'Execute/edit macro' translated
]

{ #category : #private }
DrGMacroPlayer >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	self addToggleItem: aMathItemCollection in: input
]

{ #category : #building }
DrGMacroPlayer >> buildItem [
	^selectedMacro execute: input in: presenter.
]

{ #category : #callback }
DrGMacroPlayer >> cancel [
	self triggerEvent: #cancel
]

{ #category : #accessing }
DrGMacroPlayer >> constructedNodes [
	^ selectedMacro constructedNodes 
]

{ #category : #accessing }
DrGMacroPlayer >> description [
	^ selectedMacro ifNotNil: [selectedMacro description] ifNil: [^'']
]

{ #category : #accessing }
DrGMacroPlayer >> description: text [ 
	selectedMacro ifNotNil: [selectedMacro description: text asString]
]

{ #category : #'initialize-release' }
DrGMacroPlayer >> initialize [
	wizard := (DrGWizardMacroPlay open: self) 
		addPages;
		openInWorld.
	wizard morphPosition: 0@0.
	input := OrderedCollection new.
	wizard when: #page send: #page: to: self.
	wizard when: #cancel send: #cancel to: self
]

{ #category : #accessing }
DrGMacroPlayer >> input [
	^input
]

{ #category : #accessing }
DrGMacroPlayer >> inputBasicType [
	^input collect: [:i | i basicType]
]

{ #category : #testing }
DrGMacroPlayer >> isWanted: aMathItemCollection [
	selectedMacro isNil ifTrue: [^false].
	^aMathItemCollection notEmpty and: 
		[(selectedMacro inputBasicType at: input size + 1 ) == aMathItemCollection first basicType]
]

{ #category : #callback }
DrGMacroPlayer >> page: integer [ 
	"we receive notification from the wizard the user change the wizard
	current page"
	| newState |
	integer = 1 
		ifTrue: [ newState := DrGMacroToolStateNeutral ]
		ifFalse: [ newState := DrGMacroPlayToolStateSelect].
	self 
		triggerEvent: #changedState
		with: newState
]

{ #category : #testing }
DrGMacroPlayer >> readyToBuild [
	^ self inputBasicType = selectedMacro inputBasicType
]

{ #category : #'initialize-release' }
DrGMacroPlayer >> release [
	wizard removeActionsWithReceiver: self.
	wizard delete.
	wizard := nil
]

{ #category : #updating }
DrGMacroPlayer >> reset [
	super reset.
	input := OrderedCollection new.
	selectedMacro := nil.
	self changed: #description.
	self flag: #drgeoTodo
	"wizard changed: #selectedMacro"
]

{ #category : #accessing }
DrGMacroPlayer >> selectedMacro [
	^selectedMacro 
]

{ #category : #accessing }
DrGMacroPlayer >> selectedMacro: aMacro [
	"Some cleaning are needed"
	selectedMacro := aMacro.
	input := OrderedCollection new.
	self triggerEvent: #changedMacro.
]
