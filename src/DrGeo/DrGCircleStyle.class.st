Class {
	#name : #DrGCircleStyle,
	#superclass : #DrGFilledStyle,
	#category : #'DrGeo-Model-Style'
}

{ #category : #'initialize-release' }
DrGCircleStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #circleColor).
	self lineStyle: (DrGeoSystem preferences at: #circleStyle).
	self thickness: (DrGeoSystem preferences at: #circleThickness).
	self fill: (DrGeoSystem preferences at: #circleFilled).
	self translucent:(DrGeoSystem preferences at: #circleTranslucent).
]
