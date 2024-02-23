"
Perpendicular bisector given a segment
"
Class {
	#name : #DrGPerpendicularBisectorItem,
	#superclass : #DrGLineItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #comparing }
DrGPerpendicularBisectorItem >> = aMathItem [
	^ aMathItem isMathItem 
		ifFalse: [false]
		ifTrue: [super = aMathItem or: [ self equalOtherNodeType: aMathItem ]]
]

{ #category : #private }
DrGPerpendicularBisectorItem >> adaptiveDescriptiveName [
	^ 'This perpendicular bisector %1' translated
]

{ #category : #comparing }
DrGPerpendicularBisectorItem >> equalOtherNodeType: aMathItem [ 
	^ aMathItem
		ifNil: [false]
		ifNotNil: [self basicType = aMathItem basicType
			and: [aMathItem nodeType = #'perpendicularBisector2pts'
				and: [(parents first extremity1 = aMathItem parents first point
						and: [parents first extremity2 = aMathItem parents second point])
					or: [parents first extremity1 = aMathItem parents second point
						and: [parents first extremity2 = aMathItem parents first point]]]]]
]

{ #category : #'xml writing' }
DrGPerpendicularBisectorItem >> nodeType [
	^ #perpendicularBisector
]

{ #category : #updating }
DrGPerpendicularBisectorItem >> update [
	self doParentsExist ifTrue: [ |segment |
		segment := parents first.
		self direction: segment normal.
		self origin: segment middle]
]
