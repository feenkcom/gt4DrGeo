"
- color is a the optional fill color of the curve
- borderColor is its line color
"
Class {
	#name : #DrGCurveStyle,
	#superclass : #DrGStyle,
	#instVars : [
		'thickness',
		'lineStyle'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #accessing }
DrGCurveStyle >> borderColor [
	"Answer the value of border color"
	^hidden ifTrue: [DrGTypeColor hiddenColor] ifFalse: [self baseColor]
]

{ #category : #accessing }
DrGCurveStyle >> borderWidth [
	"give the border width"
	^ Theme current lineWidthFor: thickness
]

{ #category : #accessing }
DrGCurveStyle >> color [
"Answer the fill color"
	^self isFilled ifTrue: [color] ifFalse: [Color transparent]
]

{ #category : #accessing }
DrGCurveStyle >> color: aColor [
"Set the value of fill color and border color"
	color := self isTranslucent ifTrue: [aColor alpha: 0.3] ifFalse: [aColor alpha: 1].
	morph 
		borderColor: (Theme current adjustColor: self borderColor);
		color: self color;
		redrawNeeded
]

{ #category : #accessing }
DrGCurveStyle >> lineStyle [
	"Answer the value of lineStyle"

	^ lineStyle
]

{ #category : #accessing }
DrGCurveStyle >> lineStyle: aSymbol [
	"Set the value of lineStyle"
	lineStyle := aSymbol.
	morph dashedBorder: (Theme current lineStyleDataFor: aSymbol).
	morph redrawNeeded
]

{ #category : #widget }
DrGCurveStyle >> lineStyleIndex [
	"Answer the index of lineStyle"
	^ DrGTypeStyle styleIndexOf: lineStyle
]

{ #category : #widget }
DrGCurveStyle >> lineStyleIndex: integer [
	"Set the value of lineStyle"
	self lineStyle: (DrGTypeStyle styleSymbols at: integer).
	self changed: #lineStyleIndex:

]

{ #category : #widget }
DrGCurveStyle >> lineWidget [
	^ self widget:  (
		(DropDownButtonMorph 
			model: self 
			listGetter: #styleMorphCollection
			indexGetter: #lineStyleIndex
			indexSetter: #lineStyleIndex:)
			autoDeselect: false;
			yourself)
		named: 'Style' translated 
		help: 'Set the style of the line.' translated
]

{ #category : #widget }
DrGCurveStyle >> myWidgets [ 
	^ super myWidgets addAll: {self lineWidget . self thicknessWidget}; yourself
]

{ #category : #widget }
DrGCurveStyle >> styleMorphCollection [
	^ DrGTypeStyle styleMorphCollection
]

{ #category : #accessing }
DrGCurveStyle >> thickness [
	"Answer the value of thickness"

	^ thickness
]

{ #category : #accessing }
DrGCurveStyle >> thickness: anObject [
	"Set the value of thickness"
	thickness := anObject.
	morph borderWidth: self borderWidth.
	morph redrawNeeded
]

{ #category : #widget }
DrGCurveStyle >> thicknessIndex [
	"Answer the index of thickness"

	^DrGTypeThickness thicknessIndexOf: thickness
]

{ #category : #widget }
DrGCurveStyle >> thicknessIndex: integer [
	"Set the value of thickness"
	self thickness: (DrGTypeThickness thicknessFor: integer).
	self changed: #thicknessIndex:
]

{ #category : #widget }
DrGCurveStyle >> thicknessMorphCollection [
	^ DrGTypeThickness thicknessMorphCollection
]

{ #category : #widget }
DrGCurveStyle >> thicknessWidget [
	^ self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #thicknessMorphCollection 
			indexGetter: #thicknessIndex 
			indexSetter: #thicknessIndex:)
			autoDeselect: false;
			yourself)			
		named: 'Thickness' translated
		help: 'Set the thickness of the line.' translated
]

{ #category : #'xml writing' }
DrGCurveStyle >> writeAttributesTo: aNode [
	super writeAttributesTo: aNode.
	aNode attributeAt: #style put: self lineStyle.
	aNode attributeAt: #thickness put: self thickness.
]
