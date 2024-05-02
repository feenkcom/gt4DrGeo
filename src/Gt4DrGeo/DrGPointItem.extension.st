Extension { #name : #DrGPointItem }

{ #category : #'*Gt4DrGeo' }
DrGPointItem >> playIn: aSketchElement [
	| pointElement |
	pointElement := DGPointElement for: self.
	aSketchElement addChild: pointElement.
	pointElement bePullable.
	pointElement relocate: self point
]
