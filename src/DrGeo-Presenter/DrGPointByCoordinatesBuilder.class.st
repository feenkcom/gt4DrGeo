Class {
	#name : #DrGPointByCoordinatesBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'valueX',
		'valueY',
		'script'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGPointByCoordinatesBuilder class >> description [
	^ 'Point given its coordinates: select two numbers or a point coordinates (@).' translated
]

{ #category : #documentation }
DrGPointByCoordinatesBuilder class >> title [ 
	^ 'Coordinates' translated
]

{ #category : #private }
DrGPointByCoordinatesBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection first isScriptItem 
		ifTrue: 
			[script := aMathItemCollection first]
		ifFalse: 
			[valueX 
				ifNil: [valueX := aMathItemCollection first.]
				ifNotNil: [valueY ifNil: [valueY := aMathItemCollection first]]]
]

{ #category : #accessing }
DrGPointByCoordinatesBuilder >> arguments [
	^script 
		ifNotNil: [{script}]
		ifNil: [{valueX . valueY}]
]

{ #category : #testing }
DrGPointByCoordinatesBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection notEmpty
		and: [(aMathItemCollection first isScriptItem
				and: [aMathItemCollection first ~= script])			
			or: [aMathItemCollection first isValueItem
				and: [aMathItemCollection first ~= valueX
				and: [aMathItemCollection first ~= valueY]]]]
			
]

{ #category : #constant }
DrGPointByCoordinatesBuilder >> mathItemClass [
	^script 
		ifNotNil: [DrGPointScriptItem ]
		ifNil: [DrGPointCoordinateItem]
]

{ #category : #testing }
DrGPointByCoordinatesBuilder >> readyToBuild [
	^ (valueX notNil and: [valueY notNil])
		or: [script notNil]
]

{ #category : #updating }
DrGPointByCoordinatesBuilder >> reset [
	super reset.
	script := valueX := valueY := nil
]
