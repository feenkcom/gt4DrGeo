Class {
	#name : #DrGWrappedFilledCurve,
	#superclass : #DrGWrappedFinitCurve,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #updating }
DrGWrappedFilledCurve >> filled [
	self style fill: true
]

{ #category : #updating }
DrGWrappedFilledCurve >> opaque [
	self style translucent: false
]

{ #category : #updating }
DrGWrappedFilledCurve >> translucent [
	self style translucent: true
]

{ #category : #updating }
DrGWrappedFilledCurve >> unfilled [
	self style fill: false
]
