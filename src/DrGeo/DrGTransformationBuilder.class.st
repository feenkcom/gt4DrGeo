"
Transformation builder can handle compositeItem, we need to specialize
its behavior.
"
Class {
	#name : #DrGTransformationBuilder,
	#superclass : #DrGMathItemBuilder,
	#instVars : [
		'mathItem'
	],
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #accessing }
DrGTransformationBuilder >> arguments [
	^self arguments: mathItem
]

{ #category : #building }
DrGTransformationBuilder >> buildItem [
	mathItem class = DrGCompositeItem 
		ifTrue:
			[^ mathItem subItems collect: [:aMathItem|
					(self mathItemClass: aMathItem) 
						newWith: (self arguments: aMathItem)]]
		ifFalse:
			[^super buildItem]
]

{ #category : #constant }
DrGTransformationBuilder >> mathItemClass [
	^ self mathItemClass: mathItem
]

{ #category : #xml }
DrGTransformationBuilder >> parentsById: node [
	^ (super parentsById: node) reverse
]
