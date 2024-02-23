Class {
	#name : #DrGArcStyle,
	#superclass : #DrGFilledStyle,
	#category : #'DrGeo-Styles'
}

{ #category : #accessing }
DrGArcStyle >> fill: boolean [
	(fill := boolean) 
		ifTrue: ["morph morph makeClosed"]
		ifFalse: ["morph morph makeOpen"].
	self changed: #fill:.
	morph redrawNeeded
]

{ #category : #'initialize-release' }
DrGArcStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #arcColor).
	self lineStyle: (DrGeoSystem preferences at: #arcStyle).
	self thickness: (DrGeoSystem preferences at: #arcThickness).
	self arrow: (DrGeoSystem preferences at: #arcArrow).
	self fill: (DrGeoSystem preferences at: #arcFilled).
	self translucent: (DrGeoSystem preferences at: #arcTranslucent).
]
