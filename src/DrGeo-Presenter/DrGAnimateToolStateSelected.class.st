"
The selected state for animate tool: when a free point on curve is selected and it is animated.
 - abscissa: the curvilinear abscissa of the selected point
"
Class {
	#name : #DrGAnimateToolStateSelected,
	#superclass : #DrGAnimateToolState,
	#instVars : [
		'abscissa'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #animate }
DrGAnimateToolStateSelected >> animate [
	| a | 
	a := self mathItem abscissa + self animateStep.
	a > 1.0 ifTrue: [a := 0].
	self mathItem abscissa: a.
	self context domain updateAllMathItems 
]

{ #category : #accessing }
DrGAnimateToolStateSelected >> context: aContext [
	super context: aContext.
	self drawable arrangeToStartStepping.
]

{ #category : #testing }
DrGAnimateToolStateSelected >> isAnimating [
	^ true
]

{ #category : #animate }
DrGAnimateToolStateSelected >> startAnimating [
	abscissa := self mathItem abscissa.
	self drawable arrangeToStartStepping.
]

{ #category : #animate }
DrGAnimateToolStateSelected >> stopAnimating [
	self drawable stopStepping.
	self mathItem abscissa: abscissa.
	self context domain updateAllMathItems
]
