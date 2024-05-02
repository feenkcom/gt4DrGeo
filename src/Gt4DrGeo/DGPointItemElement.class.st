Class {
	#name : #DGPointItemElement,
	#superclass : #BlElement,
	#traits : 'TDGMathItemElement',
	#classTraits : 'TDGMathItemElement classTrait',
	#category : #'Gt4DrGeo-View'
}

{ #category : #accessing }
DGPointItemElement >> beFixed [
	self
		geometry: self crossGeometry;
		background: Color red;
		border: Color red;
		size: self defaultSize
]

{ #category : #accessing }
DGPointItemElement >> bePullable [
	self
		geometry: BlSquare new;
		size: self defaultSize;
		background: Color red;
		border: BlBorder empty;
		addEventHandler: BlPullHandler new
]

{ #category : #accessing }
DGPointItemElement >> crossGeometry [
	^ BrGlamorousVectorIcons
		crossGeometry: 0.1
		extent: 1 @ 1
		origin: 0 @ 0
]

{ #category : #accessing }
DGPointItemElement >> defaultSize [
	^ 10 @ 10
]

{ #category : #accessing }
DGPointItemElement >> initialize [
	super initialize.
	self bePullable
]

{ #category : #accessing }
DGPointItemElement >> offset [
	^ self extent / 2
]

{ #category : #'event handling' }
DGPointItemElement >> registerEvents [
	"should also listen for deletedMathItem"
	self mathItem
		ifNotNil: [ self mathItem
				when: #updateMyView
				send: #updateAllMathItems
				to: self ].
	self
		when: BlDragEndEvent
		do: [ :anEvent | 
			anEvent consumed: true.
			self mathItem moveTo: self position ].
	self flag: #drgeoEvent
]

{ #category : #accessing }
DGPointItemElement >> relocate: aPoint [
	"MI should relocate my center, not my bottom left corner."

	super relocate: aPoint - self offset
]

{ #category : #accessing }
DGPointItemElement >> updateAllMathItems [
	self mySketchElement updateAllMathItems
]
