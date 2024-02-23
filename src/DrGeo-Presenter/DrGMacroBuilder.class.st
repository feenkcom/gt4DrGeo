"
A DrGMacroBuilder is builder to construct a macro-construction.
The builder needs an appropriate list of:
 - input & output mathItems selected in the drawing area
 - a macro-construction name & description

The builder checks the validity of the macro-construction, ie it checks if the outputs
items are deductible from the input items

Instance Variables

"
Class {
	#name : #DrGMacroBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'wizard',
		'input',
		'output',
		'description',
		'title'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGMacroBuilder class >> description [ 
	^ 'Construct a macro-construction with input and output items.' translated
]

{ #category : #documentation }
DrGMacroBuilder class >> title [
	^ 'Build macro' translated.
]

{ #category : #private }
DrGMacroBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	self isInputMode ifTrue: [self addToggleItem: aMathItemCollection in: input].
	self isOutputMode ifTrue: [self addToggleItem: aMathItemCollection in: output]
]

{ #category : #callback }
DrGMacroBuilder >> apply [
	"the user clicked the apply button, do we have all the needed information
	to instantiate a new macro construction?"
	DrGeoSystem showVirtualKeyboard: false.
	self isMacroValid ifTrue: 
		[ "we can instantiate a macro"
		self triggerEvent: #readyToBuild.
		^self].
	self isLogicValid ifFalse: 
		[self inform: 'Input and output items don''t match' translated].
	self isDescriptionValid ifFalse: 
		[self inform: 'Please, enter a proper title and description' translated]
]

{ #category : #accessing }
DrGMacroBuilder >> arguments [
	self shouldNotImplement
]

{ #category : #building }
DrGMacroBuilder >> buildItem [
	self shouldNotImplement
]

{ #category : #building }
DrGMacroBuilder >> buildItem: domain [ 
	| macro |
	macro := DrGMacro new
		title: title; description: description.
	macro 	from: input to: output 	in: domain.
	^ macro
]

{ #category : #callback }
DrGMacroBuilder >> cancel [
	"the user withdrawn the macro-construction creation"
	DrGeoSystem showVirtualKeyboard: false.
	self triggerEvent: #cancel
]

{ #category : #constant }
DrGMacroBuilder >> defaultDescription [
	^'Write down your description there.' asText
]

{ #category : #constant }
DrGMacroBuilder >> defaultTitle [
	^'Macro name' asText
]

{ #category : #accessing }
DrGMacroBuilder >> description [
	^description 
]

{ #category : #accessing }
DrGMacroBuilder >> description: string [
	description := string asString
]

{ #category : #building }
DrGMacroBuilder >> getItem [
	self shouldNotImplement
]

{ #category : #building }
DrGMacroBuilder >> getItem: domain [
	self isMacroValid ifTrue:
		[^self buildItem: domain].
	^nil
]

{ #category : #'initialize-release' }
DrGMacroBuilder >> initialize [
	self reset.
	wizard := (DrGWizardMacroBuild open: self) 
		addPages;
		openInWorld.
	wizard morphPosition: 0@0.
	wizard when: #page send: #page: to: self.
	wizard when: #apply send: #apply to: self.
	wizard when: #cancel send: #cancel to: self
]

{ #category : #accessing }
DrGMacroBuilder >> input [
	^input
]

{ #category : #accessing }
DrGMacroBuilder >> inputNames [
	^ self itemNames: input
]

{ #category : #testing }
DrGMacroBuilder >> isDescriptionValid [
	^ ((title = self defaultTitle) | (description = self defaultDescription)) not
]

{ #category : #testing }
DrGMacroBuilder >> isInputMode [
	^ wizard isInputPage
]

{ #category : #testing }
DrGMacroBuilder >> isLogicValid [
	"check wheter a macro can be deduced from the input/output item collections"
	^ DrGMacro 
		isValidWith: input
		and: output
]

{ #category : #testing }
DrGMacroBuilder >> isMacroValid [ 
	^self isLogicValid & self isDescriptionValid 
]

{ #category : #testing }
DrGMacroBuilder >> isOutputMode [
	^ wizard isOutputPage
]

{ #category : #testing }
DrGMacroBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty and: 
		[ self isInputMode &  (output includes: aMathItemCollection first) not or: [ self isOutputMode & (input includes: aMathItemCollection first) not ] ]
]

{ #category : #accessing }
DrGMacroBuilder >> itemNames: aMathItemCollection [
	^aMathItemCollection collect: [:mathItem | mathItem descriptiveName]
]

{ #category : #constant }
DrGMacroBuilder >> mathItemClass [
	self shouldNotImplement
]

{ #category : #accessing }
DrGMacroBuilder >> output [
	^output 
]

{ #category : #accessing }
DrGMacroBuilder >> outputNames [
	^ self itemNames: output
]

{ #category : #callback }
DrGMacroBuilder >> page: integer [ 
	"we receive notification from the wizard the user change the wizard
	current page"
	| newState |
	(integer = 1 or: [ integer = 4 ]) ifTrue: [ newState := DrGMacroToolStateNeutral ].
	integer = 2 ifTrue: [ newState := DrGMacroBuildToolStateInput ].
	integer = 3 ifTrue: [ newState := DrGMacroBuildToolStateOutput ].
	integer = 4 ifTrue: [DrGeoSystem showVirtualKeyboard: true].
	self 
		triggerEvent: #changedState
		with: newState
]

{ #category : #testing }
DrGMacroBuilder >> readyToBuild [
"Only when the user clicks on the wizard 'apply' button,
the system checks wheter the macro can be instiated"
	^false
]

{ #category : #'initialize-release' }
DrGMacroBuilder >> release [
	wizard removeActionsWithReceiver: self.
	wizard delete.
	wizard := nil
]

{ #category : #updating }
DrGMacroBuilder >> reset [
	super reset.
	input := OrderedCollection new.
	output := OrderedCollection new.
	title := self defaultTitle.
	description := self defaultDescription.
	self changed: #inputNames.
	self changed: #ouputNames.
	self changed: #title.
	self changed: #description
]

{ #category : #accessing }
DrGMacroBuilder >> title [
	^title
]

{ #category : #accessing }
DrGMacroBuilder >> title: string [
	title := string
]
