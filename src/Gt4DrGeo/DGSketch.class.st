"
I am a subclass of DrGeoSketch that does not depend on morphs at all.
Instead of creating math items that sit inside views, they are completely independent, and communicate with Bloc views using MVC.
"
Class {
	#name : #DGSketch,
	#superclass : #DrGeoSketch,
	#instVars : [
		'mathItems'
	],
	#category : #'Gt4DrGeo-Model'
}

{ #category : #point }
DGSketch >> addItem: aMathItem [
	self mathItems addLast: aMathItem
]

{ #category : #point }
DGSketch >> finalizePoint: aPointItem [
	self addItem: aPointItem.
	^ aPointItem
]

{ #category : #initalization }
DGSketch >> initialize [
	mathItems := OrderedCollection new
]

{ #category : #accessing }
DGSketch >> isEmpty [
	^ self mathItems isEmpty
]

{ #category : #accessing }
DGSketch >> mathItems [
	^ mathItems
]

{ #category : #accessing }
DGSketch >> mathItems: anObject [
	mathItems := anObject
]
