Extension { #name : #DrGeo }

{ #category : #'*Gt4DrGeo' }
DrGeo class >> gtService [
"instanciate a DrGeo service, to embed in third party Morph. It is just the canvas without surrounding menu and icon"
	^ self basicNew
		initializeGtService;
		yourself
]

{ #category : #'*Gt4DrGeo' }
DrGeo >> initializeGtService [
	self initializeBasic.
	self controlsManager: DrGUIMinimalControlsManager.
	self move.
]
