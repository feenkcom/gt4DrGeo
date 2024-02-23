Class {
	#name : #DrGLineStyle,
	#superclass : #DrGCurveStyle,
	#category : #'DrGeo-Styles'
}

{ #category : #'initialize-release' }
DrGLineStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #lineColor).
	self lineStyle: (DrGeoSystem preferences at: #lineStyle).
	self thickness: (DrGeoSystem preferences at: #lineThickness)
]
