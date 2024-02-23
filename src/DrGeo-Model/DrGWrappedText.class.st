Class {
	#name : #DrGWrappedText,
	#superclass : #DrGWrappedItem,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #accessing }
DrGWrappedText >> backgroundColor: aColor [
	self style backgroundColor: aColor
]

{ #category : #updating }
DrGWrappedText >> moveTo: aPoint [
	self mathItem position: aPoint.
	morph redrawNeeded
]

{ #category : #updating }
DrGWrappedText >> text: aText [
	self mathItem text: aText asText.
	morph redrawNeeded
]
