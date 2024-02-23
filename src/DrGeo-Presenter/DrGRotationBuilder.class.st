Class {
	#name : #DrGRotationBuilder,
	#superclass : #DrGTransformationBuilder,
	#instVars : [
		'center',
		'value'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGRotationBuilder class >> description [
	^ 'Rotation: select a point, a value and a geometric object. The first selected point is the rotation center.' translated
]

{ #category : #documentation }
DrGRotationBuilder class >> title [ 
	^ 'Rotation' translated
]

{ #category : #private }
DrGRotationBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	(aMathItemCollection first isPointItem and: [center isNil])
		ifTrue: [center := aMathItemCollection first. ^self].
	(aMathItemCollection first isValueItem and: [value isNil])
		ifTrue: [value := aMathItemCollection first. ^self].
	mathItem := aMathItemCollection first
]

{ #category : #accessing }
DrGRotationBuilder >> arguments: aMathItem [
	^{aMathItem . center . value}
]

{ #category : #testing }
DrGRotationBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection notEmpty 
		and: [(aMathItemCollection first isPointItem and: [center isNil])
			or: [(aMathItemCollection first isValueItem and: [value isNil])
			or: [aMathItemCollection first isGeometricItem and: [mathItem isNil]]]]
]

{ #category : #constant }
DrGRotationBuilder >> mathItemClass: aMathItem [
	|className|
	className := 'DrG', aMathItem basicType capitalized, 'RotationItem'.
	^(Smalltalk classNamed: className)
]

{ #category : #testing }
DrGRotationBuilder >> readyToBuild [
	^center notNil and: [value notNil and: [mathItem notNil]]
]

{ #category : #updating }
DrGRotationBuilder >> reset [
	super reset.
	center := value := mathItem := nil
]
