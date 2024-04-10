Class {
	#name : #DGCodeExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #example }
DGCodeExamples >> backquotedLines [
	<gtExample>
	^ Character lf
		join: (self drGeoSrc contents lines select: [ :l | l includes: $` ])
]

{ #category : #example }
DGCodeExamples >> backquotedLinesPatched [
	<gtExample>
	| patched |
	patched := self patchBackquotesIn: self backquotedLines.
	self assert: (patched includesSubstring: '#	') not.
	self assert: (self orphanParensIn: patched) isEmpty.
	^ patched
]

{ #category : #utility }
DGCodeExamples >> cloneDrGeo [
	| drGeoRepo repo |
	drGeoRepo := 'DrGeo' asFileReference.
	drGeoRepo ensureDeleteAll.
	repo := 'git@github.com:hilaire/drgeo.git'.
	IceRepositoryCreator fromUrl: repo to: drGeoRepo.
	drGeoRepo
]

{ #category : #example }
DGCodeExamples >> customButtonSpecs [
	"This code in the source file has tabs after the # in symbols."

	<gtExample>
	| tabbedSymbols |
	tabbedSymbols := '!DrGDebuggerWindow methodsFor: ''GUI building'' stamp: ''hlsf 10/13/2022 12:08:52''!
customButtonSpecs
	"Answer an array of elements of the form wording, selector, help-message, that characterize the custom button row of a debugger."

	^{
		{''Restart'' translated . #		restart	 . 		''Restart the step by step execution from its start.'' translated } .
		{''Step''	 translated . 	#	doStep .			 ''Execute the current message and go to the next message.'' translated } .
		{''Step into''		 translated . #stepIntoBlock		 . ''Step into a block.'' translated } .
		{''Run to Cursor'' translated . #		runToCursor	 . 	''Execute the code up to the cursor position.'' translated }
	}! !'.
	self assert: (tabbedSymbols includesSubstring: '#	').
	^ tabbedSymbols
]

{ #category : #example }
DGCodeExamples >> customButtonSpecsPatched [
	<gtExample>
	| patchTabbedSymbols |
	patchTabbedSymbols := self patchTabbedSymbolsIn: self customButtonSpecs.
	self assert: (patchTabbedSymbols includesSubstring: '#	') not.
	^ patchTabbedSymbols
]

{ #category : #example }
DGCodeExamples >> drGMorphColorSlot [
	"Definition of DrGMorph has a duplicate color slot."

	<gtExample>
	^ '!classDefinition: #DrGMorph category: #''DrGeo-View-Item''!
Morph subclass: #DrGMorph
	instanceVariableNames: ''drawable mathItem color style labelMorph labelPositionDelta blink''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''DrGeo-View-Item''!
!classDefinition: ''DrGMorph class'' category: #''DrGeo-View-Item''!
DrGMorph class
	instanceVariableNames: ''''!
'
]

{ #category : #example }
DGCodeExamples >> drGMorphColorSlotPatched [
	"Definition of DrGMorph has a duplicate color slot."

	<gtExample>
	| sourceString patchedString |
	sourceString := self drGMorphColorSlot.
	self assert: (sourceString includesSubstring: self drGMorphSlots).
	patchedString := self patchColorIn: sourceString.
	self assert: (patchedString includesSubstring: self drGMorphSlots) not.
	^ patchedString
]

{ #category : #example }
DGCodeExamples >> drGMorphSlots [
	<gtExample>
	^ 'drawable mathItem color style labelMorph'
]

{ #category : #example }
DGCodeExamples >> drGeoRepo [
	<gtExample>
	| drGeoRepo |
	drGeoRepo := 'DrGeo' asFileReference.
	drGeoRepo exists ifFalse: [ self cloneDrGeo ].
	^ drGeoRepo
]

{ #category : #example }
DGCodeExamples >> drGeoSrc [
	<gtExample>
	^ self drGeoRepo / 'src/DrGeo.pck.st'
]

{ #category : #example }
DGCodeExamples >> drGeoSrcPatched [
	"Applies the sequence of patches."

	<gtExample>
	^ self patchColorFile
]

{ #category : #example }
DGCodeExamples >> dummyClasses [
	<gtExample>
	^ self missingClasses
		collect: [ :eachClass | 
			eachClass
				asClassInEnvironment: Smalltalk globals
				ifAbsent: [ Object
						subclass: eachClass
						instanceVariableNames: ''
						classVariableNames: ''
						package: 'DrGeo-Missing' ] ]
]

{ #category : #example }
DGCodeExamples >> missingClasses [
	<gtExample>
	^ #(ActiveModel LayoutMorph DebuggerWindow WizardPanel DialogPanel Panel BoxedMorph MorphDummy PreferenceType Debugger MorphicEruditeDocRenderer PreferenceBrowserVisitor Theme)
]

{ #category : #utility }
DGCodeExamples >> orphanParensIn: aString [
	"Extract the parentheses in a string, deleting all the balanced ones."

	| parens |
	parens := aString select: [ :each | '()' includes: each ].
	[ parens includesSubstring: '()' ]
		whileTrue: [ parens := '' join: ('()' split: parens) ].
	^ parens
]

{ #category : #example }
DGCodeExamples >> patchBackquotesFile [
	"Patch the backquotes."

	<gtExample>
	| patchBackquotes input |
	patchBackquotes := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patchBackquotes.st'.
	patchBackquotes
		writeStreamDo: [ :aStream | 
			input := DGCodeExamples new patchTabbedSymbolsFile readStream.
			[ input atEnd ]
				whileFalse: [ | line |
					line := input nextLine.
					(line includes: $`) ifTrue: [ line := self patchBackquotesIn: line ].
					aStream
						nextPutAll: line;
						lf ] ].
	^ patchBackquotes
]

