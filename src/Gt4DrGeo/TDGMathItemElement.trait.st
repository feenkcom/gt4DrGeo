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
	mathItem := anObject
]
