Class {
	#name : #DrGFilledStyle,
	#superclass : #DrGFinitCurveStyle,
	#instVars : [
		'fill',
		'translucent'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGFilledStyle >> fill [
	^ self isFilled
]

{ #category : #accessing }
DrGFilledStyle >> fill: boolean [
	fill := boolean.
	self color: color.
	self changed: #fill:.
	morph redrawNeeded.
]

{ #category : #widget }
DrGFilledStyle >> fillWidget [
	^ (PluggableCheckboxMorph 
		model: self
		getSelected: #fill
		setSelected:  #fill:
		label: 'Fill' translated)
		setBalloonText:  'Toggle to fill the object.' translated;
		yourself
]

{ #category : #accessing }
DrGFilledStyle >> isFilled [
	^ fill ifNil: [fill := true]
]

{ #category : #accessing }
DrGFilledStyle >> isTranslucent [
	^ translucent ifNil: [translucent := true]
]

{ #category : #widget }
DrGFilledStyle >> myWidgets [ 
	^ super myWidgets addAll: {self fillWidget. self translucentWidget}; yourself
]

{ #category : #accessing }
DrGFilledStyle >> toggleFilled [
	self fill: fill not.
	self changed
]

{ #category : #accessing }
DrGFilledStyle >> toggleTranslucent [
	self translucent: translucent not
]

{ #category : #accessing }
DrGFilledStyle >> translucent [
	^ self isTranslucent 
]

{ #category : #accessing }
DrGFilledStyle >> translucent: boolean [
	translucent := boolean.
	self color: color.
	self changed: #translucent:.
	morph redrawNeeded
]

{ #category : #widget }
DrGFilledStyle >> translucentWidget [
	^ (PluggableCheckboxMorph 
		model: self
		getSelected: #translucent 
		setSelected: #translucent:
		label: 'Translucent' translated)
		setBalloonText: 'Toggle the translucency of the object.' translated;
		yourself
]

{ #category : #'xml writing' }
DrGFilledStyle >> writeAttributesTo: aNode [
	super writeAttributesTo: aNode.
	aNode attributeAt: #filled put: self isFilled asString capitalized.
	aNode attributeAt: #translucent put: self isTranslucent asString capitalized
]
