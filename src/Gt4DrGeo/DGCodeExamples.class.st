"
I contain examples of loading the DrGeo source code and patching versions of the fileIn.

`drGeoRepo` -- clone the repo if necessary
`drGeoSrc`` -- the original fileIn, with issues to be patched for GT
`dummyClasses` -- dummy classes from Cuis that are missing in GT
`drGeoSrcPatched` -- the final, patched fileIn, with various issues fixed

To file in the final, patched code, run:
```
DGCodeExamples new drGeoSrcPatched fileIn.
```

To remove the filed-in code:
```
DGCodeExamples new removeFiledInCode.
```


"
Class {
	#name : #DGCodeExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #example }
DGCodeExamples >> archive [
	"A folder where we keep some past versions of the patched source code."

	<gtExample>
	^ FileLocator gtResource / 'feenkcom' / 'gt4DrGeo' / 'drgeo' / 'patches'
]

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

{ #category : #example }
DGCodeExamples >> brokenClassBuilderMethod [
	"This redefinition in DrGeo breaks GT, so we must fix it by changing the method name."

	<gtExample>
	^ '!Class methodsFor: ''*DrGeo-subclass creation'' stamp: ''hlsf 4/18/2020 21:29:40''!
subclass: t instanceVariableNames: f classVariableNames: d package: cat
"This is a hack to import DrGeo Pharo code"
	
	| answer |
	answer := ClassBuilder new
		superclass: self
		subclass: t
		instanceVariableNames: f
		classVariableNames: d
		poolDictionaries: nil
		category: cat.
		
	Smalltalk
		logChange: answer definition 
		preamble: answer definitionPreamble.
	^answer
! !'
]

{ #category : #example }
DGCodeExamples >> brokenInitializationMethod [
	"This system initialization method refers to a non-existent class, so we should comment out the body line."

	<gtExample>
	^ '!DrGeoSystem class methodsFor: ''class initialization'' stamp: ''Install-DrGeoFrench 12/7/2022 16:16:08''!
initialize
	"Erudite extention for Dr. Geo"
	EruditeMarkupGrammar addCodeAction: ''withDrGeoActions''! !'
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
	self assert: (self dummyClasses reject: #isClass) isEmpty.
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
	| input patched |
	input := self patchBrokenCodeFile.
	patched := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patched.st'.
	patched ensureDelete.
	input copyTo: patched.
	^ patched
]

{ #category : #example }
DGCodeExamples >> dummyClasses [
	<gtExample>
	| dummies |
	dummies := self missingClasses
			collect: [ :eachClass | 
				eachClass
					asClassInEnvironment: Smalltalk globals
					ifAbsent: [ Object
							subclass: eachClass
							instanceVariableNames: ''
							classVariableNames: ''
							package: 'DrGeo'.
						eachClass asClass tagWith: 'Missing' ] ].
	self assert: (dummies reject: #isClass) isEmpty.
	^ dummies
]

{ #category : #example }
DGCodeExamples >> latestPatch [
	"A folder where we keep some past versions of the patched source code."

	<gtExample>
	self dummyClasses.
	^ self archive / 'DrGeo-patched-2024-04-12.st'
]

{ #category : #example }
DGCodeExamples >> missingClasses [
	<gtExample>
	^ #(ActiveModel LayoutMorph DebuggerWindow WizardPanel DialogPanel Panel BoxedMorph MorphDummy PreferenceType Debugger MorphicEruditeDocRenderer PreferenceBrowserVisitor Theme DarkTheme)
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
	| patchBackquotes input inputFile |
	"inputFile := self patchTabbedSymbolsFile."
	inputFile := self patchColorFile.
	patchBackquotes := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patchBackquotes.st'.
	patchBackquotes
		writeStreamDo: [ :aStream | 
			input := inputFile readStream.
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

{ #category : #utility }
DGCodeExamples >> patchBrokenClassMethodIn: aString [
	^ aString
		copyReplaceAll: 'subclass: t instanceVariableNames: f classVariableNames: d package: cat'
		with: 'xsubclass: t instanceVariableNames: f classVariableNames: d package: cat'
]

{ #category : #example }
DGCodeExamples >> patchBrokenCodeFile [
	"Patch a broken extension and initailization method.
	Also some broken class creation."

	<gtExample>
	| patchBrokenCode input inputFile |
	inputFile := self patchBackquotesFile.
	patchBrokenCode := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patchBrokenCode.st'.
	patchBrokenCode
		writeStreamDo: [ :aStream | 
			input := inputFile readStream.
			[ input atEnd ]
				whileFalse: [ | line |
					line := input nextLine.
					(line beginsWith: 'subclass:')
						ifTrue: [ line := self patchBrokenClassMethodIn: line ].
					(line includesSubstring: 'EruditeMarkupGrammar')
						ifTrue: [ line := self patchBrokenInitializationMethodIn: line ].
					(line includesSubstring: 'poolDictionaries')
						ifTrue: [ line := self patchBrokenPoolDictionariesIn: line ].
					aStream
						nextPutAll: line;
						lf ] ].
	^ patchBrokenCode
]

{ #category : #utility }
DGCodeExamples >> patchBrokenInitializationMethodIn: aString [
	^ aString
		copyReplaceAll: 'EruditeMarkupGrammar addCodeAction: ''withDrGeoActions'''
		with: '"EruditeMarkupGrammar addCodeAction: ''withDrGeoActions''"'
]

{ #category : #utility }
DGCodeExamples >> patchBrokenPoolDictionariesIn: aString [
	"nil should be an empty string"

	^ aString
		copyReplaceAll: 'poolDictionaries: ''nil'''
		with: 'poolDictionaries: '''''
]

{ #category : #example }
DGCodeExamples >> patchColorFile [
	"Remove the color slot from DrGeoMorph."

	<gtExample>
	| patchColor input inputFile |
	inputFile := self drGeoSrc.
	patchColor := DGCodeExamples new drGeoRepo / 'src/DrGeo-patchColor.st'.
	patchColor
		writeStreamDo: [ :aStream | 
			input := inputFile readStream.
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
		copyReplaceAll: self drGMorphSlots
		with: 'drawable mathItem style labelMorph'
]

{ #category : #example }
DGCodeExamples >> patchTabbedSymbolsFile [
	"Patch the tabbed symbols.
	NB: No longer needed -- the tabs have been removed in the source file."

	"<gtExample>"
	| patchTabbedSymbols input inputFile |
	inputFile := self patchColorFile.
	patchTabbedSymbols := DGCodeExamples new drGeoRepo
			/ 'src/DrGeo-patchTabbedSymbols.st'.
	patchTabbedSymbols
		writeStreamDo: [ :aStream | 
			input := inputFile readStream.
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

{ #category : #accessing }
DGCodeExamples >> removeFiledInCode [
	(Smalltalk packages select: [ :p | p name beginsWith: 'DrGeo-' ])
		do: [ :p | p removeFromSystem ].
	#DrGeo asPackage removeFromSystem
]
