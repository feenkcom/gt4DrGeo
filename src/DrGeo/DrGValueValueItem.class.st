"
Free value
"
Class {
	#name : #DrGValueValueItem,
	#superclass : #DrGValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGValueValueItem >> = aMathItem [
	^super = aMathItem 
		and: [self valueItem = aMathItem valueItem
		and: [self position = aMathItem position]]
]

{ #category : #testing }
DrGValueValueItem >> doParentsExist [
	^ true
]

{ #category : #updating }
DrGValueValueItem >> editPropertyIn: presenter [
	| holder |
	holder := ValueHolder with: value.
	holder action: [:newValue | presenter domain propertyCommandFor: self with: newValue].
	^ FloatEntryPanel open: holder label: 'Edit this value' translated 
]

{ #category : #testing }
DrGValueValueItem >> isPropertyEditable [
	^ true
]

{ #category : #'xml writing' }
DrGValueValueItem >> nodeType [
	^#value
]

{ #category : #accessing }
DrGValueValueItem >> position: aPoint [
	position := aPoint.
	self rehash
]

{ #category : #updating }
DrGValueValueItem >> property [
	^ self valueItem
]

{ #category : #updating }
DrGValueValueItem >> property: aProperty [ 
	self valueItem: aProperty 
]

{ #category : #comparing }
DrGValueValueItem >> rehash [
	^ hash := (super rehash bitXor: position hash) bitXor: value hash
]

{ #category : #accessing }
DrGValueValueItem >> valueItem: aValue [
	value := aValue.
	self rehash
]

{ #category : #'xml writing' }
DrGValueValueItem >> writeAsXmlTo: aNode [ 
	"return the newly created element"
	| node |
	node := super writeAsXmlTo: aNode.
	node addElement:  ((XMLElement named: #value) addContent: (XMLStringNode string: value asFloat asString)).
	^ self writeAsXmlPositionTo: node.
]
