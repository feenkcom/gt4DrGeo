"
This tool is designed for touch screen, to construct line with sliding finger
"
Class {
	#name : #DrGFlyBuildTouchTool,
	#superclass : #DrGFlyBuildTool,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #'initialize-release' }
DrGFlyBuildTouchTool >> initialize [ 
	super initialize.
	self switchState: DrGFlyBuildTouchToolState.
]
