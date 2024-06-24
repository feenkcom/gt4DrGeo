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
	|  ax ay bx by cx cy dx dy slopeAB slopeCD y0AB y0CD x y |
	ax := self pointA x.
	ay := self pointA y.
	bx := self pointB x.
	by := self pointB y.
	cx := self pointC x.
	cy := self pointC y.
	dx := self pointD x.
	dy := self pointD y.
	
	slopeAB := (by - ay)/(bx - ax).
	slopeCD := (dy - cy)/(dx - cx).
	
	y0AB := ay - (ax * slopeAB).
	y0CD := cy - (cx * slopeCD).
	
	x := (y0CD - y0AB) / (slopeAB - slopeCD).
	y := y0AB + (x * slopeAB).
	"Double check that we have found the intersection point."
	self assert: y0AB + (x * slopeAB) equals: y0CD + (x * slopeCD).
	
	^ x@y
]

{ #category : #accessing }
DGScriptExamples >> intersectionSketch [
	"Testing intersection between two lines."
	<gtExample>
	|sketch a b c d line1 line2 correctIntersectionPoint actualIntersectionPoint|
	sketch := self emptySketch.
	a := sketch point: self pointA.
	b := sketch point: self pointB.
	c := sketch point: self pointC.
	d := sketch point: self pointD.
	line1 := sketch line: a to: b.
	line2 := sketch line: c to: d.
	correctIntersectionPoint := self intersectionPoint.
	actualIntersectionPoint := (sketch intersectionOf: line1 and: line2) point.
	
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
	^ sketch
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
DGScriptExamples >> pointC [
	<gtExample>
	^ 20@30
]

{ #category : #accessing }
DGScriptExamples >> pointD [
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
