Extension { #name : #Number }

{ #category : #'*Gt4DrGeo' }
Number >> printOn: aStream fractionDigits: placesDesired [
	self printOn: aStream showingDecimalPlaces: placesDesired
]
