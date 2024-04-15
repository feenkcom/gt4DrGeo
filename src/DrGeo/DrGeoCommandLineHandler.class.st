"
Command line handler for Dr. Geo operations.

Usage: drgeo [ --sketch=<drgeo-file> ] [ --script=<drgeo-script> ]
	--sketch    Open a Dr. Geo sketch
	--script    Install a Dr. Geo Smalltalk script in a workspace and execute it

Example:
pharo drgeo.image drgeo --sketch=sketch.fgeo
"
Class {
	#name : #DrGeoCommandLineHandler,
	#superclass : #Object,
	#category : #'DrGeo-File'
}

{ #category : #accessing }
DrGeoCommandLineHandler class >> commandName [
	^ 'drgeo'
]

{ #category : #accessing }
DrGeoCommandLineHandler class >> description [
	^ 'Command line for Dr. Geo'
]

{ #category : #accessing }
DrGeoCommandLineHandler class >> priority [
"	^ STCommandLineHandler priority + 1"
]

{ #category : #'as yet unclassified' }
DrGeoCommandLineHandler >> activate [
	self activateHelp ifTrue: [ ^ self].
	(self hasOption: 'sketch') ifTrue: [ ^ self loadSketch: (self optionAt: 'sketch')].
	(self hasOption: 'script') ifTrue: [ ^ self loadScript: (self optionAt: 'script')].
	self printHelp.
	self exitFailure: 'Wrong arguments'.
]

{ #category : #'as yet unclassified' }
DrGeoCommandLineHandler >> checkForFile: aString [
	aString asFileReference exists
		ifFalse: [ ^ self exitFailure: aString, ' does not exist!' ]
]

{ #category : #'as yet unclassified' }
DrGeoCommandLineHandler >> loadScript: aString [
"	| workspace utfString |
	utfString := aString convertFromWithConverter: UTF8TextConverter new.
	self checkForFile: utfString.
	workspace :=  Workspace openContents: utfString asFileReference contents.
	workspace containingWindow fullscreen.
	Smalltalk compiler evaluate: workspace contents"
]

{ #category : #'as yet unclassified' }
DrGeoCommandLineHandler >> loadSketch: aString [
"	| utfString |
	utfString := aString convertFromWithConverter: UTF8TextConverter new.
	self checkForFile: utfString.
	DrGeo fileFullscreen: utfString"
]
