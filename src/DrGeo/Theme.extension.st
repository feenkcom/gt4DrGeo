Extension { #name : #Theme }

{ #category : #'*DrGeo-canvas' }
Theme >> adjustColor: aColor [
"Depending on the current Theme, 
we want to adjust the black or white color used to display an item view"
	^ self isDarkTheme 
		ifTrue: [
			(aColor alpha: 1) = (Color black) 
				ifTrue: [Color white alpha: aColor alpha] ifFalse: [aColor] 	]
		ifFalse: [
			(aColor alpha: 1) = (Color white) 
				ifTrue: [Color black alpha: aColor alpha] ifFalse: [aColor] ]
		
]

{ #category : #'*DrGeo-canvas' }
Theme >> canvasBackground [
	^ (Color white)
]

{ #category : #'*DrGeo-UI' }
Theme >> circularToolbarDropDownGap [
	^ self scale: 5
]

{ #category : #'*DrGeo-UI' }
Theme >> circularToolbarDropDownHeight [
	^ self scale: 15
]

{ #category : #'*DrGeo-UI' }
Theme >> circularToolbarExtent [
	^ self scale: 300
]

{ #category : #'*DrGeo-UI' }
Theme >> drgeoButtonColor [
"Blue Ukraine"
	^ (Color fromHexString: '#0057b7')
]

{ #category : #'*DrGeo-UI' }
Theme >> drgeoButtonSelectedColor [
"Yellow Ukraine"
	^ Color fromHexString: '#ffd700'
]

{ #category : #'*DrGeo-UI' }
Theme >> isDarkTheme [
	^ self canvasBackground = (Color black)
]

{ #category : #'*DrGeo-canvas' }
Theme >> lineStyleDataFor: aStyle [
	"possible lineStyle"
	aStyle = #dot ifTrue: [^ self scale: #(1 6)].
	aStyle = #dash ifTrue: [^ self scale: #(8 8)].
	^ nil
]

{ #category : #'*DrGeo-canvas' }
Theme >> lineWidthFor: thickness [
" width of line  view "
	^ thickness == #small 
		ifTrue: [self scale: 1]
		ifFalse: [
			thickness == #medium
				ifTrue:[self scale: 2]					
				ifFalse:[self scale: 3]	]
]

{ #category : #'*DrGeo-canvas' }
Theme >> pointExtentFor: pointSize [
" Extent of point view "
	^ (pointSize == #small 
		ifTrue: [self scale: 6]
		ifFalse: [
			pointSize == #large
				ifTrue:[self scale: 10]					
				ifFalse:[self scale: 8]	]) asPoint
]

{ #category : #'*DrGeo-UI' }
Theme >> previewSize [
	^ 300@200
]

{ #category : #'*DrGeo-UI' }
Theme >> scale: anIntegerOrCollection [
" Scale the length represented by anInteger to the display density "
	^ (anIntegerOrCollection * FontFamily defaultPointSize / 12) rounded
]

{ #category : #'*DrGeo-UI' }
Theme >> scaled: aFloat [
" Scale the length represented by anInteger to the display density "
	^ aFloat * FontFamily defaultPointSize / 12
]

{ #category : #'*DrGeo-UI' }
Theme >> smWheelWidth [
	^ (self wheelWidth / 1.5) rounded max: 1
]

{ #category : #'*DrGeo-UI' }
Theme >> toolbarIconSize [
	^ (FontFamily defaultPointSize + 1) * 4
]

{ #category : #'*DrGeo-UI' }
Theme >> wheelHeight [
	^ self scale: 120
]

{ #category : #'*DrGeo-UI' }
Theme >> wheelWidth [
	^ self scale: 24
]
