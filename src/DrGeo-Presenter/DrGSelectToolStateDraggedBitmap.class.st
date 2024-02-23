Class {
	#name : #DrGSelectToolStateDraggedBitmap,
	#superclass : #DrGSelectToolStateDragged,
	#instVars : [
		'isDraggingCorner',
		'draggedCorner',
		'corner',
		'originalMagnifyBy'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #accessing }
DrGSelectToolStateDraggedBitmap >> context: aContext [
	super context: aContext.
	draggedCorner := self context morph isAnyCornerIn: self context start.
]

{ #category : #handling }
DrGSelectToolStateDraggedBitmap >> handleMouseAt: aPoint [ 
	| processSomething |
	draggedCorner 
		ifNil: [processSomething := super handleMouseAt: aPoint]
		ifNotNil: [self magnifyBitmap: aPoint.
			processSomething := true].
	^ processSomething 

]

{ #category : #handling }
DrGSelectToolStateDraggedBitmap >> magnifyBitmap: aPoint [
	| displacement unitVector image factor griddedPoint |
	griddedPoint := self context gridPoint: aPoint.
	displacement := griddedPoint - self context start.
	image := self context morph morph.
	draggedCorner = #topLeft ifTrue: [
		corner ifNil: [corner := image position].
		[unitVector := (image center - corner) normalized] on: ZeroDivide do: [unitVector := 0@0]].
	draggedCorner =#bottomRight ifTrue: [
		corner ifNil: [corner := image position].
		[unitVector := (corner - image center) normalized] on: ZeroDivide do: [unitVector := 0@0]].
	draggedCorner = #topRight ifTrue: [
		corner ifNil: [corner := image topRight].
		[unitVector := (image center - corner) normalized] on: ZeroDivide do: [unitVector := 0@0]].
	draggedCorner = #bottomLeft ifTrue: [
		corner ifNil: [corner := image topRight].
		[unitVector := (corner - image center) normalized] on: ZeroDivide do: [unitVector := 0@0]].
	factor := (displacement dotProduct: unitVector) / (corner dist: image center).
	factor > 1 ifTrue: [factor := 0.9].
	originalMagnifyBy ifNil: [originalMagnifyBy := self context mathItem magnifyBy].
	self context mathItem magnifyBy: (1 - factor) * originalMagnifyBy.
	self context domain updateAllMathItems.
	self context last: griddedPoint.
]
