"
I am a contextual menu used when the user needs to select an items among several.
"
Class {
	#name : #DrGDrawableMenu,
	#superclass : #MenuMorph,
	#instVars : [
		'tool'
	],
	#category : #'DrGeo-View'
}

{ #category : #events }
DrGDrawableMenu >> initialize [
	super initialize.
	self color: (self color alpha: 0.8).
	self borderColor: (self borderColor alpha: 0.7).

]

{ #category : #events }
DrGDrawableMenu >> mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition [
	"click outside => step blinking the selected item "
	(stayUp or: [(self coversLocalPoint:localEventPosition) or: [selectedItem isNil]]) 
		ifFalse: [
			selectedItem arguments first first stopBlinking.
			tool reset].
	super mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition 
]

{ #category : #control }
DrGDrawableMenu >> selectItem: aMenuItem [ 
	selectedItem ifNotNil:[
		selectedItem arguments first first stopBlinking].
	aMenuItem ifNotNil:[
		aMenuItem arguments first first startBlinking].
	^ super selectItem: aMenuItem 
]

{ #category : #accessing }
DrGDrawableMenu >> tool: aDrGeoTool [
	tool := aDrGeoTool 
]
