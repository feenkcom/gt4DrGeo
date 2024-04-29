"
These examples are derived from DrGeoScriptTest and DrGeoScriptTestResource.
"
Class {
	#name : #DGScriptExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #accessing }
DGScriptExamples >> sketch [
	<gtExample>
	| sketch |
	sketch := DrGeoSketch new.
	self assert: sketch presenter isNil.
	^ sketch
]
