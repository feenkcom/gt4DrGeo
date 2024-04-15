"
A preference type representing the different possible mark set over a segment.
"
Class {
	#name : #DrGTypeMark,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGTypeMark class >> markFor: index [
	^ self markSymbols at: index
]

{ #category : #accessing }
DrGTypeMark class >> markIndexOf: aMark [
	^ self markSymbols indexOf: aMark
]

{ #category : #accessing }
DrGTypeMark class >> markMorphCollection [
	^ self markSymbols collect: [:symbol |
		ImageMorph new 	image: (
			DrGIcons 	
				segment: (Theme current lineWidthFor: #small) 
				color: Color black mark: symbol 
		)]
]

{ #category : #accessing }
DrGTypeMark class >> markSymbols [
	^ #(#none #mark1 #mark2 #mark3 #disc #circle)
]

{ #category : #accessing }
DrGTypeMark >> markIndex [
	^ self class markIndexOf: self value
]

{ #category : #accessing }
DrGTypeMark >> markIndex: anIndex [
	self value: (self class markFor: anIndex).
	self changed: #markIndex:
]

{ #category : #accessing }
DrGTypeMark >> markMorphCollection [
	^ self class markMorphCollection 
]
