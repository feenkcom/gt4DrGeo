"
curveItem : segment, vector, circle, arc
"
Class {
	#name : #DrGTranslationBuilder,
	#superclass : #DrGTransformationBuilder,
	#instVars : [
		'vector'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGTranslationBuilder class >> description [
	^ 'Translation: select a vector and a geometric object.' translated
]

{ #category : #documentation }
DrGTranslationBuilder class >> title [
	^ 'Translation' translated
]

{ #category : #private }
DrGTranslationBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	(aMathItemCollection first isVectorItem and: [vector isNil])
		ifTrue: [vector := aMathItemCollection first]
		ifFalse: [mathItem := aMathItemCollection first]
]

{ #category : #accessing }
DrGTranslationBuilder >> arguments: aMathItem [
	^{aMathItem . vector}
]

{ #category : #testing }
DrGTranslationBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty 
		and: [(aMathItemCollection first isVectorItem 
				and: [vector isNil])
			or:	[aMathItemCollection first isGeometricItem 
				and: [aMathItemCollection first isVectorItem not 
				and: [mathItem isNil]]]]
]

{ #category : #constant }
DrGTranslationBuilder >> mathItemClass: aMathItem [
	|className|
	className := 'DrG', aMathItem basicType capitalized, 'TranslationItem'.
	^(Smalltalk classNamed: className)
]

{ #category : #testing }
DrGTranslationBuilder >> readyToBuild [
	^vector notNil and: [mathItem notNil]
]

{ #category : #updating }
DrGTranslationBuilder >> reset [
	super reset.
	vector := mathItem := nil.
]
