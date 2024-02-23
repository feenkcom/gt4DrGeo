"
Define an oriented angle in the range  [0 ; 360[  given three points
"
Class {
	#name : #DrGAngle3ptsOrientedItem,
	#superclass : #DrGAngleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #testing }
DrGAngle3ptsOrientedItem >> isLockable [ 
	^ false
]

{ #category : #accessing }
DrGAngle3ptsOrientedItem >> morphClass [
	^ DrGAngleOrientedMorph 
]

{ #category : #updating }
DrGAngle3ptsOrientedItem >> move: aPoint [
"Don't move when user drag around"
]

{ #category : #'xml writing' }
DrGAngle3ptsOrientedItem >> nodeType [
	^ #'3ptsOriented'
]

{ #category : #accessing }
DrGAngle3ptsOrientedItem >> position [ 
	^ self summit point
]

{ #category : #accessing }
DrGAngle3ptsOrientedItem >> side1 [
	^ parents first
]

{ #category : #accessing }
DrGAngle3ptsOrientedItem >> side2 [
	^ parents third
]

{ #category : #accessing }
DrGAngle3ptsOrientedItem >> summit [
	^ parents second
]

{ #category : #updating }
DrGAngle3ptsOrientedItem >> update [
|u v center|
	self doParentsExist ifTrue:
		[center := parents second point.
		u := parents first point - center.
		v := parents third point - center.
		(u = (0@0) or: [v = (0@0)]) 
			ifTrue: [exist := false]
			ifFalse:
				[radianValue := value := (u crossProduct: v) asFloat arcTan: (u dotProduct: v).
				degreeValue := radianValue radiansToDegrees + 360 \\ 360]].
]
