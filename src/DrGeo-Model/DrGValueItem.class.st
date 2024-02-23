Class {
	#name : #DrGValueItem,
	#superclass : #DrGMathItem,
	#instVars : [
		'value',
		'position',
		'locked'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueItem >> adaptiveDescriptiveName [
	^ 'This value %1' translated
]

{ #category : #accessing }
DrGValueItem >> basicType [
	 ^#value
]

{ #category : #computing }
DrGValueItem >> closestPointTo: aPoint [
	^ position
]

{ #category : #'initialize-release' }
DrGValueItem >> initialize [
	super initialize.
	value := 0
]

{ #category : #'initialize-release' }
DrGValueItem >> initialize: theParents [
	super initialize: theParents.
	self position: theParents last
]

{ #category : #testing }
DrGValueItem >> isLockable [ 
	^ true
]

{ #category : #accessing }
DrGValueItem >> isLocked [
	^ locked ifNil: [locked := false]
]

{ #category : #'testing-model' }
DrGValueItem >> isValueItem [
	^true
]

{ #category : #accessing }
DrGValueItem >> locked: aBoolean [
	locked := aBoolean 
]

{ #category : #accessing }
DrGValueItem >> morphClass [ 
	 ^ DrGValueMorph
]

{ #category : #updating }
DrGValueItem >> move: aPoint [
	self isLocked ifFalse: [self position: position + aPoint].

]

{ #category : #updating }
DrGValueItem >> moveParent: aPoint [
"Don't move my parent"
	^false
]

{ #category : #accessing }
DrGValueItem >> parents: aCollection [ 
	"last is the initial screen position of the value"
	aCollection isEmptyOrNil ifTrue: 
		[ parents := aCollection.
		^ self ].
	aCollection last isPoint 
		ifTrue: [ parents := aCollection allButLast ]
		ifFalse: [ parents := aCollection ].

]

{ #category : #accessing }
DrGValueItem >> position [
	^position
]

{ #category : #accessing }
DrGValueItem >> position: aPoint [
	position := aPoint.
]

{ #category : #printing }
DrGValueItem >> printNameOn: aStream [
	aStream nextPutAll: 'Value ' translated.

]

{ #category : #printing }
DrGValueItem >> printOn: aStream [
	self printTypeOn: aStream.
	self printValueOn: aStream 
]

{ #category : #printing }
DrGValueItem >> printTypeOn: aStream [
|safeName|
	self printNameOn: aStream.
	(safeName := self safeName) ifNotEmpty: [	
		aStream nextPutAll: self safeName;
			nextPutAll: ' = '].

]

{ #category : #printing }
DrGValueItem >> printValueOn: aStream [ 
	self printDecimal: value on: aStream 
]

{ #category : #accessing }
DrGValueItem >> valueItem [
	^value
]

{ #category : #'xml writing' }
DrGValueItem >> writeAsXmlPositionTo: aNode [ 
	"return the newly created element"
	aNode
		addElement: ((XMLElement named: #x)
				addContent: (XMLStringNode string: position x asString));
		addElement: ((XMLElement named: #y)
				addContent: (XMLStringNode string: position y asString)).
	^ aNode
]
