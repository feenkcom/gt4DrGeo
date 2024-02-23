"
A preference type representing the different possible arrow set over a segment or arc.
"
Class {
	#name : #DrGTypeArrow,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Styles'
}

{ #category : #accessing }
DrGTypeArrow class >> arrowFor: index [
	^ self arrowSymbols at: index
]

{ #category : #accessing }
DrGTypeArrow class >> arrowIndexOf: aSymbol [
	^ self arrowSymbols indexOf: aSymbol
]

{ #category : #accessing }
DrGTypeArrow class >> arrowMorphCollection [
	^ self arrowSymbols collect: [:symbol |
		ImageMorph new image: (
			DrGIcons 
				segment: (DrGTypeThickness widthFor: #small) 
				color: Color black
				dash: (DrGTypeStyle styleDataFor: #plain)
				arrow: symbol
		)]
]

{ #category : #accessing }
DrGTypeArrow class >> arrowSymbols [
	^ #(#none #back #forward #both) 
]

{ #category : #accessing }
DrGTypeArrow >> arrowIndex [
	^ self class arrowIndexOf: self value
]

{ #category : #accessing }
DrGTypeArrow >> arrowIndex: anIndex [
	self value: (self class arrowFor: anIndex).
	self changed: #arrowIndex:
]

{ #category : #accessing }
DrGTypeArrow >> arrowMorphCollection [
	^ self class arrowMorphCollection 
]
