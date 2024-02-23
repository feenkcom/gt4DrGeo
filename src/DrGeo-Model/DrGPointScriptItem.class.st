"
A DrGPointByScriptItem is definied by the returned value of a script.
The script valueItem should understand asPoint.

Instance Variables

"
Class {
	#name : #DrGPointScriptItem,
	#superclass : #DrGPointCoordinateItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGPointScriptItem >> nodeType [
	^#Script
]

{ #category : #updating }
DrGPointScriptItem >> update [
	self doParentsExist ifTrue:
		[self point: parents first valueItem asPoint]. 

]
