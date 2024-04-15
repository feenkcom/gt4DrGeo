"
A preference type representing the different possible sizes of a point.
"
Class {
	#name : #DrGTypePointSize,
	#superclass : #PreferenceType,
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGTypePointSize class >> pointSizeFor: index [
	^ self pointSizeSymbols at: index
]

{ #category : #accessing }
DrGTypePointSize class >> pointSizeIndexOf: aSize [
	^ self pointSizeSymbols indexOf: aSize
]

{ #category : #accessing }
DrGTypePointSize class >> pointSizeSymbols [
	^ (#(#small #medium #large))
]

{ #category : #accessing }
DrGTypePointSize class >> sizeMorphCollection: aShape [
	^ self  pointSizeSymbols collect: [:symbol |
		ImageMorph new image: (DrGIcons point: symbol color: Color black shape: aShape)].

]

{ #category : #accessing }
DrGTypePointSize >> pointSizeIndex [
	^ self class pointSizeIndexOf: self value
]

{ #category : #accessing }
DrGTypePointSize >> pointSizeIndex: anIndex [
	self value: (self class pointSizeFor: anIndex).
	self changed: #pointSizeIndex:
]

{ #category : #accessing }
DrGTypePointSize >> sizeMorphCollection [
	^ self class sizeMorphCollection: #square
]
