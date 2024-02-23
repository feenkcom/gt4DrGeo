Class {
	#name : #DrGTextBuilder,
	#superclass : #DrGMathItemBuilder,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #documentation }
DrGTextBuilder class >> description [ 
	^ 'Free text you can edit and move around.' translated
]

{ #category : #documentation }
DrGTextBuilder class >> title [
	^ 'Text' translated
]

{ #category : #accessing }
DrGTextBuilder >> arguments [
	^ {point}
]

{ #category : #testing }
DrGTextBuilder >> isWanted: aMathItemCollection [
	^ aMathItemCollection isEmpty
]

{ #category : #xml }
DrGTextBuilder >> itemInstanceFrom: node [
	self addItem: #() at: 0@0.
	^ self getItem first.

]

{ #category : #constant }
DrGTextBuilder >> mathItemClass [ 
	^ DrGTextItem
]

{ #category : #xml }
DrGTextBuilder >> postProcess:  item from: node [
	super postProcess: item from: node.
	self parseValuePosition: node of: item.
	item text: (node contentStringAt: #contents)
]

{ #category : #testing }
DrGTextBuilder >> readyToBuild [ 
	^ point notNil
]
