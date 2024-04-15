Class {
	#name : #DrGBitmapMorph,
	#superclass : #DrGMorph,
	#instVars : [
		'previousScale',
		'previousMagnify',
		'paintResource'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #label }
DrGBitmapMorph >> constrainedLabelPosition: aVector [
	self computeLabelPositionDelta: aVector
	
]

{ #category : #accessing }
DrGBitmapMorph >> extent [
"defined by my paint, cannot change"
	self extent: paintResource getCheckedResource extent.
	^ bounds extent
]

{ #category : #accessing }
DrGBitmapMorph >> extent: aPoint [
"	| newExtent |
	newExtent := (self borderWidth * 2) asPoint + (aPoint * costume myScale) asIntegerPoint.
	(bounds extent closeTo: newExtent ) ifTrue: [ ^self ].
	self changed.
	bounds := (bounds topLeft extent: newExtent).
	self layoutChanged.
	self changed."
]

{ #category : #'initialize-release' }
DrGBitmapMorph >> initialize [ 
	super initialize.
	previousScale := mathItem insertAtScale.
	previousMagnify := mathItem magnifyBy.
	style color: Color black
]

{ #category : #accessing }
DrGBitmapMorph >> isAnyCornerIn: aPoint [
	"is aPoint belong to one of the corners of extent 24, if so return its symbole otherwise nil"
	((self location extent: 24@24) containsPoint: aPoint) ifTrue: [^#topLeft].
	((self topRight - (24@0) extent: 24@24) containsPoint: aPoint) ifTrue: [^#topRight].
	((self bottomRight -  24 extent: 24@24) containsPoint: aPoint) ifTrue: [^ #bottomRight].
	((self bottomLeft - (0@16) extent: 24@24) containsPoint: aPoint) ifTrue: [^ #bottomLeft].
	^ nil
]

{ #category : #'testing type' }
DrGBitmapMorph >> isBitmap [
	^ true
]

{ #category : #label }
DrGBitmapMorph >> labelPosition [
	^(self drawable worldToMorph: mathItem topCenter) + labelPositionDelta 
]

{ #category : #accessing }
DrGBitmapMorph >> myScale [
	^ self drawable scale * mathItem magnifiedScale
]

{ #category : #accessing }
DrGBitmapMorph >> paintResource: anAthensPaint [
	paintResource := anAthensPaint .
	self changed
]

{ #category : #drawing }
DrGBitmapMorph >> redraw [ 
	super redraw 
		ifFalse: [^self].
	self center: (self drawable worldToMorph: mathItem position).
]
