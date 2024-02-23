Class {
	#name : #DrGMacroHiddenNode,
	#superclass : #DrGMacroNode,
	#instVars : [
		'parentNodes'
	],
	#category : #'DrGeo-Model-Macro'
}

{ #category : #comparing }
DrGMacroHiddenNode >> = aNode [
	^ super = aNode and:
		[parentNodes = aNode parentNodes]
]

{ #category : #accessing }
DrGMacroHiddenNode >> basicType [
	^#hiddenMacroNode
]

{ #category : #comparing }
DrGMacroHiddenNode >> hash [
	^(super hash) bitXor: parentNodes hash
]

{ #category : #'initialize-release' }
DrGMacroHiddenNode >> initialize [ 
	super initialize.
	parentNodes := OrderedCollection new.
]

{ #category : #testing }
DrGMacroHiddenNode >> isHiddenNode [
	^true
]

{ #category : #accessing }
DrGMacroHiddenNode >> parentNodes [
	^ parentNodes
]

{ #category : #accessing }
DrGMacroHiddenNode >> parentNodes: anObject [
	parentNodes := anObject
]

{ #category : #'xml writting' }
DrGMacroHiddenNode >> statusElement [
	^ XMLElement named: 'hidden'.

]

{ #category : #'xml writting' }
DrGMacroHiddenNode >> writeAsXmlTo: aNode [
	| element statusElement|
	statusElement := self statusElement.
	aNode addElement: statusElement.
	itemTemplate parents: (parentNodes collect: [:each | each itemTemplate]).
	element := itemTemplate writeAsXmlTo: statusElement.
	^ statusElement 
]
