Class {
	#name : #DGCodeExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #accessing }
DGCodeExamples >> cloneDrGeo [
	| drGeoRepo repo |
	drGeoRepo := 'DrGeo' asFileReference.
	drGeoRepo ensureDeleteAll.
	repo := 'git@github.com:hilaire/drgeo.git'.
	IceRepositoryCreator fromUrl: repo to: drGeoRepo.
	drGeoRepo
]

{ #category : #accessing }
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

{ #category : #accessing }
DGCodeExamples >> drGMorphSlots [
	<gtExample>
	^ 'drawable mathItem color style labelMorph'
]

{ #category : #accessing }
DGCodeExamples >> drGeoRepo [
	<gtExample>
	| drGeoRepo |
	drGeoRepo := 'DrGeo' asFileReference.
	drGeoRepo exists ifFalse: [ self cloneDrGeo ].
	^ drGeoRepo
]

{ #category : #accessing }
DGCodeExamples >> drGeoSrc [
	<gtExample>
	^ self drGeoRepo / 'src/DrGeo.pck.st'
]

{ #category : #accessing }
DGCodeExamples >> drGeoSrcPatched [
	"Applies the sequence of patches."

	<gtExample>
	^ self patchColor
]

{ #category : #accessing }
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

{ #category : #accessing }
DGCodeExamples >> missingClasses [
	<gtExample>
	^ #(ActiveModel LayoutMorph DebuggerWindow WizardPanel DialogPanel Panel BoxedMorph MorphDummy PreferenceType Debugger MorphicEruditeDocRenderer PreferenceBrowserVisitor)
]

{ #category : #accessing }
DGCodeExamples >> patchColor [
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

{ #category : #accessing }
DGCodeExamples >> patchColorIn: aString [
	"NB: The initial test brings a 10x speedup."

	(aString includesSubstring: self drGMorphSlots) ifFalse: [ ^ aString ].
	^ aString
		copyWithRegex: self drGMorphSlots
		matchesReplacedWith: 'drawable mathItem style labelMorph'
]

{ #category : #accessing }
DGCodeExamples >> patchDrGMorphColorSlot [
	"Definition of DrGMorph has a duplicate color slot."

	<gtExample>
	| sourceString patchedString |
	sourceString := self drGMorphColorSlot.
	self assert: (sourceString includesSubstring: self drGMorphSlots).
	patchedString := self patchColorIn: sourceString.
	self assert: (patchedString includesSubstring: self drGMorphSlots) not.
	^ patchedString
]

{ #category : #accessing }
DGCodeExamples >> removeDrGeoPackages [
	"remove all the filed-in stuff"

	(RPackageOrganizer default packages
		select: [ :p | p name beginsWith: 'DrGeo-' ]) do: #removeFromSystem
]

{ #category : #accessing }
DGCodeExamples >> tabbedSymbols [
	"This code in the source file has tabs after the # in symbols."

	<gtExample>
	^ '	^{
		{''Restart'' translated . #		restart	 . 		''Restart the step by step execution from its start.'' translated } .
		{''Step''	 translated . 	#	doStep .			 ''Execute the current message and go to the next message.'' translated } .
		{''Step into''		 translated . #stepIntoBlock		 . ''Step into a block.'' translated } .
		{''Run to Cursor'' translated . #		runToCursor	 . 	''Execute the code up to the cursor position.'' translated }
	}! !
'
]
