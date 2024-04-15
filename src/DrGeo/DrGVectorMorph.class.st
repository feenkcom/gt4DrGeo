Class {
	#name : #DrGVectorMorph,
	#superclass : #DrGCurveStraightMorph,
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGVectorMorph >> getVertices [
	self 
		from: (self drawable worldToMorph: mathItem origin)
		to: (self drawable worldToMorph: mathItem origin + mathItem direction).

]

{ #category : #initializing }
DrGVectorMorph >> initialize [
	super initialize.
	self arrow: #forward
]

{ #category : #'testing type' }
DrGVectorMorph >> isVector [
	^ true
]

{ #category : #accessing }
DrGVectorMorph >> styleClass [
	^DrGVectorStyle
]
