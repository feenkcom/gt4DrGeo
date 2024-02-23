"
A DrGMacroNode is a node in a macro-construction. It represents an abstracted math item in the macro-construction tree.

Instance Variables

"
Class {
	#name : #DrGMacroInputNode,
	#superclass : #DrGMacroNode,
	#category : #'DrGeo-Model-Macro'
}

{ #category : #comparing }
DrGMacroInputNode >> = aNode [
"this is what we expect for input item of the macro"
	^ self basicType = aNode basicType 
		and: [itemTemplate basicType = aNode itemTemplate basicType]
		
]

{ #category : #accessing }
DrGMacroInputNode >> basicType [
	^#inputMacroNode
]

{ #category : #comparing }
DrGMacroInputNode >> hash [
	^ itemTemplate basicType hash bitXor: self basicType hash
]

{ #category : #testing }
DrGMacroInputNode >> isInputNode [
	^true
]
