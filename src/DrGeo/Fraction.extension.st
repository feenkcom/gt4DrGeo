Extension { #name : #Fraction }

{ #category : #'*DrGeo' }
Fraction >> printParenthesisOn: aStream [
"No need to add parenthesis, it is handled by Fraction>>printOn:"
	self printOn: aStream 
]
