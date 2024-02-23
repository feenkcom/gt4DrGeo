"
A preference type representing the different possible shapes of a point.
"
Class {
	#name : #DrGTypePointShape,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Styles'
}

{ #category : #accessing }
DrGTypePointShape class >> pointShapeFor: index [
	^ self pointShapeSymbols at: index
]

{ #category : #accessing }
DrGTypePointShape class >> pointShapeIndexOf: pointShape [
	^ self pointShapeSymbols indexOf: pointShape
]

{ #category : #accessing }
DrGTypePointShape class >> pointShapeSymbols [
	^ #(#cross #round #square)
]

{ #category : #accessing }
DrGTypePointShape class >> shapeMorphCollection [
	^ self pointShapeSymbols collect: [:symbol |
		ImageMorph new 
			image: (DrGIcons 	point: (DrGTypePointSize pointExtentFor: #medium) 
			color: Color black 	shape: symbol) ].

]

{ #category : #accessing }
DrGTypePointShape >> pointShapeIndex [
	^ self class pointShapeIndexOf: self value
]

{ #category : #accessing }
DrGTypePointShape >> pointShapeIndex: anIndex [
	self value: (self class pointShapeFor: anIndex).
	self changed: #pointShapeIndex:
]

{ #category : #accessing }
DrGTypePointShape >> shapeMorphCollection [
	^ self class shapeMorphCollection 
]
