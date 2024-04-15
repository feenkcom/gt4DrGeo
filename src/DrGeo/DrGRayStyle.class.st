Class {
	#name : #DrGRayStyle,
	#superclass : #DrGCurveStyle,
	#category : #'DrGeo-Model-Style'
}

{ #category : #'initialize-release' }
DrGRayStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #rayColor).
	self lineStyle: (DrGeoSystem preferences at: #rayStyle).
	self thickness: (DrGeoSystem preferences at: #rayThickness)
]
