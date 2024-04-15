Class {
	#name : #DrGPointMiddle2ptsItem,
	#superclass : #DrGPointItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'testing-model' }
DrGPointMiddle2ptsItem >> isConstrainedPointItem [
	^true
]

{ #category : #'xml writing' }
DrGPointMiddle2ptsItem >> nodeType [
	^#'Middle_2pts'
]

{ #category : #comparing }
DrGPointMiddle2ptsItem >> parentsEqual: aMathItem [
	((parents first = aMathItem parents first) and: [parents second = aMathItem parents second]) 
		ifTrue: [^true].
	((parents first = aMathItem parents second) and: [parents second = aMathItem parents first]) 
		ifTrue: [^true].
	^ false

]

{ #category : #comparing }
DrGPointMiddle2ptsItem >> rehash [
	^ hash := ((parents sorted: [:ptA :ptB | ptA point <= ptB point]) hash bitXor: self nodeType hash) bitXor: self basicType hash
]

{ #category : #updating }
DrGPointMiddle2ptsItem >> update [
	self doParentsExist ifTrue:
		[self point: (parents first point + parents second point) / 2.0].

]
