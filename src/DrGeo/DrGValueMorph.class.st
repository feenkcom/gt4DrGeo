Class {
	#name : #DrGValueMorph,
	#superclass : #DrGTextMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #label }
DrGValueMorph >> constrainedLabelPosition: aVector [
	^ aVector
]

{ #category : #drawing }
DrGValueMorph >> drawOn: aCanvas [
	| r bound |
	self isDrawNeeded ifFalse: [^ self].
	(mathItem name isNil or: [mathItem name isEmpty])
		ifTrue: [
			(mathItem valueItem is: #Text)
				ifTrue: [self contents: mathItem valueItem]
				ifFalse: [self contents: self roundedValueString]]
		ifFalse: [self contents: mathItem name , ' = ' , self roundedValueString].
	r := self labelPosition extent: extent.
	self drawFrame: r on: aCanvas .
	bound := r insetBy: 4.
	aCanvas
		drawTextComposition: textComposition
		at: bound origin
		extent: bound extent
		color: color
		selectionColor: (Color red).
]

{ #category : #'testing type' }
DrGValueMorph >> isValue [
	^ true
]

{ #category : #accessing }
DrGValueMorph >> roundedValueString [
	^ (mathItem valueItem isPoint or: [mathItem valueItem isNumber])
		ifTrue: [
			mathItem valueItem isFraction 
				ifTrue: [mathItem valueItem printString] 
				ifFalse: [mathItem valueItem printShowingDecimalPlaces: (DrGeoSystem preferences at: #valueDecimal)]]
		ifFalse: [mathItem valueItem asString]
]

{ #category : #accessing }
DrGValueMorph >> styleClass [
	^DrGValueStyle
]

{ #category : #accessing }
DrGValueMorph >> valueString [
	^mathItem valueItem asString
]
