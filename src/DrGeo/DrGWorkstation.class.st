"
Preferences for workstation (Linux, Mac, Windows)
"
Class {
	#name : #DrGWorkstation,
	#superclass : #DrGPlatform,
	#category : #'DrGeo-System'
}

{ #category : #'initialize-release' }
DrGWorkstation >> checkForPaths [
	super checkForPaths.
	self myExportsPath assureExistence 
]

{ #category : #'initialize-release' }
DrGWorkstation >> initialize [
	self initFontManager.
	canWeDisplaySpinner := true.
	Preferences 
		at: #worldMenu put: DrGeo;
		at: #fullScreenLeavesDeskMargins put: false.
	UISupervisor ui taskbar scale: 1/2.
]

{ #category : #testing }
DrGWorkstation >> isWorkstation [
	^ true
]

{ #category : #path }
DrGWorkstation >> rootPath [
" 	Test purpose, point to the bundle "
"	^ DirectoryEntry smalltalkImageDirectory / 'drgeo' / 'build' / 'bundles' / 'gnulinux' / 'DrGeo'"
	^ super rootPath
]

{ #category : #'initialize-release' }
DrGWorkstation >> startUp [
	super startUp.
	Utilities setAuthorName: 'DrGeoUser' initials: 'drgeo'.
	self splash.
	Transcript show: '[DrGeo] Splash done'; cr.
]
