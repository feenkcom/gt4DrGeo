"
A builder for arc defined by its center and origin, then an angle or an extremity

- angle is a float
- other items are point
"
Class {
	#name : #DrGArcCenterBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'center',
		'origin',
		'extremity'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGArcCenterBuilder class >> description [ 
	^  'Arc defined by its center and two points.' translated
]

{ #category : #documentation }
DrGArcCenterBuilder class >> title [
	^'Arc (center)' translated
]

{ #category : #private }
DrGArcCenterBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	center ifNil: [^ center := aMathItemCollection first].
	origin ifNil: [
		origin := aMathItemCollection first.
		^ self addToFlyingItem: origin].
	extremity ifNil: [extremity := aMathItemCollection first]
]

{ #category : #testing }
DrGArcCenterBuilder >> arguments [
	^ {center. origin. extremity}
]

{ #category : #'flying costume' }
DrGArcCenterBuilder >> flyingMathItemArguments [
	^{center. origin. movingPoint}.

]

{ #category : #'flying costume' }
DrGArcCenterBuilder >> flyingMorphClass [ 
	^ DrGArcMorph
]

{ #category : #testing }
DrGArcCenterBuilder >> isWanted: aMathItemCollection [ 
| item |
	^ aMathItemCollection notEmpty 
		and: [(item := aMathItemCollection first) isPointItem 
		and: [item ~= center 
		and: [item ~= origin]]]
]

{ #category : #constant }
DrGArcCenterBuilder >> mathItemClass [ 
	^ DrGArcCenterAngleItem 
]

{ #category : #testing }
DrGArcCenterBuilder >> readyToBuild [ 
	^ origin notNil and: [center notNil and: [extremity notNil]]
]

{ #category : #updating }
DrGArcCenterBuilder >> reset [
	super reset.
	origin := center := extremity := nil
]
