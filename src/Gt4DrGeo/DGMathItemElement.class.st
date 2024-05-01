"
I am the abstract superclass of all Math Item elements.
"
Class {
	#name : #DGMathItemElement,
	#superclass : #BlElement,
	#instVars : [
		'mathItem'
	],
	#category : #'Gt4DrGeo-UI'
}

{ #category : #accessing }
DGMathItemElement class >> for: aMathItem [
	^ self new
		mathItem: aMathItem;
		yourself
]

{ #category : #accessing }
DGMathItemElement >> mathItem [
	^ mathItem
]

{ #category : #accessing }
DGMathItemElement >> mathItem: anObject [
	mathItem := anObject
]
