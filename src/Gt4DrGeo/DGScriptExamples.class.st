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
