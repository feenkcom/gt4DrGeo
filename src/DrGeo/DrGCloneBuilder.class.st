"
I can clone item
"
Class {
	#name : #DrGCloneBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'item'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #private }
DrGCloneBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection at: aPoint.
	item := aMathItemCollection first
]

{ #category : #building }
DrGCloneBuilder >> buildItem [
	"clone myself with the necessary parents"
	^  item clone
]

{ #category : #testing }
DrGCloneBuilder >> isWanted: aMathItemCollection [ 
	^ aMathItemCollection notEmpty 
		and: [aMathItemCollection first isCloneable]
]

{ #category : #testing }
DrGCloneBuilder >> readyToBuild [ 
	^ item notNil 
]

{ #category : #updating }
DrGCloneBuilder >> reset [
	super reset.
	item := nil
]
