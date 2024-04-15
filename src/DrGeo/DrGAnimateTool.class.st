"
A tool to animate a free point on a curve.
- animateSpeed: millisecond betwen to animation step
"
Class {
	#name : #DrGAnimateTool,
	#superclass : #DrGTool,
	#instVars : [
		'animateStep'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #'as yet unclassified' }
DrGAnimateTool class >> description [
	^'Select a free point on a curve to animate it.' translated
]

{ #category : #'as yet unclassified' }
DrGAnimateTool class >> title [
	^ 'Animate' translated
]

{ #category : #'as yet unclassified' }
DrGAnimateTool >> animate [
	state animate
]

{ #category : #accessing }
DrGAnimateTool >> animateStep [
	^ animateStep
]

{ #category : #accessing }
DrGAnimateTool >> animateStep: aFloat [
	animateStep := aFloat 
]

{ #category : #accessing }
DrGAnimateTool >> description [ 
	^ self class description
]

{ #category : #'initialize-release' }
DrGAnimateTool >> initialize [
	super initialize.
	self reset
]

{ #category : #accessing }
DrGAnimateTool >> isAnimating [
	^ self state isAnimating 
]

{ #category : #accessing }
DrGAnimateTool >> relevantMorphsNear: aPoint [
	^ (self pointMorphsNear: aPoint) select: [:aMorph | aMorph mathItem isPointItemOnCurve]
]

{ #category : #'initialize-release' }
DrGAnimateTool >> reset [
	state ifNotNil: [state stopAnimating].
	super reset.
	self switchState: DrGAnimateToolState.

]
