Class {
	#name : #DrGWrappedFinitCurve,
	#superclass : #DrGWrappedCurve,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #updating }
DrGWrappedFinitCurve >> backArrow [
	self style arrow: #back
]

{ #category : #updating }
DrGWrappedFinitCurve >> bothArrows [
	self style arrow: #both
]

{ #category : #updating }
DrGWrappedFinitCurve >> forwardArrow [
	self style arrow: #forward
]
