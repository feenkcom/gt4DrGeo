Class {
	#name : #DrGTextStyle,
	#superclass : #DrGStyle,
	#instVars : [
		'backgroundColor',
		'borderColor',
		'fontSize'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #'as yet unclassified' }
DrGTextStyle class >> backgroundColorSymbols [
	^ OrderedCollection new
		add: #transparent;
		addAll: DrGTypeColor colorSymbols;
		yourself 
]

{ #category : #'as yet unclassified' }
DrGTextStyle class >> backgroundColors [
	^ self backgroundColorSymbols collect: [:symbol | Color perform: symbol]
]

{ #category : #accessing }
DrGTextStyle >> backgroundColor [
	^ backgroundColor 
]

{ #category : #accessing }
DrGTextStyle >> backgroundColor: aColor [
	backgroundColor := aColor.
	self changed
]

{ #category : #accessing }
DrGTextStyle >> backgroundColorIndex [
	^ self class backgroundColors indexOf: self baseBackgroundColor
	
]

{ #category : #accessing }
DrGTextStyle >> backgroundColorIndex: index [
	| aColor |
	aColor := Color perform: (self class backgroundColorSymbols at: index).
	self setTranslucent: aColor.
	self changed: #backgroundColorIndex:

]

{ #category : #widget }
DrGTextStyle >> backgroundMorphCollection [
	^ self class backgroundColors collect: [:aColor |
		ImageMorph new image: (DrGIcons colorForm: aColor)]
]

{ #category : #widget }
DrGTextStyle >> backgroundWidget [
	^  self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #backgroundMorphCollection 
			indexGetter: #backgroundColorIndex  
			indexSetter: #backgroundColorIndex:)
			autoDeselect: false;
			yourself)
		named: 'Background' translated 
		help: 'Set the background colour.' translated
]

{ #category : #accessing }
DrGTextStyle >> baseBackgroundColor [ 
"This color whithout transparency"
	^ backgroundColor isTransparent 
		ifFalse: [backgroundColor alpha: 1.0] 
		ifTrue: [backgroundColor]
]

{ #category : #accessing }
DrGTextStyle >> borderColor [
	^ borderColor 
]

{ #category : #accessing }
DrGTextStyle >> borderColor: aColor [
	borderColor := aColor.
	morph redrawNeeded
]

{ #category : #accessing }
DrGTextStyle >> borderColorIndex [
	^ self class backgroundColors indexOf: borderColor
]

{ #category : #accessing }
DrGTextStyle >> borderColorIndex: index [
	| aColor |
	aColor := Color perform: (self class backgroundColorSymbols at: index).
	self borderColor: aColor.
	self changed: #borderColorIndex:

]

{ #category : #widget }
DrGTextStyle >> borderWidget [
	^  self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #backgroundMorphCollection 
			indexGetter: #borderColorIndex  
			indexSetter: #borderColorIndex:)
			autoDeselect: false;
			yourself)
		named: 'Border' translated 
		help: 'Set the border colour.' translated
]

{ #category : #accessing }
DrGTextStyle >> fontSize: integer [
	fontSize := integer.
	morph fontSize: integer.
	self changed
]

{ #category : #accessing }
DrGTextStyle >> fontSizeIndex [
	^ self fontSizesCollection indexOf: fontSize
	
]

{ #category : #accessing }
DrGTextStyle >> fontSizeIndex: index [
	self fontSize: (self fontSizesCollection at: index).
	self changed: #fontSizeIndex:

]

{ #category : #widget }
DrGTextStyle >> fontSizeWidget [
	^ self widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter:  #fontSizesMorphCollection
			indexGetter:  #fontSizeIndex 
			indexSetter: #fontSizeIndex:)
			autoDeselect: false;
			yourself)
		named: 'Font size' translated
		help: 'Set the font size.' translated
]

{ #category : #widget }
DrGTextStyle >> fontSizesCollection [
	^#(9 10 12 14 16)
]

{ #category : #widget }
DrGTextStyle >> fontSizesMorphCollection [
	^ self fontSizesCollection collect: [:pt | 
			LabelMorph 
				contents: pt asString 
				font: (FontFamily 
					familyName: FontFamily defaultFamilyName 
					pointSize: (Theme current scale: pt))]
]

{ #category : #'initialize-release' }
DrGTextStyle >> initialize [ 
	super initialize.
	self color: (DrGeoSystem preferences at: #textColor).
	self setTranslucent: (DrGeoSystem preferences at: #textBackgroundColor).
	self borderColor: (DrGeoSystem preferences at: #textBorderColor).
	fontSize := 12 .
]

{ #category : #widget }
DrGTextStyle >> myWidgets [
	^ super myWidgets 
		addAll: {self backgroundWidget . self borderWidget . self fontSizeWidget}; 
		yourself
]

{ #category : #accessing }
DrGTextStyle >> setTranslucent: aColor [
	aColor isTransparent 
		ifFalse: [self backgroundColor: (aColor alpha: 0.6)] 
		ifTrue: [self backgroundColor: aColor]

]

{ #category : #widget }
DrGTextStyle >> styleWidget [
| controls |
" There is no name for text object"
	controls := 	OrderedCollection new
		add: self colorWidget;
		yourself.
	controls addAll: self myWidgets.
	controls add: self feedbackWidget.
	controls add: self hiddenWidget.
	morph isLockable ifTrue: [controls add: self lockedWidget].
	^controls
]

{ #category : #'xml writing' }
DrGTextStyle >> writeAttributesTo: aNode [
	super writeAttributesTo: aNode.
	aNode attributeAt: #background put: self baseBackgroundColor colorName asString capitalized.
	aNode attributeAt: #border put: self borderColor colorName asString capitalized.
	aNode attributeAt: #fontSize put: fontSize asString
]
