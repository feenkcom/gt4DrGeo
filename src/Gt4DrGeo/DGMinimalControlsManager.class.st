"
I subclass DrGUIMinimalControlsManager for GT.

I am a minimal version of DrGUIControlsManager for scripted sketches.
- I hold the data and methods to build the UI
"
Class {
	#name : #DGMinimalControlsManager,
	#superclass : #DrGUIMinimalControlsManager,
	#category : #'Gt4DrGeo-View'
}

{ #category : #initialization }
DGMinimalControlsManager >> installTools [
	"Empty for now. We will slowly populate this ...
	NB: We do *not* do a `super initialize`!"

	view := DGMiniView for: presenter.
	
]
