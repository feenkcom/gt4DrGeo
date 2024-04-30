Extension { #name : #DrGDirectionItem }

{ #category : #'*Gt4DrGeo' }
DrGDirectionItem >> gtDisplayOn: aStream [
	aStream nextPutAll: 'Line '.
	self printCoordinates: origin on: aStream.
	aStream nextPutAll: '->'.
	self printCoordinates: vector on: aStream
]

{ #category : #'*Gt4DrGeo' }
DrGDirectionItem >> gtSummary [
	^ super gtSummary
		, {{'from'.
					self origin}.
				{'to'.
					self direction}}
]
