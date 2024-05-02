Extension { #name : #DrGDirectionItem }

{ #category : #'*Gt4DrGeo' }
DrGDirectionItem >> gtDisplayOn: aStream [
	aStream nextPutAll: 'Line '.
	self printCoordinates: origin on: aStream.
	aStream nextPutAll: '->'.
	self printCoordinates: origin + vector on: aStream
]

{ #category : #'*Gt4DrGeo' }
DrGDirectionItem >> gtSummary [
	^ super gtSummary
		, {{'from'.
					self origin}.
				{'direction'.
					self direction}.
				{'to'.
					self origin + self direction}}
]

{ #category : #'*Gt4DrGeo' }
DrGDirectionItem >> playIn: aSketchElement [
	| lineElement |
	lineElement := DGLineElement for: self.
	lineElement
		fromAnchor: (BlElementCenterAnchor
				element: (aSketchElement elementForItem: self parents first)).
	lineElement
		toAnchor: (BlElementCenterAnchor
				element: (aSketchElement elementForItem: self parents second)).
	aSketchElement addChild: lineElement
]
