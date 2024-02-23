Class {
	#name : #DrGHomothetyBuilder,
	#superclass : #DrGRotationBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGHomothetyBuilder class >> description [
	^ 'Homothety: select a center, a value and a geometric object. The first selected point is the homothety center.' translated
]

{ #category : #documentation }
DrGHomothetyBuilder class >> title [ 
	^ 'Homothety (scale)' translated
]

{ #category : #constant }
DrGHomothetyBuilder >> mathItemClass: aMathItem [
	|className|
	className := 'DrG', aMathItem basicType capitalized, 'HomothetyItem'.
	^(Smalltalk classNamed: className)
]
