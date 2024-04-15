"
A preference type representing the different possible thickness of a line.
"
Class {
	#name : #DrGTypeThickness,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGTypeThickness class >> thicknessFor: index [
	^ self thicknessSymbols at: index
]

{ #category : #accessing }
DrGTypeThickness class >> thicknessIndexOf: thickness [
	^ self thicknessSymbols indexOf: thickness
]

{ #category : #accessing }
DrGTypeThickness class >> thicknessMorphCollection [
	^ self thicknessSymbols collect: [:symbol | 		
		ImageMorph new 
			image: (DrGIcons 		segment: (Theme current lineWidthFor: symbol)			color: Color black			dash: nil)]
]

{ #category : #accessing }
DrGTypeThickness class >> thicknessSymbols [
	^ (#(#small #medium #large))
]

{ #category : #accessing }
DrGTypeThickness >> thicknessIndex [
	^ self class thicknessIndexOf: self value
]

{ #category : #accessing }
DrGTypeThickness >> thicknessIndex: anIndex [
	self value: (self class thicknessFor: anIndex).
	self changed: #thicknessIndex:
]

{ #category : #accessing }
DrGTypeThickness >> thicknessMorphCollection [
	^ self class thicknessMorphCollection 
]
