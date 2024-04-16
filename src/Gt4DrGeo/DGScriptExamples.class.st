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
	"Note that we depend on DrGeoSketch>>#initialize being replaced by a version that sends DGDrGeo gtService."

	<gtExample>
	| sketch |
	sketch := DrGeoSketch new.
	self assert: sketch presenter class equals: DGDrGeo.
	self assert: sketch drawable class equals: DGDrawable.
	self assert: sketch view class equals: DGMiniView.
	^ sketch
]
