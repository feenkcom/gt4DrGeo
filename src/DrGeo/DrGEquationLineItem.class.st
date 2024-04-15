"
a line equation: 
- provide a and b for the reduced equation: y = a . x + b
- provide m otherwise for the equation x = m

"
Class {
	#name : #DrGEquationLineItem,
	#superclass : #DrGEquationItem,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGEquationLineItem >> a [
	^ a
]

{ #category : #accessing }
DrGEquationLineItem >> a: aNumber [
	a := aNumber
]

{ #category : #accessing }
DrGEquationLineItem >> b [
	^ b
]

{ #category : #accessing }
DrGEquationLineItem >> b: aNumber [
	b := aNumber
]

{ #category : #accessing }
DrGEquationLineItem >> c [
	^ c
]

{ #category : #accessing }
DrGEquationLineItem >> c: aNumber [
	c := aNumber
]

{ #category : #accessing }
DrGEquationLineItem >> equation [ 
	^ value := self reducedEquation 
]

{ #category : #testing }
DrGEquationLineItem >> isVerifiedBy: aPoint [
	^ parents first isCollinearWith: (parents first origin - aPoint)
]

{ #category : #'xml writing' }
DrGEquationLineItem >> nodeType [
	^#line
]

{ #category : #accessing }
DrGEquationLineItem >> originY [
	^ b isZero 		ifTrue: [nil] ifFalse: [c negated / b]
]

{ #category : #accessing }
DrGEquationLineItem >> reducedEquation [
	^ b isZero 
		ifTrue:  [String streamContents: [:stream |
			stream nextPutAll: 'x = '.
			self printDecimal: c negated / a on: stream]]
		ifFalse: [
			| slope originY |
			originY := self originY.			
			String streamContents: [:stream |
			stream nextPutAll: 'y = '.
			a isZero 
				ifTrue: [originY printParenthesisOn: stream] 
				ifFalse: [
					slope := self slope.
					slope printParenthesisOn: stream.
					stream nextPutAll: ' * x'.
					c isZero ifFalse: [
						stream nextPutAll: ' + '.
						originY printParenthesisOn: stream]]]]
]

{ #category : #accessing }
DrGEquationLineItem >> slope [
	^ b isZero 		ifTrue: [nil] ifFalse: [a negated / b]
]

{ #category : #updating }
DrGEquationLineItem >> update [
	self doParentsExist ifTrue: [ |u origin|
		u := parents first direction.
		origin := parents first origin.
		self a: u y.
		self b: u x negated.
		self c: origin y * u x - (origin x * u y)]
]
