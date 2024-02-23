Class {
	#name : #DrGSymmetryBuilder,
	#superclass : #DrGTransformationBuilder,
	#instVars : [
		'center'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGSymmetryBuilder class >> description [
	^ 'Symmetry: select a point and a geometric object. The first selected point is the symmetry center.' translated
]

{ #category : #documentation }
DrGSymmetryBuilder class >> title [
	^'Symmetry' translated 
]

{ #category : #private }
DrGSymmetryBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	(aMathItemCollection first isPointItem and: [center isNil])
		ifTrue: [center := aMathItemCollection first]
		ifFalse: [mathItem := aMathItemCollection first]
]

{ #category : #accessing }
DrGSymmetryBuilder >> arguments: aMathItem [
	^{aMathItem . center}
]

{ #category : #testing }
DrGSymmetryBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty
		and: [(aMathItemCollection first isPointItem 
				and: [center isNil])
			or:	[aMathItemCollection first isGeometricItem 
				and: [mathItem isNil]]]
]

{ #category : #constant }
DrGSymmetryBuilder >> mathItemClass: aMathItem [
	|className|
	className := 'DrG', aMathItem basicType capitalized, 'SymmetryItem'.
	^(Smalltalk classNamed: className)
]

{ #category : #testing }
DrGSymmetryBuilder >> readyToBuild [
	^center notNil and: [mathItem notNil]
]

{ #category : #updating }
DrGSymmetryBuilder >> reset [
	super reset.
	mathItem := center := nil
]
