Class {
	#name : #DrGComputedValueItem,
	#superclass : #DrGValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'initialize-release' }
DrGComputedValueItem >> initialize [
	super initialize.
	value := ''
]

{ #category : #'xml writing' }
DrGComputedValueItem >> writeAsXmlTo: aNode [ 
	"return the newly created element"
	| node |
	node := super writeAsXmlTo: aNode.
	^ self writeAsXmlPositionTo: node.
]
