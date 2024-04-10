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
	<gtExample>
	^ self drGeoSrc
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
	patchColor := DGCodeExamples new drGeoRepo / 'src/DrGeo-patch1.st'.
	patchColor
		writeStreamDo: [ :aStream | 
			input := DGCodeExamples new drGeoSrc readStream.
			[ input atEnd ]
				whileFalse: [ | line |
					line := input nextLine.
					(line includesSubstring: 'drawable mathItem color style labelMorph')
						ifTrue: [ line := line
									copyWithRegex: 'drawable mathItem color style labelMorph'
									matchesReplacedWith: 'drawable mathItem style labelMorph' ].
					aStream
						nextPutAll: line;
						lf ] ].
	^ patchColor
]

{ #category : #accessing }
DGCodeExamples >> removeDrGeoPackages [
	"remove all the filed-in stuff"

	(RPackageOrganizer default packages
		select: [ :p | p name beginsWith: 'DrGeo-' ]) do: #removeFromSystem
]
