Extension { #name : #DrGeoSketch }

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> initialize [
	presenter := DGDrGeo gtService
			stSketch: self;
			yourself.
	DrGeoSketch triggerEvent: #newSmalltalkSketch with: self
]
