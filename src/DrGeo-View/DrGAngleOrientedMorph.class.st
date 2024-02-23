Class {
	#name : #DrGAngleOrientedMorph,
	#superclass : #DrGAngleGeometricMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #drawing }
DrGAngleOrientedMorph >> canComputeArcData [
	|parents |
	parents := mathItem parents.
	center := parents second point.
	vector1 := parents first point - center.
	vector2 := parents third point - center.
	(vector1 = (0@0) or: [vector2 = (0@0)]) ifTrue: [^false].
	origin := vector1 y asFloat arcTan: vector1 x.
	(length := mathItem radianAngle) < 0 ifTrue: [ length := length + Float twoPi].
	^ true
]
