Class {
	#name : #DrGAngleBisectorBuilder,
	#superclass : #DrGLineBuilder,
	#instVars : [
		'pointC',
		'angle'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGAngleBisectorBuilder class >> description [
	^ 'Angle bisector defined by three points or an angle defined by three points.' translated
]

{ #category : #documentation }
DrGAngleBisectorBuilder class >> title [
	^ 'Angle bisector' translated
]

{ #category : #private }
DrGAngleBisectorBuilder >> addItem: aMathItemCollection at: aPoint [
	| item |
	point := aPoint.
	(item := aMathItemCollection first) isAngleItem ifTrue: [^ angle ifNil: [angle := item]].
	pointA 
		ifNil: [pointA := item] 
		ifNotNil: [pointB 
			ifNil: [pointB := item.
				self addToFlyingItem: pointB] 
			ifNotNil: [pointC := item]]
]

{ #category : #accessing }
DrGAngleBisectorBuilder >> arguments [
	^ angle 
		ifNotNil: [{angle}] 
		ifNil: [{pointA . pointB . pointC}]
]

{ #category : #'flying costume' }
DrGAngleBisectorBuilder >> flyingMathItemArguments [ 
	^ {pointA. pointB. movingPoint}.
]

{ #category : #testing }
DrGAngleBisectorBuilder >> isWanted: aMathItemCollection [
	| item |
	^ aMathItemCollection notEmpty 
		and: [((item := aMathItemCollection first) isPointItem 
				and: [item ~= pointA 
				and: [item  ~= pointB]])
			or:	[item isAngleItem and: [pointA isNil and: [item nodeType = #'3pts']]]]	
]

{ #category : #constant }
DrGAngleBisectorBuilder >> mathItemClass [ 
	^ angle 
		ifNotNil: [DrGLineAngleBisectorItem] 
		ifNil: [DrGAngleBisector3ptsItem]
]

{ #category : #testing }
DrGAngleBisectorBuilder >> readyToBuild [ 
	^ angle notNil or:
		[pointA notNil and: [pointB notNil and: [pointC notNil]]]
]

{ #category : #updating }
DrGAngleBisectorBuilder >> reset [
	super reset.
	pointC := angle := nil
	
]
