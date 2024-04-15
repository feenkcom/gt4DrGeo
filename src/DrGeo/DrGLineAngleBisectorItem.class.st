"
Angle bisector given an angle defined by three points
"
Class {
	#name : #DrGLineAngleBisectorItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGLineAngleBisectorItem >> adaptiveDescriptiveName [
	^ 'This angle bisector %1' translated
]

{ #category : #'xml writing' }
DrGLineAngleBisectorItem >> nodeType [ 
	^ #angleBisector
]

{ #category : #updating }
DrGLineAngleBisectorItem >> update [
	self doParentsExist ifTrue: [
		| angle v1 v2 |
		angle := parents first.
		self origin: angle summit point.
		[ v1 := (angle side1 point - origin) normalized ] on: ZeroDivide do: [ v1 := 0 @ 0 ].
		[ v2 := (angle side2 point - origin) normalized ] on: ZeroDivide do: [ v2 := 0 @ 0 ].
		self direction: v1+ v2.
		self direction = (0@0) ifTrue: [exist := false]]
]
