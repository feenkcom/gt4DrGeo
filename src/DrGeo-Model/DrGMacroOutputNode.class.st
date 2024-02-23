Class {
	#name : #DrGMacroOutputNode,
	#superclass : #DrGMacroHiddenNode,
	#category : #'DrGeo-Model-Macro'
}

{ #category : #accessing }
DrGMacroOutputNode >> basicType [
	^#outputMacroNode
]

{ #category : #testing }
DrGMacroOutputNode >> isHiddenNode [
	^false
]

{ #category : #testing }
DrGMacroOutputNode >> isOutputNode [
	^true
]

{ #category : #'xml writting' }
DrGMacroOutputNode >> statusElement [
	^ XMLElement named: 'final'.

]
