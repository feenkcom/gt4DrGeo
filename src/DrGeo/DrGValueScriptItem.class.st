"
Script
	- script: a script class instance 
	- parents: a collection of morph (BEWARE, and not math item)
"
Class {
	#name : #DrGValueScriptItem,
	#superclass : #DrGValueItem,
	#instVars : [
		'script',
		'parentMorphs'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGValueScriptItem >> = aScriptItem [
	^super = aScriptItem and: [self script class == aScriptItem script class]
]

{ #category : #private }
DrGValueScriptItem >> adaptiveDescriptiveName [
	| string |
	parents size > 0 
		ifFalse: [string := 'This script "{1}"' translated]
		ifTrue: 
			[parents size = 1 
				ifTrue: [string := 'This script "{1}" with argument: %2' translated]
				ifFalse: [string := 'This script "{1}" with arguments: %2' translated].
			string := string copyReplaceAll: '%2' with: self argumentsName].
	^string format: {script class scriptName}.
]

{ #category : #private }
DrGValueScriptItem >> argumentsName [
	"collect parents name in a string as A, B, C"
	| stream |
	parents size = 0 ifTrue: [ ^ '' ].
	stream := ReadWriteStream on: String new.
	parents allButLast do: 
		[ :item | 
		stream
			nextPutAll: (item safeName ifEmpty: [item printString]);
			nextPutAll: ', ' ].
	stream nextPutAll: (parents last safeName ifEmpty: [parents last printString]).
	^ stream contents
]

{ #category : #accessing }
DrGValueScriptItem >> compute [
"Do the script computation and return its result "
	^ self script compute
]

{ #category : #'as yet unclassified' }
DrGValueScriptItem >> editPropertyIn: presenter [
	^ presenter editScript: script class
]

{ #category : #initialization }
DrGValueScriptItem >> initialize: theParentsCostume [ 
	super initialize: theParentsCostume.
	self script: (theParentsCostume at: theParentsCostume size - 1)
]

{ #category : #testing }
DrGValueScriptItem >> isPropertyEditable [
	^ DrGeoSystem isTablet 
		ifTrue: [false]  
		ifFalse:  [true]
]

{ #category : #testing }
DrGValueScriptItem >> isScriptItem [
	^true
]

{ #category : #accessing }
DrGValueScriptItem >> morphClass [ 
	 ^ DrGScriptMorph
]

{ #category : #accessing }
DrGValueScriptItem >> morphs [
	^ parentMorphs 
]

{ #category : #'xml writing' }
DrGValueScriptItem >> nodeType [
	^#script
]

{ #category : #accessing }
DrGValueScriptItem >> parents: aCollection [ 
	"last is the initial screen position of the value, and previous last is the script class"
	aCollection isEmptyOrNil ifTrue: 
		[parents := aCollection.
		parentMorphs := aCollection.
		^ self ].
	aCollection last isPoint 
		ifTrue: [ parents := aCollection allButLast: 2 ]
		ifFalse: 
			[ "play nicely with macro"
			parents := aCollection ].

]

{ #category : #accessing }
DrGValueScriptItem >> parents: aCollection in: presenter [
	"last is the initial screen position of the value, and previous last is the script class"
	self parents: aCollection.
	parents ifNotNil: [parentMorphs := presenter drawable viewsOf: parents].
	"reinject the argument in the script in cas it is already instanciated"
	script ifNotNil: [script arguments: parentMorphs]
]

{ #category : #printing }
DrGValueScriptItem >> printNameOn: aStream [
	aStream nextPutAll: 'Script ' translated.

]

{ #category : #printing }
DrGValueScriptItem >> printValueOn: aStream [
	value isNumber 
		ifTrue: [^ self printDecimal: value on: aStream].
	value isPoint 
		ifTrue: [^ self printCoordinates: value on:  aStream].
	aStream print: value
]

{ #category : #comparing }
DrGValueScriptItem >> rehash [
	^hash := super rehash bitXor: script class hash
]

{ #category : #accessing }
DrGValueScriptItem >> script [
	^script
]

{ #category : #accessing }
DrGValueScriptItem >> script: aScriptClass [
	script := aScriptClass new arguments: self morphs.
	self rehash 
]

{ #category : #updating }
DrGValueScriptItem >> update [
	self doParentsExist ifTrue: [ value := script compute]
]

{ #category : #'xml writing' }
DrGValueScriptItem >> writeAsXmlTo: aNode [
	|node|
	node := super writeAsXmlTo: aNode.
	node attributeAt: #class put: script class printString.
	node addElement: (
		(XMLElement named: #code) addContent: (
			XMLStringNode string: (String streamContents: [:out |script class fileOutOn: out]))).
	^ self writeAsXmlPositionTo: node.
]
