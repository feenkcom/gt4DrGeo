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
	sketch := self sketchWithPoint.
	a := sketch mathItems first.
	b := sketch point: 98 @ 1085.
	l := sketch line: a to: b.
	self assert: l isCurveItem.
	self assert: l isGeometricItem.
	self assert: l isDirectionItem.
	self assert: l isLineItem.
	self assert: (l contains: 89 @ 995).
	self assert: (l contains: 87 @ 975).
	self assert: (l contains: 188 @ 1985).
	self assert: (l contains: 5 @ 4) not.
	self assert: sketch mathItems size equals: 3.
	^ sketch
]

{ #category : #examples }
DGScriptExamples >> sketchWithPoint [
	"From aMathItem"

	<gtExample>
	| sketch a |
	sketch := self emptySketch.
	a := sketch point: 88 @ 985.

	self assert: sketch isEmpty not.
	self assert: sketch mathItems first equals: a.

	^ sketch
]
