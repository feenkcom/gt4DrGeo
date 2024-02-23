Class {
	#name : #DrGCircleRadiusItem,
	#superclass : #DrGCircleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGCircleRadiusItem >> clone [
	|pointA clone radiusItem |
	pointA := DrGPointFreeItem newWith: {self center + (0.2@0.2)}.
	radiusItem := parents second.
	clone := DrGCircleRadiusItem newWith: {pointA . radiusItem}.
	^ {pointA . clone}
]

{ #category : #updating }
DrGCircleRadiusItem >> moveParent: aPoint [ 
	| thePoint |
	(parents
			noneSatisfy: [:item | item isValueItem or: [item isSegmentItem]])
		ifTrue: [^ super moveParent: aPoint].
	"we just want to move the center point, not the radius value"
	thePoint := parents first.
	thePoint moveEvent: aPoint.
	^ true
]

{ #category : #'xml writing' }
DrGCircleRadiusItem >> nodeType [
	^ #radius
]

{ #category : #updating }
DrGCircleRadiusItem >> update [
	self doParentsExist
		ifTrue: [center := parents first point.
			radius := parents second valueItem abs].
]
