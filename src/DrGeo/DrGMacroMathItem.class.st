"
A class to represent input math item template when reloading from a XML representation.
"
Class {
	#name : #DrGMacroMathItem,
	#superclass : #Object,
	#instVars : [
		'basicType',
		'id'
	],
	#category : #'DrGeo-Model-Macro'
}

{ #category : #accessing }
DrGMacroMathItem >> basicType [ 
	^ basicType 
]

{ #category : #accessing }
DrGMacroMathItem >> basicType: symbol [
	basicType := symbol 
]

{ #category : #accessing }
DrGMacroMathItem >> id [ 
	^ id
]

{ #category : #accessing }
DrGMacroMathItem >> id: aSymbol [
	id := aSymbol 
]

{ #category : #accessing }
DrGMacroMathItem >> parents [
	^ #()
]

{ #category : #accessing }
DrGMacroMathItem >> parents: object [

]

{ #category : #'xml writing' }
DrGMacroMathItem >> writeAsXmlTo: aNode [
	"return the newly created element"
	| node |
	node :=  XMLElement named: self basicType attributes: Dictionary new.
	node attributeAt: #type put: 'inputMacroMathItem';
		attributeAt: #id put: self id.
	aNode addElement: node.
	^node
]
