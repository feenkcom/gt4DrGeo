"
I subclass DrGDrawable for GT.

I represent the area/place where a Drgeo figure is drawn. It is a subpart of the GeometricView
- valueItem, dottedLines: we can display dotted line between a selected value and its parents
- itemViews, undoneViews, lastView: represent my submorph who are item's morphs
"
Class {
	#name : #DGDrawable,
	#superclass : #DrGDrawable,
	#category : #'Gt4DrGeo-View'
}

{ #category : #initalization }
DGDrawable >> initialize [
	itemViews := OrderedCollection new.
	undoneViews := OrderedCollection new.
]
