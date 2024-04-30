"
I replace the ""presenter"" in the old DrGeo design, and just hold the state of a Sketch.
"
Class {
	#name : #DGSketchState,
	#superclass : #Object,
	#instVars : [
		'mathItems'
	],
	#category : #'Gt4DrGeo-Model'
}

{ #category : #accessing }
DGSketchState >> addItem: aMathItem [
	self mathItems addLast: aMathItem
]

{ #category : #initialization }
DGSketchState >> initialize [
	mathItems := OrderedCollection new
]

{ #category : #testing }
DGSketchState >> isEmpty [
	^ self mathItems isEmpty
]

{ #category : #accessing }
DGSketchState >> mathItems [
	^ mathItems
]

{ #category : #accessing }
DGSketchState >> mathItems: anObject [
	mathItems := anObject
]
