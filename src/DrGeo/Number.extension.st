Extension { #name : #Number }

{ #category : #'*DrGeo' }
Number >> closeTo: num [
	"Tell whether the receiver and arguments are close from each."

	num isFloat ifTrue: [ ^ num closeTo: self asFloat ].
	^ [ self = num ] ifError: [ false ]
]

{ #category : #'*DrGeo' }
Number >> closeTo: num precision: aPrecision [
	"are these two numbers close?"

	num isFloat ifTrue: [ ^ num closeTo: self asFloat precision: aPrecision ].
	^ [ self = num ] ifError: [ false ]
]

{ #category : #'*DrGeo' }
Number >> printParenthesisOn: aStream [
"Add parenthesis when the value is negative"
	self < 0 
		ifTrue:  [aStream nextPut: $(.
			self printOn: aStream.
			aStream nextPut: $)]
		ifFalse: [self printOn: aStream]
]

{ #category : #'*DrGeo' }
Number >> printShowingDecimalPlaces: digits [
	^ String 
		streamContents:  [:str | self printOn: str fractionDigits: digits]
		estimatedSize: 10 + digits
]
