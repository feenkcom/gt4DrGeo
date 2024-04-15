"
A class to encapsulate math item for user friendly use when doing Smalltalk figure
"
Class {
	#name : #DrGWrappedItem,
	#superclass : #Object,
	#instVars : [
		'morph'
	],
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #'as yet unclassified' }
DrGWrappedItem class >> wrap: aMorph [
	^ self new morph: aMorph
]

{ #category : #updating }
DrGWrappedItem >> color: aColor [
	self style color: aColor
]

{ #category : #updating }
DrGWrappedItem >> hide [
	self style hidden: true.
	morph forcedVisibility: false.
]

{ #category : #updating }
DrGWrappedItem >> lock [
	morph locked: true
]

{ #category : #accessing }
DrGWrappedItem >> mathItem [
	^ morph mathItem 
]

{ #category : #accessing }
DrGWrappedItem >> morph [
	^ morph
]

{ #category : #accessing }
DrGWrappedItem >> morph: aCostume [
	morph := aCostume 
]

{ #category : #updating }
DrGWrappedItem >> moveTo: aPoint [
]

{ #category : #updating }
DrGWrappedItem >> name: aString [
	morph name: aString asString
]

{ #category : #updating }
DrGWrappedItem >> show [
	morph forcedVisibility: true.
	self style hidden: false
]

{ #category : #accessing }
DrGWrappedItem >> style [
	^ morph style
]

{ #category : #updating }
DrGWrappedItem >> unhide [
	self style hidden: false.
	morph forcedVisibility: false.
]

{ #category : #updating }
DrGWrappedItem >> unlock [
	morph locked: false
]
