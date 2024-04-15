"
The neutral state for animate tool: when no free point on curve is selected yet.
"
Class {
	#name : #DrGAnimateToolState,
	#superclass : #DrGStyleToolState,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #animate }
DrGAnimateToolState >> animate [
	self shouldNotImplement
]

{ #category : #accessing }
DrGAnimateToolState >> animateStep [ 
	^ self context animateStep  
]

{ #category : #handling }
DrGAnimateToolState >> handleChoice: aMorphCollection [
	aMorphCollection 
		ifNotEmpty: [
			self stopAnimating.
			self context morph: aMorphCollection first.
			self switchState: DrGAnimateToolStateSelected.
			self context state startAnimating.
			^ true]
		ifEmpty: [
			self context reset.
			^ false]
]

{ #category : #testing }
DrGAnimateToolState >> isAnimating [
	^ false
]

{ #category : #accessing }
DrGAnimateToolState >> mathItem [
	^ self context mathItem 
]

{ #category : #animate }
DrGAnimateToolState >> stopAnimating [
	"we are not animating in this state, do nothing"
]
