Class {
	#name : #DrGRayStyle,
	#superclass : #DrGCurveStyle,
	#category : #'DrGeo-Styles'
}

{ #category : #'initialize-release' }
DrGRayStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #rayColor).
	self lineStyle: (DrGeoSystem preferences at: #rayStyle).
	self thickness: (DrGeoSystem preferences at: #rayThickness)
]
