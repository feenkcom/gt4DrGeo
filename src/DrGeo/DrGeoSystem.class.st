"
I map settings/preferences to the underneath hardware/os plateform
Pattern: strategy
"
Class {
	#name : #DrGeoSystem,
	#superclass : #Object,
	#classInstVars : [
		'platform'
	],
	#category : #'DrGeo-System'
}

{ #category : #'system startup' }
DrGeoSystem class >> addStartUp [
	Smalltalk addToStartUpList: self
]

{ #category : #path }
DrGeoSystem class >> backgroundsPath [
	^ platform backgroundsPath
]

{ #category : #'class initialization' }
DrGeoSystem class >> beDevelopment [
	"Be like the Cuis environment as the DrGeo development environment"
	"self beDevelopment"
	platform := DrGDevelopment new.
	self removeStartUp.
	platform startUp. "manual startUp for additional initialization occuring at system start up"
]

{ #category : #'class initialization' }
DrGeoSystem class >> beWorkstation [
	"self beWorkstation"
	platform := DrGWorkstation new.
	self addStartUp
]

{ #category : #testing }
DrGeoSystem class >> canWeDisplaySpinner [
	^ platform canWeDisplaySpinner
]

{ #category : #font }
DrGeoSystem class >> canvasFont [
	^ self fontOfSize: self canvasFontSize
]

{ #category : #font }
DrGeoSystem class >> canvasFontSize [
	^ platform canvasFontSize
]

{ #category : #install }
DrGeoSystem class >> cleanUp [
	"Smalltalk reduceCuis "
]

{ #category : #path }
DrGeoSystem class >> examplesPath [
	^ platform examplesPath
]

{ #category : #font }
DrGeoSystem class >> fontOfSize: anInteger [
	^ FontFamily defaultFamilyPointSize: (Theme current scale: anInteger)
]

{ #category : #path }
DrGeoSystem class >> iconsPath [
	^ platform iconsPath
]

{ #category : #testing }
DrGeoSystem class >> ifNotTablet: aBlock [
	^ self isTablet ifFalse: [aBlock value]
]

{ #category : #testing }
DrGeoSystem class >> ifNotiPad: aBlock [
	^ platform isiPad ifFalse: [aBlock value]
]

{ #category : #testing }
DrGeoSystem class >> ifTablet: aBlock [
	^ self isTablet ifTrue: [aBlock value]
]

{ #category : #'class initialization' }
DrGeoSystem class >> initialize [
	"Erudite extention for Dr. Geo"
	"EruditeMarkupGrammar addCodeAction: 'withDrGeoActions'"
]

{ #category : #install }
DrGeoSystem class >> install [
	| world |
	"Report by any mean installation and run time"
	Transcript
		showOnDisplay: false;
		logToFile: true;
		logToStdout: true.
	Smalltalk at: #LogStartupDebugAids put: true.
	'Installing updates...' print.
	ChangeSet installNewUpdates.
	Smalltalk condenseChanges.
	"Focus does not follow mouse, it is annoying when editing Smalltalk sketch"
	Preferences at: #focusFollowsMouse put: false.
	"Adjust font size"
	Preferences at: #defaultFontSize put: 12.
	'Font preferences set' print.
	"Preferences at: #logDebuggerStackToFile put: true."
	Preferences at: #autoNumberUserChanges put: false.
	"Set Locale and text domains"
	Preferences at: #useLocale put: true.
	TextDomainManager registerCategoryPrefix: 'DrGeo' domain: 'drgeo'.
	TextDomainManager registerCategoryPrefix: 'cuis' domain: 'cuis'.	
	"Set a default name for authoring"
	Utilities setAuthorName: 'Dr. Geo User' initials: 'drgeo'.

	'Finalizing installation...' print.
	world := UISupervisor ui.
[
	(Delay forSeconds: 1) wait.
	UISupervisor whenUIinSafeState: 	[
		"Adjust taskbar size"
		world showTaskbar 
		world taskbar scale: 1/2.
		'Task bar rescaled' print.
		Display fullScreenMode: true.
		"Be quiet"
		self cleanUp.
		self beWorkstation.
		"Remove all morphs"
		(world submorphs reject: [:aMorph | aMorph is: #TaskbarMorph]) 
			do: [:each | each delete].
		'Morphs deleted' print.
		Smalltalk garbageCollect.
		'Image cleaned' print.
		'Installation ended' print.
		'Saving image...' print.
		Smalltalk saveAndQuit ]
] fork

]

{ #category : #testing }
DrGeoSystem class >> isAndroid [
	^ platform isAndroid
]

{ #category : #testing }
DrGeoSystem class >> isSystem [
"Are we in the DrGeo development environment"
	^ platform isSystem
]

{ #category : #testing }
DrGeoSystem class >> isTablet [
	^ platform isAndroid or: [platform isiPad]
]

{ #category : #testing }
DrGeoSystem class >> isWorkstation [
"Are we workstation version of DrGeo"
	^ platform isWorkstation
]

{ #category : #testing }
DrGeoSystem class >> isiPad [
	^ platform isiPad
]

{ #category : #path }
DrGeoSystem class >> myExportsPath [
	^ platform myExportsPath
]

{ #category : #path }
DrGeoSystem class >> mySketchesPath [
"Access to the my Sketch files. There are descirption in XML of geometry sketches."
	^ platform mySketchesPath
]

{ #category : #path }
DrGeoSystem class >> mySmalltalkSketchesPath [
"Access to my Script files. There are Smalltalk scripts computing geometry sketches."
	^ platform mySmalltalkSketchesPath 
]

{ #category : #'user interface' }
DrGeoSystem class >> preferences [
	^ platform preferences 
]

{ #category : #'system startup' }
DrGeoSystem class >> removeStartUp [
"self removeStartUp"
	Smalltalk removeFromStartUpList: self
]

{ #category : #'class initialization' }
DrGeoSystem class >> reset [
	platform reset.
	DrGIcons reset.  "flush icons cach"
]

{ #category : #'user interface' }
DrGeoSystem class >> showVirtualKeyboard: boolean [
	platform ifNotNil: [
		platform showVirtualKeyboard: boolean]
]

{ #category : #path }
DrGeoSystem class >> smalltalkSketchesPath [
"Path to the Smalltalk sketches examples. There are written with Smalltalk code."
	^ platform smalltalkSketchesPath 
]

{ #category : #'user interface' }
DrGeoSystem class >> startSpinner [
	self canWeDisplaySpinner ifTrue: [WaitSpinner start]
]

{ #category : #'system startup' }
DrGeoSystem class >> startUp [
	Transcript show: '[DrGeo] Init startUp'; cr.
	platform startUp
	
]

{ #category : #'user interface' }
DrGeoSystem class >> stopSpinner [
	WaitSpinner stop
]

{ #category : #'user interface' }
DrGeoSystem class >> toggleFullscreen [
	platform toggleFullscreen 
]
