"
pointA can accept a PointItem instance or just a Point instance.
"
Class {
	#name : #DrGParallelBuilder,
	#superclass : #DrGLineBuilder,
	#instVars : [
		'direction'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGParallelBuilder class >> description [ 
	^ 'Line passing through one point and parallel to a line, half-line, etc.' translated
]

{ #category : #documentation }
DrGParallelBuilder class >> title [ 
	^ 'Parallel' translated
]

{ #category : #private }
DrGParallelBuilder >> addItem: aMathItemCollection at: aPoint [
	point := aPoint.
	aMathItemCollection first isPointItem 
		ifTrue: [pointA := aMathItemCollection first].
	aMathItemCollection first isDirectionItem 
		ifTrue:[direction := aMathItemCollection first.
			self addToFlyingItem: direction].
	
]

{ #category : #accessing }
DrGParallelBuilder >> arguments [
	^{direction . pointA}
]

{ #category : #'flying costume' }
DrGParallelBuilder >> flyingMathItemArguments [
	^{direction. movingPoint}.

]

{ #category : #testing }
DrGParallelBuilder >> isWanted: aMathItemCollection [
	aMathItemCollection ifEmpty: [^false].
	^ (aMathItemCollection first isPointItem 
		and: [pointA isNil])
			or: [aMathItemCollection first isDirectionItem and: [direction isNil]] 

]

{ #category : #constant }
DrGParallelBuilder >> mathItemClass [
	^DrGLineParallelItem
]

{ #category : #testing }
DrGParallelBuilder >> readyToBuild [
	^pointA notNil and: [direction notNil]
]

{ #category : #updating }
DrGParallelBuilder >> reset [
	super reset.
	pointA := direction := nil
]
