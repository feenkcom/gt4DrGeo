"
A DrGPointByScriptItem is definied by the returned value of a script.
The script valueItem should understand asPoint.

Instance Variables

"
Class {
	#name : #DrGPointScriptItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'testing-model' }
DrGPointScriptItem >> isConstrainedPointItem [
	^ true
]

{ #category : #'xml writing' }
DrGPointScriptItem >> nodeType [
	^#Script
]

{ #category : #updating }
DrGPointScriptItem >> update [
	self doParentsExist ifTrue:
		[self point: parents first valueItem asPoint]. 

]
