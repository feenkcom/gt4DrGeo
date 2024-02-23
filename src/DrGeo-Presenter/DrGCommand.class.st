Class {
	#name : #DrGCommand,
	#superclass : #Object,
	#instVars : [
		'domain'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #accessing }
DrGCommand >> domain: aDomain [
	domain := aDomain.
]

{ #category : #command }
DrGCommand >> execute [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
DrGCommand >> release [
"Let my child do some clean up"
]

{ #category : #command }
DrGCommand >> unexecute [
	self subclassResponsibility 
]