{ #category : #utility }
DGCodeExamples >> patchBackquotesIn: aString [
	| parts |
	parts := $` split: aString.
	self assert: parts size odd.
	^ ''
		join: (parts
				withIndexCollect: [ :p :i | i > 1 ifTrue: [ i even ifTrue: [ '(' , p ] ifFalse: [ ')' , p ] ] ifFalse: [ p ] ])
]

{ #category : #example }
DGCodeExamples >> patchColorFile [
	"Remove the color slot from DrGeoMorph."

	<gtExample>
	| patchColor input |
	patchColor := DGCodeExamples new drGeoRepo / 'src/DrGeo-patchColor.st'.
	patchColor
		writeStreamDo: [ :aStream | 
			input := DGCodeExamples new drGeoSrc readStream.
			[ input atEnd ]
				whileFalse: [ | line |
					line := self patchColorIn: input nextLine.
					aStream
						nextPutAll: line;
						lf ] ].
	^ patchColor
]

{ #category : #utility }
DGCodeExamples >> patchColorIn: aString [
	"NB: The initial test brings a 10x speedup."

	(aString includesSubstring: self drGMorphSlots) ifFalse: [ ^ aString ].
	^ aString
		copyWithRegex: self drGMorphSlots
		matchesReplacedWith: 'drawable mathItem style labelMorph'
]

{ #category : #example }
DGCodeExamples >> patchTabbedSymbolsFile [
	"Patch the tabbed symbols."

	<gtExample>
	| patchTabbedSymbols input |
	patchTabbedSymbols := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patchTabbedSymbols.st'.
	patchTabbedSymbols
		writeStreamDo: [ :aStream | 
			input := DGCodeExamples new patchColorFile readStream.
			[ input atEnd ]
				whileFalse: [ | line |
					line := self patchTabbedSymbolsIn: input nextLine.
					aStream
						nextPutAll: line;
						lf ] ].
	^ patchTabbedSymbols
]

{ #category : #utility }
DGCodeExamples >> patchTabbedSymbolsIn: aString [
	^ aString copyWithRegex: '#\t+' matchesReplacedWith: '#'
]

{ #category : #utility }
DGCodeExamples >> removeDrGeoPackages [
	"remove all the filed-in stuff"

	(RPackageOrganizer default packages
		select: [ :p | p name beginsWith: 'DrGeo-' ]) do: #removeFromSystem
]
