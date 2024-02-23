"
A regular polygon defined by its center, a vertex and a value (number of summit).
"
Class {
	#name : #DrGPolygonRegularItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #updating }
DrGPolygonRegularItem >> moveParent: aPoint [
"We only move center and the summit, not the value, number of summit."
	parents first moveEvent: aPoint.
	parents second moveEvent: aPoint.
	^ true
]

{ #category : #'xml writing' }
DrGPolygonRegularItem >> nodeType [
	^ #Regular
]

{ #category : #updating }
DrGPolygonRegularItem >> update [
|center pointA angle sides|
	self doParentsExist ifTrue: [
		center := parents first point.
		pointA := parents second point.
		sides := parents third valueItem rounded abs.
		sides < 3 ifTrue: [^ exist := false].
		angle := Float twoPi / sides.
		points := OrderedCollection new.
		sides timesRepeat: [			pointA := points add: (pointA rotateBy: angle about: center)].
		self computeLength]
]
