Class {
	#name : #DrGPolygonStyle,
	#superclass : #DrGFilledStyle,
	#category : #'DrGeo-Model-Style'
}

{ #category : #'initialize-release' }
DrGPolygonStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #polygonColor).
	self lineStyle: (DrGeoSystem preferences at: #polygonStyle).
	self thickness: (DrGeoSystem preferences at: #polygonThickness).
	self fill: (DrGeoSystem preferences at: #polygonFilled).
	self translucent: (DrGeoSystem preferences at: #polygonTranslucent).
	self arrow: #none
]
