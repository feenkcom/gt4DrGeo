Class {
	#name : #DrGScriptPlayer,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'wizard',
		'input',
		'scriptClass'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #xml }
DrGScriptPlayer class >> basicItemFrom: node [
"create a basic item (unitialised) from this node and add it to the domain, return an item partially initialized. Use for macro node"
	| builder |
	builder := self basicNew basicInitialize.
	^ builder basicItemFrom: node
]

{ #category : #documentation }
DrGScriptPlayer class >> description [
	^ 'Insert a Smalltalk script in the drawing area.' translated
]

{ #category : #xml }
DrGScriptPlayer class >> itemFrom: node in: presenter [
"create an item from this node and add it to the domain, return a couple {item. boolean}"
	| builder |
	builder := self basicNew basicInitialize; presenter: 	presenter;  yourself.
	^ builder itemFrom: node
]

{ #category : #documentation }
DrGScriptPlayer class >> title [
	^ 'Use a script' translated
]

{ #category : #private }
DrGScriptPlayer >> addItem: aMathItemCollection at: aPoint [
"Take the point position only when the user clic somewhere in the background"
	aMathItemCollection ifEmpty: 
		[point := aPoint.
		^self].
	input size < scriptClass argumentsType size
		ifTrue: [self addToggleItem: aMathItemCollection in: input]
		ifFalse: [input remove: aMathItemCollection first ifAbsent: []]
]

{ #category : #accessing }
DrGScriptPlayer >> arguments [
	^ (OrderedCollection withAll: input)
		add: scriptClass;
		add: point;
		yourself
]

{ #category : #'initialize-release' }
DrGScriptPlayer >> basicInitialize [
	input := OrderedCollection new.
]

{ #category : #xml }
DrGScriptPlayer >> basicItemFrom: node [
"create a scrip item then set its script from the xml node information"
| item |
	item := super basicItemFrom: node.
	item script: (node attributeAt: #class) asClass.
	^ item
]

{ #category : #callback }
DrGScriptPlayer >> cancel [
	self triggerEvent: #cancel
]

{ #category : #accessing }
DrGScriptPlayer >> description [
	| comment |
	^ scriptClass
		ifNil: ['']
		ifNotNil: 
			[comment := scriptClass description.
			comment isEmpty 
				ifTrue: ['No description, write one in the description method of this script.' translated]
				ifFalse: [comment]]
]

{ #category : #accessing }
DrGScriptPlayer >> description: aText [ 
" Not yet implemented, should rewrite the description of the selected scriptClass "
	self flag: #drgeoTodo
]

{ #category : #'initialize-release' }
DrGScriptPlayer >> initialize [
	wizard := (DrGWizardScript open: self)
		addPages;
		openInWorld.
	input := OrderedCollection new.
	wizard when: #page send: #page: to: self.
	wizard when: #cancel send: #cancel to: self.
]

{ #category : #accessing }
DrGScriptPlayer >> input [
	^input
]

{ #category : #testing }
DrGScriptPlayer >> isWanted: aMathItemCollection [ 
	"We are now performing type checking for script, we are also interested
in empty aMathItemCollection, (ie: just get the clic position in the background)"
	scriptClass ifNil: [^false].
	aMathItemCollection ifEmpty: [ ^ true ].
	^ input size = scriptClass argumentsType size 
		ifTrue: 
			[input includes: aMathItemCollection first]
		ifFalse: 
			[aMathItemCollection first class includesBehavior: (scriptClass argumentsType at: input size + 1)]
]

{ #category : #xml }
DrGScriptPlayer >> itemInstanceFrom: node [
	self scriptClass: (Smalltalk at: (node attributeAt: #class) asSymbol).
	self add: #() at: 0@0.
	(self parentsById: node) do: [:each |	self addItem: {each} at: 0@0].
	^ self getItem first.
]

{ #category : #testing }
DrGScriptPlayer >> mathItemClass [
	^DrGValueScriptItem 
]

{ #category : #callback }
DrGScriptPlayer >> page: integer [ 
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

{ #category : #xml }
DrGScriptPlayer >> postProcess: item from: node [
	super postProcess: item from: node.
	self parseValuePosition: node of: item
]

{ #category : #testing }
DrGScriptPlayer >> readyToBuild [
	scriptClass ifNil: [^false].
	^ input size = scriptClass argumentsType size and: [ point isNil not ]
]

{ #category : #'dependents access' }
DrGScriptPlayer >> release [
	self removeEvents.
	wizard delete.
	wizard := nil
]

{ #category : #'initialize-release' }
DrGScriptPlayer >> removeEvents [
	wizard removeActionsWithReceiver: self
]

{ #category : #testing }
DrGScriptPlayer >> reset [
	super reset.
	input := OrderedCollection new.
]

{ #category : #accessing }
DrGScriptPlayer >> scriptClass [
	^ scriptClass
]

{ #category : #accessing }
DrGScriptPlayer >> scriptClass: anObject [
	scriptClass := anObject.
	input := OrderedCollection new.
	self triggerEvent: #changedScript.
]
