"
Define an oriented angle, in the range ]-180 ; 180]
"
Class {
	#name : #DrGAngleVectorsItem,
	#superclass : #DrGAngleItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGAngleVectorsItem >> nodeType [
	^ #vectors
]

{ #category : #updating }
DrGAngleVectorsItem >> update [
|u v|
	self doParentsExist ifTrue:
		[u := parents first direction.
		v := parents second direction.
		(u = (0@0) or: [v = (0@0)]) 
			ifTrue: [exist := false]
			ifFalse:
				[radianValue := value := ((u crossProduct: v) asFloat arcTan: (u dotProduct: v)).
				degreeValue := radianValue radiansToDegrees]].	
]

{ #category : #'xml writing' }
DrGAngleVectorsItem >> writeAsXmlPositionTo: aNode [ 
	"return the newly created element"
	aNode
		addElement: ((XMLElement named: #x)
				addContent: (XMLStringNode string: position x asString));
		addElement: ((XMLElement named: #y)
				addContent: (XMLStringNode string: position y asString)).
	^ aNode
]

{ #category : #'xml writing' }
DrGAngleVectorsItem >> writeAsXmlTo: aNode [ 
	"return the newly created element"
	| node |
	node := super writeAsXmlTo: aNode.
	^ self writeAsXmlPositionTo: node.
]
