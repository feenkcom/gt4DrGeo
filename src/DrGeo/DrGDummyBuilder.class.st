"
A Builder to build nothing. Used in the select mode
"
Class {
	#name : #DrGDummyBuilder,
	#superclass : #DrGMathItemBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #private }
DrGDummyBuilder >> addItem: aMathItemCollection at: aPoint [
	super addItem: aMathItemCollection  at: aPoint
]

{ #category : #testing }
DrGDummyBuilder >> isWanted: aMathItemCollection [
	^true
]

{ #category : #testing }
DrGDummyBuilder >> readyToBuild [
	^false
]
