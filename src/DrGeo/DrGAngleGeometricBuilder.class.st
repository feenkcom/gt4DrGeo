"
A builder for geometric angle defined by three points.
"
Class {
	#name : #DrGAngleGeometricBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'pointA',
		'pointB',
		'pointC'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #'as yet unclassified' }
DrGAngleGeometricBuilder class >> description [ 
	^ 'Geometric angle defined by three points, the second point is the vertex. Its measure belongs to [0 ; 180].' translated
]

{ #category : #'as yet unclassified' }
DrGAngleGeometricBuilder class >> title [
	^ 'Geometric angle' translated
]

{ #category : #private }
DrGAngleGeometricBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	aMathItemCollection first isPointItem
		ifTrue:
			[pointA ifNil: 
				[pointA := aMathItemCollection first.
				^self].
			pointB ifNil:
				[pointB := aMathItemCollection first.
				^self].
			pointC := aMathItemCollection first]
]

{ #category : #accessing }
DrGAngleGeometricBuilder >> arguments [
	^ {pointA . pointB . pointC. point}
]

{ #category : #testing }
DrGAngleGeometricBuilder >> isWanted: aMathItemCollection [
	^aMathItemCollection notEmpty
		and: [(aMathItemCollection first isPointItem
				and: [aMathItemCollection first ~= pointA
				and: [aMathItemCollection first ~= pointB]]	)]
]

{ #category : #constant }
DrGAngleGeometricBuilder >> mathItemClass [
	^ DrGAngle3ptsItem 
]

{ #category : #testing }
DrGAngleGeometricBuilder >> readyToBuild [
	^ pointA notNil and: [pointB notNil and: [pointC notNil]]
			
]

{ #category : #updating }
DrGAngleGeometricBuilder >> reset [
	super reset.
	pointA := pointB := pointC := nil
]
