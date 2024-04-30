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
	sketch := DrGeoSketch new.
	self assert: sketch presenter class equals: DGSketchState.
	self assert: sketch state isEmpty.
	^ sketch
]

{ #category : #examples }
DGScriptExamples >> lineSketch [
	"From aMathItem"

	<gtExample>
	| sketch a b l |
	sketch := self emptySketch.

	a := sketch point: 88 @ 985.
	b := sketch point: 98 @ 1085.
	l := sketch line: a to: b.
	self assert: l mathItem isCurveItem.
	self assert: l mathItem isGeometricItem.
	self assert: l mathItem isDirectionItem.
	self assert: l mathItem isLineItem.	""
	self assert: (l mathItem contains: 89 @ 995).
	self assert: (l mathItem contains: 87 @ 975).
	self assert: (l mathItem contains: 188 @ 1985).
	self assert: (l mathItem contains: 5 @ 4) not.

	self assert: sketch state mathItems size equals: 3.


	^ sketch
]
