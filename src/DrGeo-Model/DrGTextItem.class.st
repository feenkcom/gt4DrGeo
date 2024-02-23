Class {
	#name : #DrGTextItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'text',
		'position',
		'locked'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGTextItem >> = aMathItem [
	^ super = aMathItem and: [text = aMathItem text and: [position = aMathItem position]]
]

{ #category : #private }
DrGTextItem >> adaptiveDescriptiveName [
	^ 'This text' translated
]

{ #category : #accessing }
DrGTextItem >> basicType [
	^#text
]

{ #category : #computing }
DrGTextItem >> closestPointTo: aPoint [
 ^ position
]

{ #category : #accessing }
DrGTextItem >> descriptiveName [ 
	^ self adaptiveDescriptiveName

]

{ #category : #testing }
DrGTextItem >> doParentsExist [ 
	^ true
]

{ #category : #updating }
DrGTextItem >> editPropertyIn: presenter [
	| holder |
	holder := ValueHolder with: text.
	holder action: [:newText | presenter domain propertyCommandFor: self with: newText].
	^ TextEntryPanel open: holder label: 'Edit this text' translated
]

{ #category : #'initialize-release' }
DrGTextItem >> initialize [ 
	super initialize.
	text := 'Edit me' translated
]

{ #category : #'initialize-release' }
DrGTextItem >> initialize: theParents [
	super initialize: theParents.
	self position: theParents last
]

{ #category : #testing }
DrGTextItem >> isLockable [ 
	^ true
]

{ #category : #accessing }
DrGTextItem >> isLocked [
	^ locked ifNil: [locked := false]
]

{ #category : #testing }
DrGTextItem >> isPropertyEditable [ 
	^ true
]

{ #category : #'testing-model' }
DrGTextItem >> isTextItem [
	^ true
]

{ #category : #accessing }
DrGTextItem >> locked: aBoolean [
	locked := aBoolean 
]

{ #category : #accessing }
DrGTextItem >> morphClass [ 
	^ DrGTextMorph
]

{ #category : #updating }
DrGTextItem >> move: aPoint [
	self isLocked ifFalse: [position := position + aPoint]
]

{ #category : #updating }
DrGTextItem >> moveParent: aPoint [
	^ false
]

{ #category : #'xml writing' }
DrGTextItem >> nodeType [
	^#free
]

{ #category : #accessing }
DrGTextItem >> parents: aCollection [
	parents := nil.

]

{ #category : #accessing }
DrGTextItem >> position [
	^ position
]

{ #category : #accessing }
DrGTextItem >> position: aPoint [ 
	position := aPoint.
	self rehash
]

{ #category : #printing }
DrGTextItem >> printOn: aStream [
	self printType: DrGTextBuilder title on: aStream 
]

{ #category : #updating }
DrGTextItem >> property [
	^ self text
]

{ #category : #updating }
DrGTextItem >> property: aProperty [ 
	self text: aProperty 
]

{ #category : #comparing }
DrGTextItem >> rehash [
	^ hash := (self basicType hash bitXor: text hash) bitXor: position hash
]

{ #category : #accessing }
DrGTextItem >> text [
	^ text
]

{ #category : #accessing }
DrGTextItem >> text: aText [
	text := aText.
	self rehash
]

{ #category : #'xml writing' }
DrGTextItem >> writeAsXmlPositionTo: aNode [ 
	"return the newly created element"
	aNode
		addElement: ((XMLElement named: #x)
				addContent: (XMLStringNode string: position x asString));
		addElement: ((XMLElement named: #y)
				addContent: (XMLStringNode string: position y asString)).
	^ aNode
]

{ #category : #'xml writing' }
DrGTextItem >> writeAsXmlTo: aNode [
	|node|
	node := super writeAsXmlTo: aNode.
	node addElement:  ((XMLElement named: #contents) addContent: (XMLStringNode string: self text)).
	^ self writeAsXmlPositionTo: node

]
