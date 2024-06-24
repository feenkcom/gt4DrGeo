"
These examples are derived from DrGeoScriptTest and DrGeoScriptTestResource.
"
Class {
	#name : #DGScriptExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #examples }
DGScriptExamples >> emptySketch [
	<gtExample>
	| sketch |
	sketch := DGSketch new.
	self assert: sketch isEmpty.
	^ sketch
]

{ #category : #accessing }
DGScriptExamples >> intersectionPoint [
	<gtExample>
	^ 12.5@12.5
]

{ #category : #accessing }
DGScriptExamples >> intersectionSketch [
	<gtExample>
	|sketch line intersectLine correctIntersectionPoint actualIntersectionPoint|
	sketch := self lineSketch.
	line := sketch mathItems third.
	intersectLine := self lineToIntersect.
	correctIntersectionPoint := self intersectionPoint.
	actualIntersectionPoint := (sketch intersectionOf: line and: intersectLine) point.
	
	self assert: actualIntersectionPoint equals: correctIntersectionPoint.
	
	^ sketch
	
]

{ #category : #examples }
DGScriptExamples >> lineSketch [
	"From DrGeoScriptTest>>#testLine"

	<gtExample>
	| sketch a b l |
	sketch := self pointSketch.
	a := sketch mathItems first.
	b := sketch point: self pointB.
	l := sketch line: a to: b.
	self assert: l isCurveItem.
	self assert: l isGeometricItem.
	self assert: l isDirectionItem.
	self assert: l isLineItem.
	self assert: (l contains: self pointA).
	self assert: (l contains: self pointB).
	self assert: (l contains:  self pointBetweenAB).
	self assert: (l contains: 5 @ 4) not.
	self assert: sketch mathItems size equals: 3.
	^ sketch
]

{ #category : #accessing }
DGScriptExamples >> lineToIntersect [
	<gtExample>
	|sketch a b line|
	sketch := self emptySketch.
	a := sketch point: self pointIntersectA.
	b := sketch point: self pointIntersectB.
	line := sketch line: a to: b.
	^ line 
]

{ #category : #examples }
DGScriptExamples >> mathLine [
	"From DrGeoScriptTest>>#testLine"

	<gtExample>
	| sketch line |
	sketch := self lineSketch.
	line := sketch mathItems third.
	self assert: line isLineItem.
	^ line
]

{ #category : #examples }
DGScriptExamples >> mathPoint [
	"From aMathItem"

	<gtExample>
	| sketch mathPoint |
	sketch := self pointSketch.
	mathPoint := sketch mathItems first.
	self assert: mathPoint isPointItem.
	self assert: mathPoint point equals: self pointA.
	^ mathPoint
]

{ #category : #accessing }
DGScriptExamples >> midPointSketch [
	"A sketch with a middle point on a line"
	
	<gtExample>
	|sketch line midPoint|
	sketch := self lineSketch.
	line := sketch mathItems third.
	midPoint := sketch middleOf: line.
	self assert: midPoint isPointItem.
	self assert: midPoint point equals: self pointBetweenAB.
	self assert: midPoint parents first equals: line.
	^ self
]

{ #category : #accessing }
DGScriptExamples >> pointA [
	<gtExample>
	^ 30@20
]

{ #category : #accessing }
DGScriptExamples >> pointB [
	<gtExample>
	^ 100@50
]

{ #category : #accessing }
DGScriptExamples >> pointBetweenAB [
	<gtExample>
	^ 65@35
]

{ #category : #accessing }
DGScriptExamples >> pointIntersectA [
	<gtExample>
	^ 20@30
]

{ #category : #accessing }
DGScriptExamples >> pointIntersectB [
	<gtExample>
	^ 50@100
]

{ #category : #examples }
DGScriptExamples >> pointSketch [
	"A sketch with just one point."

	<gtExample>
	| sketch a |
	sketch := self emptySketch.
	a := sketch point: self pointA.

	self assert: sketch isEmpty not.
	self assert: sketch mathItems first equals: a.

	^ sketch
]
