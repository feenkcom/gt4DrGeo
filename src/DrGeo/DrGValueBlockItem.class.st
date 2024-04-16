"
Value defined by a block closure
"
Class {
	#name : #DrGValueBlockItem,
	#superclass : #DrGComputedValueItem,
	#instVars : [
		'valueBlock'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGValueBlockItem >> = aMathItem [
	^ super = aMathItem and: [ valueBlock = aMathItem valueBlock ]
]

{ #category : #testing }
DrGValueBlockItem >> doParentsExist [ 
	^ exist := super doParentsExist and: [valueBlock isNil not]

]

{ #category : #'xml writing' }
DrGValueBlockItem >> nodeType [
	^#Block
]

{ #category : #accessing }
DrGValueBlockItem >> parents: aCollection [
" First the parents if any, then the bloc of code and last is the position on screen "
	aCollection isEmptyOrNil ifTrue: [ " Should not happen "
		parents := aCollection.
		self valueBlock: [].
		^ self].
	parents := aCollection allButLast: 2.
	self valueBlock: (aCollection atWrap: -1).

]

{ #category : #comparing }
DrGValueBlockItem >> rehash [
	^ hash := super rehash bitXor: valueBlock hash
]

{ #category : #updating }
DrGValueBlockItem >> update [
| result |
	self doParentsExist ifTrue:
		[parents  
			ifEmpty: [result := [ valueBlock value ] on: Error do: [exist := false]]
			ifNotEmpty: [
				parents size = 1
				ifTrue: [result := [ valueBlock value: parents first ] on: Error do: [exist := false]]
				ifFalse: [result := [valueBlock value: parents] on: Error do: [exist := false]]
			].
	exist ifTrue: [ value := result ]
	]
]

{ #category : #accessing }
DrGValueBlockItem >> valueBlock [
	^ valueBlock
]

{ #category : #accessing }
DrGValueBlockItem >> valueBlock: aBlock [
	valueBlock := aBlock 
]

{ #category : #'xml writing' }
DrGValueBlockItem >> writeAsXmlTo: aNode [
	|node|
	node := super writeAsXmlTo: aNode.
	node addElement: ((XMLElement named: #code) addContent: (XMLStringNode string: valueBlock decompile asString)).
	^node
]
