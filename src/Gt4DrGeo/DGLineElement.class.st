Class {
	#name : #DGLineElement,
	#superclass : #BlLineElement,
	#traits : 'TDGMathItemElement',
	#classTraits : 'TDGMathItemElement classTrait',
	#category : #'Gt4DrGeo-View'
}

{ #category : #'instance creation' }
DGLineElement class >> for: aMathItem [
	^ self new
		mathItem: aMathItem;
		yourself
]

{ #category : #constant }
DGLineElement >> idClass [
	^ DGLineElementId
]

{ #category : #initalization }
DGLineElement >> initialize [
	super initialize.
	self
		zIndex: 10;
		border: (BlBorder paint: Color black width: 1)
]
