Class {
	#name : #DrGVectorStyle,
	#superclass : #DrGCurveStyle,
	#category : #'DrGeo-Styles'
}

{ #category : #'initialize-release' }
DrGVectorStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #vectorColor).
	self lineStyle:(DrGeoSystem preferences at: #vectorStyle).
	self thickness: (DrGeoSystem preferences at: #vectorThickness)
]
