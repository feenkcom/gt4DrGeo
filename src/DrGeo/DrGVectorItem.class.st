Class {
	#name : #DrGVectorItem,
	#superclass : #DrGSegmentItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGVectorItem >> adaptiveDescriptiveName [
	^ 'This vector %1' translated
]

{ #category : #accessing }
DrGVectorItem >> basicType [
	^#vector
]

{ #category : #computing }
DrGVectorItem >> clone [
	|pointA pointB clone|
	pointA := DrGPointFreeItem newWith: {self origin + (0.2@0.2)}.
	pointB := DrGPointFreeItem newWith: {self origin + self direction + (0.2@0.2)}.
	clone := DrGVector2ptsItem newWith: {pointA . pointB}.
	^ {pointA . pointB . clone}
]

{ #category : #'testing-model' }
DrGVectorItem >> isCurveItem [
	^ false
]

{ #category : #'testing-model' }
DrGVectorItem >> isSegmentItem [
	^ false
]

{ #category : #'testing-model' }
DrGVectorItem >> isVectorItem [
	^ true
]

{ #category : #accessing }
DrGVectorItem >> morphClass [ 
	^ DrGVectorMorph
]

{ #category : #updating }
DrGVectorItem >> move: aPoint [
	origin := origin + aPoint.

]

{ #category : #updating }
DrGVectorItem >> moveParent: aPoint [
"We don't want to move the parents, as the whole vector representation can be move all arround"
	^false
]

{ #category : #printing }
DrGVectorItem >> printOn: aStream [
	self printType: DrGVectorBuilder title on: aStream.
	self printCoordinates: vector on: aStream 
]

{ #category : #'xml writing' }
DrGVectorItem >> writeAsXmlTo: aNode [
	|node|
	node := super writeAsXmlTo: aNode.
	node attributeAt: #origin put: origin asString.
	^ node
]
