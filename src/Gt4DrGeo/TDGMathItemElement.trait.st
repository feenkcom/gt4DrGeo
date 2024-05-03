Trait {
	#name : #TDGMathItemElement,
	#instVars : [
		'mathItem'
	],
	#category : #'Gt4DrGeo-View'
}

{ #category : #accessing }
TDGMathItemElement classSide >> for: aMathItem [
	^ self new
		mathItem: aMathItem;
		yourself
]

{ #category : #requirement }
TDGMathItemElement >> id: anId [
	^ self explicitRequirement
]

{ #category : #requirement }
TDGMathItemElement >> idClass [
	^ self explicitRequirement
]

{ #category : #accessing }
TDGMathItemElement >> idWithIndex: anIndex [
	^ self id: (self idClass indexed: anIndex)
]

{ #category : #testing }
TDGMathItemElement >> isDGPointElement [
	^ false
]

{ #category : #testing }
TDGMathItemElement >> isMathItemElement [
	^ true
]

{ #category : #accessing }
TDGMathItemElement >> mathItem [
	^ mathItem
]

{ #category : #accessing }
TDGMathItemElement >> mathItem: aMathItem [
	mathItem := aMathItem
]

{ #category : #querying }
TDGMathItemElement >> mySketchElement [
	self assert: self parent notNil description: 'I am not in a sketch'.
	self
		assert: (self parent isKindOf: DGSketchElement)
		description: 'My parent is not a sketch.'.
	^ self parent
]

{ #category : #requirement }
TDGMathItemElement >> parent [
	^ self explicitRequirement
]

{ #category : #'event handling' }
TDGMathItemElement >> registerEvents [
	"Empty hook, if needed.
	See DrGMorph>>#registerEvents"
]
