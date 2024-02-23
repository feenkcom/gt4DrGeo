Class {
	#name : #DrGBitmapBuilder,
	#superclass : #DrGMathItemBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGBitmapBuilder class >> description [
	^'Picture: drag and drop a picture in the canvas. It can be moved and scaled.' translated
]

{ #category : #documentation }
DrGBitmapBuilder class >> title [
	^'Picture' translated
]

{ #category : #accessing }
DrGBitmapBuilder >> arguments [
	^ {point}
]

{ #category : #testing }
DrGBitmapBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection isEmpty
]

{ #category : #xml }
DrGBitmapBuilder >> itemInstanceFrom: node [
	self addItem: #() at: 0@0.
	^ self getItem first.

]

{ #category : #constant }
DrGBitmapBuilder >> mathItemClass [ 
	^DrGBitmapItem 
]

{ #category : #xml }
DrGBitmapBuilder >> postProcess: item from: node [
	| form |
	super postProcess: item from: node.
	self parseValuePosition: node of: item.
	form := PNGReadWriter formFromStream: (node contentStringAt: #data) base64Decoded asByteArray readStream.
	item 
		insertAtScale: (node contentStringAt: #insertAtScale) asNumber;
		magnifyBy: (node contentStringAt: #magnify) asNumber;
		data: form
	
]

{ #category : #testing }
DrGBitmapBuilder >> readyToBuild [ 
	^ point notNil
]
