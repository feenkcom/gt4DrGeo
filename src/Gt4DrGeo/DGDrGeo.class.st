"
I subclass DrGeo for GT.

I am a presenter for the DrGeo app.
I ams the interface to callback, state of the application

- notInteractive: indicates if the app is under the user interaction or is used by the system (for example to load a sketch), in that case no user interaction are authorized.
- saved: is the sketch saved
- stSketch: if not nil DrGeo was initialized from a Smalltalk Sketch
"
Class {
	#name : #DGDrGeo,
	#superclass : #DrGeo,
	#category : #'Gt4DrGeo-Presenter'
}

{ #category : #'instance  creation' }
DGDrGeo class >> gtService [
"instanciate a DrGeo service, to embed in third party Morph. It is just the canvas without surrounding menu and icon"
	^ self basicNew
		initializeGtService;
		yourself
]

{ #category : #'initialize-release' }
DGDrGeo >> initializeGtService [
	self initializeBasic.
	self controlsManager: DGMinimalControlsManager.
	self move
]
