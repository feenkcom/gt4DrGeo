Class {
	#name : #DrGPolygonMorph,
	#superclass : #DrGPolylineMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #label }
DrGPolygonMorph >> constrainedLabelPosition: aPoint [
|center vector answer|
	answer := mathItem closestPointInfoTo: (self drawable morphToWorld: aPoint).
	center := answer first.
	anchorAbscissa := answer second.
	center := self drawable worldToMorph: center.
	vector := aPoint - center.
	self computeLabelPositionDelta: vector.

]

{ #category : #testing }
DrGPolygonMorph >> containsPoint: localPoint [
	^ self containsPointInWorld: localPoint
]

{ #category : #accessing }
DrGPolygonMorph >> getVertices [
	vertices := mathItem points collect: [:point | self drawable worldToMorph: point].
	vertices add: vertices first

]

{ #category : #initialization }
DrGPolygonMorph >> initialize [
	super initialize.
	self makeClosed.
]

{ #category : #accessing }
DrGPolygonMorph >> styleClass [
	^DrGPolygonStyle 
]
