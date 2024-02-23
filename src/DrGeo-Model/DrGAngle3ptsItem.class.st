"
Define a geometric angle in the range  [0 ; 180[  given three points
"
Class {
	#name : #DrGAngle3ptsItem,
	#superclass : #DrGAngle3ptsOrientedItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGAngle3ptsItem >> adaptiveDescriptiveName [
	^ 'This geometric angle %1' translated
]

{ #category : #accessing }
DrGAngle3ptsItem >> morphClass [
	^ DrGAngleGeometricMorph
]

{ #category : #'xml writing' }
DrGAngle3ptsItem >> nodeType [
	^#'3pts'
]

{ #category : #'as yet unclassified' }
DrGAngle3ptsItem >> printOn: aStream [
	self printType: DrGAngleGeometricBuilder title on: aStream.
	aStream nextPut: Character space.
	self printInteger: self degreeAngle on: aStream.
	aStream nextPutAll: '°'.
]

{ #category : #updating }
DrGAngle3ptsItem >> update [
"Update for an angle in [0 ; 180]"
|u v center|
	self doParentsExist ifTrue:
		[center := parents second point.
		u := parents first point - center.
		v := parents third point - center.
		(u = (0@0) or: [v = (0@0)]) 
			ifTrue: [exist := false]
			ifFalse:
				[radianValue := value := ((u crossProduct: v) asFloat arcTan: (u dotProduct: v)) abs.
				degreeValue := radianValue radiansToDegrees]].
]
