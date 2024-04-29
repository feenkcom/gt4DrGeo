Extension { #name : #DrGeoSketch }

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> initialize [
	"Put stuff here!"
]

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> morphOf: item [
	"Instead of the actual morph, we just wrap the item and intercept all the messages so we have a post mortem log."

	^ DGLogger for: item
]
