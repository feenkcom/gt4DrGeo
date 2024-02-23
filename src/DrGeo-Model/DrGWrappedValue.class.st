Class {
	#name : #DrGWrappedValue,
	#superclass : #DrGWrappedItem,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #updating }
DrGWrappedValue >> moveTo: aPoint [
	self mathItem position: aPoint     
]

{ #category : #updating }
DrGWrappedValue >> name: aString [ 
	morph mathItem name: aString.
	morph redrawNeeded
]

{ #category : #updating }
DrGWrappedValue >> value: aNumber [
	(self mathItem respondsTo: #valueItem:) 
		ifTrue: [self mathItem valueItem: aNumber]
]
