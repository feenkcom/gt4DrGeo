Class {
	#name : #DrGTextMorph,
	#superclass : #DrGMorph,
	#instVars : [
		'textComposition',
		'extent'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGTextMorph >> compose: aStringOrText [
	textComposition		
		setModel: (TextModel withText: aStringOrText);
		composeAll.
	extent := textComposition usedExtent + 8
]

{ #category : #testing }
DrGTextMorph >> containsPoint: localPoint [
"We really want rectangle detection, more user friendly, otherwise it is pixel detecting on each character"
	^ self canBeDrawn 
		and: [self displayBounds 
			ifNil: [false] 
			ifNotNil: [:d | d containsPoint: self drawable morphPositionInWorld + localPoint ]]
		
]

{ #category : #accessing }
DrGTextMorph >> contents: aStringOrText [
	textComposition textComposed ~= aStringOrText ifTrue: [
		self compose: aStringOrText]
]

{ #category : #drawing }
DrGTextMorph >> drawFrame: rect on: aCanvas [
	aCanvas fillRectangle: (rect expandBy: 2)
		color: style backgroundColor 
		borderWidth: 2
		borderStyleSymbol: #simple 
		baseColorForBorder: style borderColor.
]

{ #category : #drawing }
DrGTextMorph >> drawOn: aCanvas [
	| r bound |
	self isDrawNeeded ifFalse: [^ self].
	self contents: mathItem text.
	r := self labelPosition extent: extent.
	self drawFrame: r on: aCanvas.
	bound := r insetBy: 4.
	aCanvas
		drawTextComposition: textComposition
		at: bound origin
		extent: bound extent
		color: color
		selectionColor: (Color red).
]

{ #category : #accessing }
DrGTextMorph >> fontSize: aSmallInteger [ 
	| text |
	textComposition editor: (TextEditor new defaultFont: (DrGeoSystem fontOfSize: aSmallInteger)).
	(text := textComposition textComposed) ifEmpty: [^ self].
	self compose: text.
	self redrawNeeded 
]

{ #category : #'initialize-release' }
DrGTextMorph >> initialize [
	super initialize.
	textComposition := TextComposition new.
	textComposition
		setModel: (TextModel withText: '');
		extentForComposing: 9999999@9999999;
		composeAll.
		
	" Taken from DrGTextMorph >> #compose: "
	extent := textComposition usedExtent + 8.
]

{ #category : #'testing type' }
DrGTextMorph >> isText [
	^ true
]

{ #category : #label }
DrGTextMorph >> labelMorph: aString [
"There is no label morph for text or value on the canvas"
]

{ #category : #label }
DrGTextMorph >> labelPosition [
	^self drawable worldToMorph: mathItem position
]

{ #category : #accessing }
DrGTextMorph >> styleClass [
	^ DrGTextStyle
]

{ #category : #'geometry testing' }
DrGTextMorph >> wantsContour [
	^ false
]
