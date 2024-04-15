"
Angle bisector given three points
"
Class {
	#name : #DrGAngleBisector3ptsItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGAngleBisector3ptsItem >> adaptiveDescriptiveName [
	^ 'This angle bisector %1' translated
]

{ #category : #'xml writing' }
DrGAngleBisector3ptsItem >> nodeType [
	^#'angleBisector3pts'
]

{ #category : #comparing }
DrGAngleBisector3ptsItem >> parentsEqual: aMathItem [ 
	^ parents = aMathItem parents
		or: [parents reverse = aMathItem parents]
]

{ #category : #updating }
DrGAngleBisector3ptsItem >> update [
	self doParentsExist ifTrue: [
		| v1 v2 |
		self origin: parents second point.
		((parents first point = origin) or: [parents third point = origin]) ifTrue: [^ exist := false].
		[ v1 := (parents first point - origin) normalized ] on: ZeroDivide do: [ v1 := 0 @ 0 ].
		[ v2 := (parents third point - origin) normalized ] on: ZeroDivide do: [ v2 := 0 @ 0 ].
		self direction:  v1 + v2.
		self direction = (0@0) ifTrue: [exist := false]]
]
