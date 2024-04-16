Class {
	#name : #DrGeo4GT,
	#superclass : #DrGeo,
	#category : #'Gt4DrGeo-Presenter'
}

{ #category : #'instance  creation' }
DrGeo4GT class >> gtService [
"instanciate a DrGeo service, to embed in third party Morph. It is just the canvas without surrounding menu and icon"
	^ self basicNew
		initializeGtService;
		yourself
]

{ #category : #'initialize-release' }
DrGeo4GT >> initializeGtService [
	self initializeBasic.
	self controlsManager: DrGeo4GTMinimalControlsManager.
	self move
]
