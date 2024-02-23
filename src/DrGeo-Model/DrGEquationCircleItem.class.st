Class {
	#name : #DrGEquationCircleItem,
	#superclass : #DrGEquationItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #accessing }
DrGEquationCircleItem >> equation [
	^ value
]

{ #category : #testing }
DrGEquationCircleItem >> isVerifiedBy: aPoint [
	^ parents first contains: aPoint
]

{ #category : #'xml writing' }
DrGEquationCircleItem >> nodeType [
	^#circle
]

{ #category : #updating }
DrGEquationCircleItem >> update [
	self doParentsExist ifTrue: [| circle |
		circle := parents first.
		value := String streamContents: [:stream |
		 stream nextPutAll: '(x';
			nextPut: (circle center x negated > 0 ifTrue: [$+] ifFalse: [$-]).
		self printDecimal: circle center x abs on: stream.
		stream nextPutAll: ')² + (y';
			nextPut: (circle center y negated > 0 ifTrue: [$+] ifFalse: [$-]).
		self printDecimal: circle center y abs on: stream.
		stream nextPutAll: ')² = '.
		self printDecimal: circle radius squared  on: stream]]
]
