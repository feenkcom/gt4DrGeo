Class {
	#name : #DrGPointStyle,
	#superclass : #DrGStyle,
	#instVars : [
		'shape',
		'pointSize',
		'extent'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGPointStyle >> abscissa [
	^ self mathItem point x asString
]

{ #category : #accessing }
DrGPointStyle >> abscissa: aText [
	|number|
	[number := aText asString asNumber]
		on: Error
		do: [^ false].
	self mathItem x: number.
	self changed.
	^ true
]

{ #category : #accessing }
DrGPointStyle >> curvilinearAbscissa [
	^ self mathItem abscissa asString
]

{ #category : #accessing }
DrGPointStyle >> curvilinearAbscissa: aText [
	|number|
	[number := aText asString asNumber]
		on: Error
		do: [^ false].
	self mathItem abscissa: number.
	self changed.
	^ true
]

{ #category : #accessing }
DrGPointStyle >> extent [
	^ extent
]

{ #category : #'initialize-release' }
DrGPointStyle >> initialize [
	super initialize.
	self color: (DrGeoSystem preferences at: #pointColor).
	self pointSize: (DrGeoSystem preferences at: #pointSize).
	self shape: (DrGeoSystem preferences at: #pointShape)
]

{ #category : #widget }
DrGPointStyle >> myWidgets [ 
	^ super myWidgets addAll: {self shapeWidget. self sizeWidget}; yourself
]

{ #category : #accessing }
DrGPointStyle >> ordinate [
	^ self mathItem point y asString
]

{ #category : #accessing }
DrGPointStyle >> ordinate: aText [
	|number|
	[number := aText asString asNumber]
		on: Error
		do: [^ false].
	self mathItem y: number.
	self changed.
	^ true
]

{ #category : #accessing }
DrGPointStyle >> pointSize [
	"Answer the value of thickness"

	^ pointSize
]

{ #category : #accessing }
DrGPointStyle >> pointSize: anObject [
	"Set the value of thickness"
	pointSize := anObject.
	extent := Theme current pointExtentFor: pointSize.
	morph redrawNeeded

]

{ #category : #accessing }
DrGPointStyle >> pointSizeIndex [
	"Answer the index of thickness"
	^DrGTypePointSize pointSizeIndexOf: pointSize
]

{ #category : #accessing }
DrGPointStyle >> pointSizeIndex: index [
	"Set the value of thickness"
	self pointSize: (DrGTypePointSize pointSizeFor: index).
	self changed: #pointSizeIndex:
]

{ #category : #accessing }
DrGPointStyle >> shape [
	"Answer the value of shape"

	^ shape
]

{ #category : #accessing }
DrGPointStyle >> shape: anObject [
	"Set the value of shape"
	shape := anObject.
	morph redrawNeeded
]

{ #category : #accessing }
DrGPointStyle >> shapeIndex [
	"Answer the index of the shape"
	^ DrGTypePointShape pointShapeIndexOf: shape
]

{ #category : #accessing }
DrGPointStyle >> shapeIndex: index [
	"Set the value of shape"
	self shape: (DrGTypePointShape pointShapeFor: index).
	self changed: #shapeIndex:.
	self updateStylePanel 
]

{ #category : #widget }
DrGPointStyle >> shapeMorphCollection [
	^ DrGTypePointShape shapeMorphCollection 
]

{ #category : #widget }
DrGPointStyle >> shapeWidget [
	^  self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #shapeMorphCollection 
			indexGetter: #shapeIndex 
			indexSetter: #shapeIndex:)
			autoDeselect: false;
			yourself)
		named:  'Shape' translated
		help: 'Set the shape of the point.' translated
]

{ #category : #widget }
DrGPointStyle >> sizeMorphCollection [
	^ DrGTypePointSize sizeMorphCollection: shape
]

{ #category : #widget }
DrGPointStyle >> sizeWidget [
	^ self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #sizeMorphCollection 
			indexGetter: #pointSizeIndex
			indexSetter: #pointSizeIndex:)
			autoDeselect: false;
			yourself)
		named: 'Size' translated 
		help:  'Set the size of the point.' translated
]

{ #category : #widget }
DrGPointStyle >> updateStylePanel [
	self view presenter controlsManager updateStylerFor: self
]

{ #category : #'xml writing' }
DrGPointStyle >> writeAttributesTo: aNode [
	|attr|
	super writeAttributesTo: aNode.
	self pointSize = #small ifTrue: [attr := 'Dashed'].
	self pointSize = #medium ifTrue: [attr := 'Normal'].
	self pointSize = #large ifTrue: [attr := 'Thick'].
	aNode attributeAt: #thickness put: attr.
	attr := self shape asString capitalized.
	self shape = #square ifTrue: [attr := 'Rectangular'].
	self shape = #round ifTrue: [attr := 'Round'].
	aNode attributeAt: #style put: attr
]
