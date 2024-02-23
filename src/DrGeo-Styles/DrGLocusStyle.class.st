Class {
	#name : #DrGLocusStyle,
	#superclass : #DrGCurveStyle,
	#category : #'DrGeo-Styles'
}

{ #category : #'initialize-release' }
DrGLocusStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #locusColor).
	self lineStyle: (DrGeoSystem preferences at: #locusStyle).
	self thickness: (DrGeoSystem preferences at: #locusThickness)
]
