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
	b := sketch point: 20@50.
	l := sketch line: a to: b.
	self assert: l isCurveItem.
	self assert: l isGeometricItem.
	self assert: l isDirectionItem.
	self assert: l isLineItem.
	self assert: (l contains: 10@20).
	self assert: (l contains: 20@50).
	self assert: (l contains: 15@35).
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
	sketch := self sketchWithPoint.
	mathPoint := sketch mathItems first.
	self assert: mathPoint isPointItem.
	self assert: mathPoint point equals: 10@20.
	^ mathPoint
]

{ #category : #examples }
DGScriptExamples >> sketchWithPoint [
	"From aMathItem"

	<gtExample>
	| sketch a |
	sketch := self emptySketch.
	a := sketch point: 10@ 20.

	self assert: sketch isEmpty not.
	self assert: sketch mathItems first equals: a.

	^ sketch
]
