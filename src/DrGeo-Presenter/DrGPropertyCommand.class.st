"
A command to record property editing
"
Class {
	#name : #DrGPropertyCommand,
	#superclass : #DrGCommand,
	#instVars : [
		'property',
		'mathItem'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'as yet unclassified' }
DrGPropertyCommand class >> for: aMathItem with: aProperty in: aDomain [
	^self new
		domain: aDomain;
		mathItem: aMathItem;
		property: aProperty
]

{ #category : #command }
DrGPropertyCommand >> execute [
	|temp|
	temp := mathItem property.
	mathItem property: property.
	property := temp. 
	mathItem changed
]

{ #category : #accessing }
DrGPropertyCommand >> mathItem: aMathItem [ 
	mathItem := aMathItem 
]

{ #category : #accessing }
DrGPropertyCommand >> property: aProperty [
	property := aProperty 
]

{ #category : #command }
DrGPropertyCommand >> unexecute [
	self execute
]
