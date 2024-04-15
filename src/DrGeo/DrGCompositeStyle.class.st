Class {
	#name : #DrGCompositeStyle,
	#superclass : #DrGFinitCurveStyle,
	#instVars : [
		'shape'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGCompositeStyle >> shape [
	^shape
]

{ #category : #accessing }
DrGCompositeStyle >> shape: anObject [
	shape := anObject.
	morph shape: anObject
]
