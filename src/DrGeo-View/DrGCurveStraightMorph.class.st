Class {
	#name : #DrGCurveStraightMorph,
	#superclass : #DrGPolylineMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #'instance creation' }
DrGCurveStraightMorph class >> from: start to: end color: color [
	^ self new
		from: start to: end;
		borderColor: color
		
]

{ #category : #accessing }
DrGCurveStraightMorph >> from: startPoint to: endPoint [  
	vertices at: 1 put: startPoint.
	vertices at: 2 put: endPoint.

]

{ #category : #initialization }
DrGCurveStraightMorph >> initialize [
	super initialize.
	vertices := Array new: 2.
]
