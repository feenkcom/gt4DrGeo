Extension { #name : #DrGPointItem }

{ #category : #'*Gt4DrGeo' }
DrGPointItem >> playIn: aSketchElement [
	| pointElement |
	pointElement := DGPointItemElement for: self.
	aSketchElement addChild: pointElement.
	pointElement relocate: self point
]
