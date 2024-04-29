Extension { #name : #DrGPointFreeItem }

{ #category : #'*Gt4DrGeo' }
DrGPointFreeItem >> gtSummary [
	^ super gtSummary
		, {{'point'.
					self point}}
]
