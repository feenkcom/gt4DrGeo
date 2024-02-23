"
Perpendicular bisector given two points, extremities of a segment
"
Class {
	#name : #DrGLinePerpendicularBisector2ptsItem,
	#superclass : #DrGPerpendicularBisectorItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGLinePerpendicularBisector2ptsItem >> adaptiveDescriptiveName [
	^ 'This perpendicular bisector %1' translated
]

{ #category : #comparing }
DrGLinePerpendicularBisector2ptsItem >> equalOtherNodeType: aMathItem [ 
	^ aMathItem
		ifNil: [false]
		ifNotNil: [self basicType = aMathItem basicType
			and: [aMathItem nodeType = #perpendicularBisectorSegment
				and: [(aMathItem parents first extremity1 = parents first point
						and: [aMathItem parents first extremity2 = parents second point])
					or: [aMathItem parents first extremity1 = parents second point
						and: [aMathItem parents first extremity2 = parents first point]]]]]
]

{ #category : #'xml writing' }
DrGLinePerpendicularBisector2ptsItem >> nodeType [
	^#'perpendicularBisector2pts'
]

{ #category : #comparing }
DrGLinePerpendicularBisector2ptsItem >> parentsEqual: aMathItem [
"	^ self parents asSet = aMathItem parents asSet"
	((parents first = aMathItem parents first) and: [parents second = aMathItem parents second]) 
		ifTrue: [^true].
	((parents first = aMathItem parents second) and: [parents second = aMathItem parents first]) 
		ifTrue: [^true].
	^ false

]

{ #category : #updating }
DrGLinePerpendicularBisector2ptsItem >> update [
	self doParentsExist ifTrue: [ 
		(parents first point = parents second point) 
			ifFalse: [
				self direction: (parents first point - parents second point) normal.
				self origin: parents first point + parents second point / 2]
			ifTrue: [exist := false]
		]
]
