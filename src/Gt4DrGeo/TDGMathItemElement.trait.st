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

{ #category : #testing }
TDGMathItemElement >> isMathItemElement [
	^ true
]

{ #category : #accessing }
TDGMathItemElement >> mathItem [
	^ mathItem
]

{ #category : #accessing }
TDGMathItemElement >> mathItem: anObject [
	mathItem := anObject.
	self registerEvents
]

{ #category : #querying }
TDGMathItemElement >> mySketchElement [
	self assert: self parent notNil description: 'I am not in a sketch'.
	self
		assert: (self parent isKindOf: DGSketchElement)
		description: 'My parent is not a sketch.'.
	^ self parent
]

{ #category : #'event handling' }
TDGMathItemElement >> registerEvents [
	"self subclassResponsibility"
]
