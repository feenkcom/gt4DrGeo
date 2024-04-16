Extension { #name : #DrGeoSketch }

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> initialize [
	presenter := DrGeo4GT gtService
			stSketch: self;
			yourself.
	DrGeoSketch triggerEvent: #newSmalltalkSketch with: self
]
