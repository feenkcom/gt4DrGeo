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
