"
I am the composite item, I represent a set of math items.
"
Class {
	#name : #DrGCompositeItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'subItems'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #'as yet unclassified' }
DrGCompositeItem class >> newWith: theSubItems [
	^self new
		subItems: theSubItems
]

{ #category : #comparing }
DrGCompositeItem >> = aMathItem [
	^ aMathItem 
		ifNil: [false] 
		ifNotNil: [self className = aMathItem className 
			and: [self subItems = aMathItem subItems]]
]

{ #category : #private }
DrGCompositeItem >> adaptiveDescriptiveName [
	^ 'This composite object %1' translated
]

{ #category : #comparing }
DrGCompositeItem >> hash [
	^ self subItems hash bitXor: self className hash
]

{ #category : #'as yet unclassified' }
DrGCompositeItem >> isCompositeItem [
	^true
]

{ #category : #'as yet unclassified' }
DrGCompositeItem >> isGeometricItem [
"if all subitem are geometric item, considere ourself as a geometric item"
	subItems do: [:aMathItem |
		(aMathItem isGeometricItem) 
			ifFalse: [^false]].
	^true
]

{ #category : #updating }
DrGCompositeItem >> move: aPoint [
	subItems do: [:item|
		(item class ~= DrGPointFreeItem
			and: [item class ~= DrGPointOncurveItem])
			ifTrue:
				[item moveEvent: aPoint]].
]

{ #category : #updating }
DrGCompositeItem >> moveParent: aPoint [
	^false
]

{ #category : #accessing }
DrGCompositeItem >> subItems [
	^subItems 
]

{ #category : #accessing }
DrGCompositeItem >> subItems: theSubItems [
	subItems := theSubItems 
]
