Extension { #name : #DrGeoSketch }

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> initialize [
	presenter := DGSketchState new
]

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> morphOf: item [
	"Instead of the actual morph, we just wrap the item and intercept all the messages so we have a post mortem log.
	This is also the hook where we  can store the item in the state of the sketch."
	self state addItem: item.
	^ DGLogger for: item
]

{ #category : #'*Gt4DrGeo' }
DrGeoSketch >> state [
	^ presenter
]
