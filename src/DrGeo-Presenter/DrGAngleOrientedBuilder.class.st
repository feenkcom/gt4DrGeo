"
A builder for oriented angle defined by three points or two vectors.
"
Class {
	#name : #DrGAngleOrientedBuilder,
	#superclass : #DrGAngleGeometricBuilder,
	#instVars : [
		'vectorA',
		'vectorB'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGAngleOrientedBuilder class >> description [ 
	^ 'Oriented angle defined by three points or two vectors. When defined from three points, the second point is the vertex. Its measure belongs to [0 ; 360[ or ]-180 ; 180]. ' translated
]

{ #category : #documentation }
DrGAngleOrientedBuilder class >> title [
	^ 'Oriented angle' translated
]

{ #category : #private }
DrGAngleOrientedBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint. "it handles the case of adding a point to the selection"
	aMathItemCollection first isPointItem
		ifFalse:
			[vectorA ifNil:
				[vectorA := aMathItemCollection first.
				^self].
			vectorB := aMathItemCollection first]
]

{ #category : #accessing }
DrGAngleOrientedBuilder >> arguments [
	^pointA 
		ifNotNil: [{pointA . pointB . pointC. point}]
		ifNil: [{vectorA . vectorB. point}]
]

{ #category : #testing }
DrGAngleOrientedBuilder >> isWanted: aMathItemCollection [
	^aMathItemCollection notEmpty
		and: [(aMathItemCollection first isPointItem
				and: [vectorA isNil
				and: [aMathItemCollection first ~= pointA
				and: [aMathItemCollection first ~= pointB]]	])
			or: 	[aMathItemCollection first isVectorItem 
				and: [pointA isNil 
				and: [aMathItemCollection first ~= vectorA]]]]
]

{ #category : #constant }
DrGAngleOrientedBuilder >> mathItemClass [
	^pointA 
		ifNotNil: [DrGAngle3ptsOrientedItem]
		ifNil: [DrGAngleVectorsItem]
]

{ #category : #xml }
DrGAngleOrientedBuilder >> postProcess: item from: node [
	super postProcess: item from: node.
	(node attributeAt: #type) asSymbol == #vectors ifTrue: [
		self parseValuePosition: node of: item]
]

{ #category : #testing }
DrGAngleOrientedBuilder >> readyToBuild [
	^ super readyToBuild or: [vectorA notNil and: [vectorB notNil]]
			
]

{ #category : #updating }
DrGAngleOrientedBuilder >> reset [
	super reset.
	vectorA := vectorB := nil
]
