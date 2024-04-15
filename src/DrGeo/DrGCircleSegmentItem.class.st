Class {
	#name : #DrGCircleSegmentItem,
	#superclass : #DrGCircleRadiusItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #computing }
DrGCircleSegmentItem >> clone [
	|pointA clone segmentItem |
	pointA := DrGPointFreeItem newWith: {self center + (0.2@0.2)}.
	segmentItem := parents second.
	clone := DrGCircleSegmentItem newWith: {pointA . segmentItem}.
	^ {pointA . clone}
]

{ #category : #'xml writing' }
DrGCircleSegmentItem >> nodeType [
	^ #segment
]

{ #category : #updating }
DrGCircleSegmentItem >> update [
	self doParentsExist
		ifTrue: [center := parents first point.
			radius := parents second direction r]
]
