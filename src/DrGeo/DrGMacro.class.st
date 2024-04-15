"
A DrGMacro is a macro-construction definition

Instance Variables
	nodes:		<Object>

nodes
	- xxxxx

"
Class {
	#name : #DrGMacro,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'title',
		'description',
		'saved'
	],
	#category : #'DrGeo-Model-Macro'
}

{ #category : #testing }
DrGMacro class >> isValidWith: inputs and: outputs [
	"check the validity of a macro defined with these input and output items"

	| parents |
	parents := Set new.
	outputs
		do: [ :item | 
			(inputs includes: item)
				ifTrue:
					[ "item is an input, we don't go to parents, we keep it" parents add: item ]
				ifFalse:
					[ "item isn't an input, we go to its parents" item parents ifNotNil: [ parents addAll: item parents ] ] ].
	parents isEmpty
		ifTrue: [ ^ false ].
	(inputs includesAllOf: parents)
		ifTrue: [ ^ true ].
	^ self isValidWith: inputs and: parents
]

{ #category : #comparing }
DrGMacro >> = aMacro [
	^ nodes size = aMacro nodes size 
		and: 
			[nodes with: aMacro nodes do: [:n1 :n2 |
				n1 = n2 ifFalse: [^false]].
			true]
]

{ #category : #accessing }
DrGMacro >> addNode: aNode [
	nodes add: aNode
]

{ #category : #accessing }
DrGMacro >> allButInputNodes [
	^ nodes reject: [:node | node isInputNode]
]

{ #category : #private }
DrGMacro >> cleanNodes [
	nodes do: [ :node | 
		node itemTemplate: 
			((node itemTemplate copy) 
				parents: nil;
				yourself).
		node itemTemplate releaseActionMap.]
]

{ #category : #accessing }
DrGMacro >> constructedNodes [
	^ nodes select: [:node | node isInputNode not]
]

{ #category : #accessing }
DrGMacro >> description [
	^ description
]

{ #category : #accessing }
DrGMacro >> description: anObject [
	description := anObject. 
	self saved: false.
]

{ #category : #accessing }
DrGMacro >> detectId: anId [
	^ nodes detect: [:node | node isId: anId]
]

{ #category : #'as yet unclassified' }
DrGMacro >> execute: inputs in: presenter [
	self cleanNodes.
	self inputNodes 
		with: inputs
		do: [ :node :item | node itemTemplate: item ].
	self allButInputNodes do: [:node | 
		node itemTemplate 
			parents: (node parentNodes collect: [:aNode | aNode itemTemplate])
			in: presenter .
		node itemTemplate update; rehash.].
	^ self constructedNodes collect: [ :n | n itemTemplate ]
]

{ #category : #private }
DrGMacro >> extractItemsFrom: inputs to: outputs in: domain [
	"extract the items to define the whole macro structure"

	| items parents tmp |
	items := (Set withAll: inputs)
		addAll: outputs;
		yourself.
	parents := outputs.
	[ (inputs includesAllOf: parents) | parents isEmpty ]
		whileFalse: [ tmp := parents.
			parents := Set new.
			tmp
				do: [ :item | item parents ifNotNil: [ parents addAll: item parents ] ].
			items addAll: parents ].
	^ domain factory ordered: items
]

{ #category : #'initialize-release' }
DrGMacro >> from: inputs to: outputs in: domain [ 
	"build the tree nodes"
	| items |
	items := self 
		extractItemsFrom: inputs
		to: outputs
		in: domain.
	nodes := items collect: 
		[ :item | 
		DrGMacroNode 
			on: item
			from: inputs
			to: outputs ].
	self updateParentNodes.
	self cleanNodes
]

{ #category : #comparing }
DrGMacro >> hash [
	^nodes hash
]

{ #category : #accessing }
DrGMacro >> hiddenNodes [
	^ nodes select: [:node | node isHiddenNode]
]

{ #category : #'initialize-release' }
DrGMacro >> initialize [ 
	nodes := OrderedCollection new.
	saved := false
]

{ #category : #accessing }
DrGMacro >> inputBasicType [
"The basic type of the input parameters"
	^self inputNodes collect: [:n | n itemTemplate basicType]
]

{ #category : #accessing }
DrGMacro >> inputNodes [
	^ nodes select: [:node | node isInputNode]
]

{ #category : #testing }
DrGMacro >> isSaved [
	^ saved
]

{ #category : #private }
DrGMacro >> itemToNode: item [
	^ nodes detect: [:node |node itemTemplate = item]
]

{ #category : #accessing }
DrGMacro >> nodes [
	^nodes
]

{ #category : #accessing }
DrGMacro >> outputNodes [
	^ nodes select: [:node | node isOutputNode]
]

{ #category : #'initialize-release' }
DrGMacro >> release [
]

{ #category : #accessing }
DrGMacro >> saved: bool [
	saved := bool.
]

{ #category : #accessing }
DrGMacro >> title [
	^ title
]

{ #category : #accessing }
DrGMacro >> title: anObject [
	title := anObject
]

{ #category : #private }
DrGMacro >> updateParentNodes [
	nodes do: 
		[ :node | 
		node isInputNode | node itemTemplate parents isNil ifFalse: 
			[ node parentNodes: (node itemTemplate parents collect: [ :item | self itemToNode: item ]) ] ]
]

{ #category : #'xml writting' }
DrGMacro >> writeAsXmlTo: aNode [
	| node |
	self saved: true.
	self cleanNodes.
	node := XMLElement named: 'macro' attributes: Dictionary new.
	node attributeAt: #name put: title asString.
	node addElement: ((XMLElement named: #description) addContent: (XMLStringNode string: description asString)).
	node 
		addElement: self writeInputAsXml;
		addElement: self writeOutputAsXml.
	aNode addElement: node.
	^node
		
]

{ #category : #'xml writting' }
DrGMacro >> writeInputAsXml [
	| element |
	element := XMLElement named: 'input'.
	self inputNodes do: [:aMacroNode | aMacroNode writeAsXmlTo: element].
	^ element 
]

{ #category : #'xml writting' }
DrGMacro >> writeOutputAsXml [
	| element |
	element := XMLElement named: 'output'.
	self allButInputNodes do: [:aMacroNode | aMacroNode writeAsXmlTo: element].
	^ element 

]
