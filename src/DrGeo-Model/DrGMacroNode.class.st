Class {
	#name : #DrGMacroNode,
	#superclass : #Object,
	#instVars : [
		'itemTemplate'
	],
	#category : #'DrGeo-Model-Macro'
}

{ #category : #'as yet unclassified' }
DrGMacroNode class >> on: item from: inputs to: outputs [
"return the appropriate nodes depending on the item is an input, output or intermediate item"
	| class |
	class := DrGMacroHiddenNode.
	(inputs includes: item) ifTrue: [class := DrGMacroInputNode].
	(outputs includes: item) ifTrue: [class := DrGMacroOutputNode].
	^ class new itemTemplate: item
]

{ #category : #comparing }
DrGMacroNode >> = aNode [
"This is what we expect for input item of the macro.
Handle carrefully when this is a script node"

| answer |
	answer := self basicType = aNode basicType 
		and: [itemTemplate basicType = aNode itemTemplate basicType
			and: [itemTemplate  nodeType = aNode itemTemplate nodeType]].
	^ answer & itemTemplate isScriptItem 
		ifTrue: [itemTemplate script == aNode itemTemplate script]
		ifFalse: [answer]
		
]

{ #category : #accessing }
DrGMacroNode >> basicType [
	^#macroNode
]

{ #category : #comparing }
DrGMacroNode >> hash [
| hash |
	hash := itemTemplate basicType hash bitXor: 
		(itemTemplate nodeType hash bitXor: self basicType hash).
	itemTemplate isScriptItem ifTrue: [hash := hash bitXor: itemTemplate script hash].
	^ hash
]

{ #category : #testing }
DrGMacroNode >> isHiddenNode [
	^false
]

{ #category : #testing }
DrGMacroNode >> isId: anID [
	^ itemTemplate id = anID 
]

{ #category : #testing }
DrGMacroNode >> isInputNode [
	^false
]

{ #category : #testing }
DrGMacroNode >> isOutputNode [
	^false
]

{ #category : #accessing }
DrGMacroNode >> itemTemplate [
	^itemTemplate
]

{ #category : #accessing }
DrGMacroNode >> itemTemplate: anItem [
	itemTemplate := anItem
]

{ #category : #'xml writting' }
DrGMacroNode >> writeAsXmlTo: aNode [
	^ itemTemplate writeAsXmlTo: aNode
]
