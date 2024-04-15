Class {
	#name : #DrGSegment2ptsItem,
	#superclass : #DrGSegmentItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGSegment2ptsItem >> nodeType [
	^#'2pts'
]

{ #category : #comparing }
DrGSegment2ptsItem >> parentsEqual: aMathItem [
	((parents first = aMathItem parents first) and: [parents second = aMathItem parents second]) 
		ifTrue: [^true].
	((parents first = aMathItem parents second) and: [parents second = aMathItem parents first]) 
		ifTrue: [^true].
	^ false

]

{ #category : #comparing }
DrGSegment2ptsItem >> rehash [
	^ hash := ((parents sorted: [:ptA :ptB | ptA point <= ptB point]) hash bitXor: self nodeType hash) bitXor: self basicType hash
]
