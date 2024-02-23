Class {
	#name : #DrGCompositeStyle,
	#superclass : #DrGFinitCurveStyle,
	#instVars : [
		'shape'
	],
	#category : #'DrGeo-Styles'
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
