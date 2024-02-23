"
Point item defined by a block closure
"
Class {
	#name : #DrGPointBlockItem,
	#superclass : #DrGPointCoordinateItem,
	#instVars : [
		'pointBlock'
	],
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGPointBlockItem >> = aMathItem [
	^ super = aMathItem and: [ pointBlock = aMathItem pointBlock ]
]

{ #category : #testing }
DrGPointBlockItem >> doParentsExist [ 
	^ super doParentsExist and: [pointBlock isNil not]

]

{ #category : #'xml writing' }
DrGPointBlockItem >> nodeType [
	^#Block
]

{ #category : #accessing }
DrGPointBlockItem >> parents: aCollection [
	aCollection isEmptyOrNil ifTrue: [
		parents := aCollection.
		^ self].
	aCollection first isBlock 
		ifTrue: [
			self pointBlock: aCollection first.
			parents := aCollection allButFirst]
		ifFalse: [parents := aCollection].

]

{ #category : #accessing }
DrGPointBlockItem >> pointBlock [
	^ pointBlock 
]

{ #category : #accessing }
DrGPointBlockItem >> pointBlock: aBlock [
	pointBlock := aBlock 
]

{ #category : #comparing }
DrGPointBlockItem >> rehash [
	^ hash := super rehash bitXor: pointBlock hash
]

{ #category : #updating }
DrGPointBlockItem >> update [
| result |
	self doParentsExist ifTrue:
		[parents  
			ifEmpty: [result := [ pointBlock value ] on: Error do: [exist := false]]
			ifNotEmpty: [
				parents size = 1
				ifTrue: [result := [ pointBlock value: parents first ] on: Error do: [exist := false]]
				ifFalse: [result := [pointBlock value: parents] on: Error do: [exist := false]]
			].
	exist ifTrue: [ self point: result ].
	]
]

{ #category : #'xml writing' }
DrGPointBlockItem >> writeAsXmlTo: aNode [
	|node|
	node := super writeAsXmlTo: aNode.
	node addElement: ((XMLElement named: #code) addContent: (XMLStringNode string: pointBlock asString)).
	^node
]
