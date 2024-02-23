Class {
	#name : #DrGReflectionBuilder,
	#superclass : #DrGTransformationBuilder,
	#instVars : [
		'axe'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGReflectionBuilder class >> description [
	^ 'Reflexion: select a line and a geometric object. Reflexion axe is the first selected line.' translated
]

{ #category : #documentation }
DrGReflectionBuilder class >> title [
	^ 'Reflection' translated
]

{ #category : #private }
DrGReflectionBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection  at: aPoint.
	(aMathItemCollection first isLineItem and: [axe isNil])
		ifTrue: [axe := aMathItemCollection first]
		ifFalse: [mathItem := aMathItemCollection first]
]

{ #category : #accessing }
DrGReflectionBuilder >> arguments: aMathItem [
	^{aMathItem . axe}
]

{ #category : #testing }
DrGReflectionBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty 
		and: [(aMathItemCollection first isLineItem 
		and: [axe isNil])
			or: [aMathItemCollection first isGeometricItem 
				and: [mathItem isNil]]]
]

{ #category : #constant }
DrGReflectionBuilder >> mathItemClass: aMathItem [
	|className|
	className := 'DrG', aMathItem basicType capitalized, 'ReflexionItem'.
	^(Smalltalk classNamed: className)
]

{ #category : #testing }
DrGReflectionBuilder >> readyToBuild [
	^axe notNil and: [mathItem notNil]
]

{ #category : #updating }
DrGReflectionBuilder >> reset [
	super reset.
	axe := mathItem := nil
]
