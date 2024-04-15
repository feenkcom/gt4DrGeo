"
A DrGLineParallelItem is a parallel line.

parents first is a direction item
parents second is a point

"
Class {
	#name : #DrGLineParallelItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGLineParallelItem >> adaptiveDescriptiveName [
	^ 'This parallel line %1' translated
]

{ #category : #updating }
DrGLineParallelItem >> move: aPoint [
	parents size = 1 ifTrue: [origin := origin + aPoint].

]

{ #category : #updating }
DrGLineParallelItem >> moveParent: aPoint [
"Only move the origin parent if it is a PointItem instance"
	parents isEmptyOrNil ifFalse: [parents second moveEvent: aPoint].
	^true
]

{ #category : #'xml writing' }
DrGLineParallelItem >> nodeType [
	^#parallel
]

{ #category : #updating }
DrGLineParallelItem >> update [
	self doParentsExist ifTrue:
		[self direction: (parents at: 1) direction.
		parents size = 2 ifTrue: [self origin: (parents at: 2) point]].

]
