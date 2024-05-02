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
		addEventHandler: BlPullHandler new
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

{ #category : #'event handling' }
DGPointElement >> registerEvents [
	"NB: The SketchElements listens for #changed events."

	self
		when: BlDragEndEvent
		do: [ :anEvent | 
			anEvent consumed: true.
			self mathItem moveTo: self position.
			self mathItem changed ].
	self flag: #drgeoEvent
]

{ #category : #accessing }
DGPointElement >> relocate: aPoint [
	"MI should relocate my center, not my bottom left corner."

	super relocate: aPoint - self offset
]

{ #category : #accessing }
DGPointElement >> updateAllMathItems [
	self mySketchElement updateAllMathItems
]
