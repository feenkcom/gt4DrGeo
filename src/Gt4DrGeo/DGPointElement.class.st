Class {
	#name : #DGPointElement,
	#superclass : #BlElement,
	#traits : 'TDGMathItemElement',
	#classTraits : 'TDGMathItemElement classTrait',
	#category : #'Gt4DrGeo-View'
}

{ #category : #accessing }
DGPointElement >> beFixed [
	self
		geometry: self crossGeometry;
		background: Color red;
		border: Color red;
		size: self defaultSize
]

{ #category : #accessing }
DGPointElement >> bePullable [
	self
		geometry: BlSquare new;
		size: self defaultSize;
		background: Color red;
		border: BlBorder empty;
		addEventHandler: (DGPointPullHandler for: self)
]

{ #category : #accessing }
DGPointElement >> crossGeometry [
	^ BrGlamorousVectorIcons
		crossGeometry: 0.1
		extent: 1 @ 1
		origin: 0 @ 0
]

{ #category : #accessing }
DGPointElement >> defaultSize [
	^ 10 @ 10
]

{ #category : #accessing }
DGPointElement >> idClass [
	^ DGPointElementId
]

{ #category : #accessing }
DGPointElement >> initialize [
	super initialize.
	"self
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]."
	self bePullable
]

{ #category : #accessing }
DGPointElement >> isDGPointElement [
	^ true
]

{ #category : #accessing }
DGPointElement >> offset [
	^ self extent / 2
]

{ #category : #accessing }
DGPointElement >> positionSummary [
	^ {'position' -> (self position + self offset).
		'math point' -> self mathItem point.
		'parent position'
			-> ((self parent globalPointToLocal: self position) + self offset).
		'parent parent position'
			-> ((self parent parent globalPointToLocal: self position) + self offset)}
		asDictionary
]

{ #category : #updating }
DGPointElement >> relocate [
	"Update my location to match my model item."

	^ self relocate: self mathItem point
]

{ #category : #accessing }
DGPointElement >> relocate: aPoint [
	"MI should relocate my center, not my bottom left corner."

	super relocate: aPoint - self offset
]
