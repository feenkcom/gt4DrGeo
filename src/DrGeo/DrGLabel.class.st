"
I am a label sticked arround a math object.
I can be dragged arround the objet and renammed from the Style tool.
- itemMorph is the view of a math Item I am attached too
- delta : my x@y delta to the reference point of the itemMorph I am attached to
"
Class {
	#name : #DrGLabel,
	#superclass : #LabelMorph,
	#instVars : [
		'blink',
		'itemMorph',
		'delta'
	],
	#category : #'DrGeo-View'
}

{ #category : #'new-morph participation' }
DrGLabel class >> includeInNewMorphMenu [
	^ false
]

{ #category : #editing }
DrGLabel >> acceptContents [
	itemMorph mathItem name: contents asString.
]

{ #category : #accessing }
DrGLabel >> delta [
	^ delta
]

{ #category : #accessing }
DrGLabel >> delta: aPoint [
	delta := aPoint
]

{ #category : #'event handling' }
DrGLabel >> handlesMouseDown: evt [
	^true
]

{ #category : #initialization }
DrGLabel >> initialize [
	super initialize.
	blink := false.
	delta := 7@7.
	self font: DrGeoSystem canvasFont

]

{ #category : #accessing }
DrGLabel >> morph: aDrGMorph [
	itemMorph := aDrGMorph
]

{ #category : #'event handling' }
DrGLabel >> mouseMove: evt localPosition: deltaVector [
	itemMorph 		ifNotNil: 
		["Inform the item about the new position we want in the drawable"
		itemMorph constrainedLabelPosition: self morphPosition + deltaVector.
		self morphPosition: itemMorph labelPosition].

]

{ #category : #'stepping and presenter' }
DrGLabel >> startBlinking [
	blink := true.
	self startStepping 
]

{ #category : #'stepping and presenter' }
DrGLabel >> step [
	blink ifFalse: [^self].
	super step.
	self color = DrGTypeColor blinkingColor 
		ifTrue: [self color: itemMorph style color]
		ifFalse: [self color: DrGTypeColor blinkingColor]
]

{ #category : #testing }
DrGLabel >> stepTime [
	^500
]

{ #category : #'stepping and presenter' }
DrGLabel >> stopBlinking [
	blink := false.
	self stopStepping.
]

{ #category : #'stepping and presenter' }
DrGLabel >> stopStepping [
	super stopStepping.
	self color: itemMorph style color.
]
