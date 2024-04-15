"
A preference type representing the different possible style of a line.
"
Class {
	#name : #DrGTypeStyle,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGTypeStyle class >> styleFor: index [
	^ self styleSymbols at: index

]

{ #category : #accessing }
DrGTypeStyle class >> styleIndexOf: aLineStyle [
	^ self styleSymbols indexOf: aLineStyle
]

{ #category : #accessing }
DrGTypeStyle class >> styleMorphCollection [
	^ self styleSymbols collect: [:symbol |
		ImageMorph new image: (
			DrGIcons 
				segment: (Theme current lineWidthFor: #small) 
				color: Color black dash: (Theme current lineStyleDataFor: symbol)
		)]
]

{ #category : #accessing }
DrGTypeStyle class >> styleSymbols [
	^ #(#dot #dash #plain) 
]

{ #category : #accessing }
DrGTypeStyle >> styleIndex [
	^ self class styleIndexOf: self value
]

{ #category : #accessing }
DrGTypeStyle >> styleIndex: anIndex [
	self value: (self class styleFor: anIndex).
	self changed: #styleIndex:
]

{ #category : #accessing }
DrGTypeStyle >> styleMorphCollection [
	^ self class styleMorphCollection 
]
