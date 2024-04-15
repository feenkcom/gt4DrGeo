"
A preference type representing the different possible colors of an item in a sketch.
"
Class {
	#name : #DrGTypeColor,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGTypeColor class >> blinkingColor [
	^Color lightGray lighter lighter
]

{ #category : #accessing }
DrGTypeColor class >> colorFor: index [
	^ Color perform: (self colorSymbols at: index)
]

{ #category : #accessing }
DrGTypeColor class >> colorIndexOf: aColor [
	^self colors indexOf: (aColor alpha: 1)
]

{ #category : #accessing }
DrGTypeColor class >> colorMorphCollection [
	^ self colors collect: [:aColor |
		ImageMorph new image: (DrGIcons colorForm: aColor )]
]

{ #category : #accessing }
DrGTypeColor class >> colorSymbols [
	^#(#black #blue #brown #green #magenta #orange #red #yellow #white)
]

{ #category : #accessing }
DrGTypeColor class >> colors [
	^ self colorSymbols collect: [:symbol | Color perform: symbol]
]

{ #category : #accessing }
DrGTypeColor class >> hiddenColor [
	^Color lightGray lighter lighter lighter
]

{ #category : #accessing }
DrGTypeColor >> colorIndex [
	^ self class colorIndexOf: self value
]

{ #category : #accessing }
DrGTypeColor >> colorIndex: index [
	self value: (self class colorFor: index).
	self changed: #colorIndex:
]

{ #category : #accessing }
DrGTypeColor >> colorMorphCollection [
	^ self class colorMorphCollection
]
