Class {
	#name : #DrGValueDistance2ptsItem,
	#superclass : #DrGComputedValueItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #private }
DrGValueDistance2ptsItem >> adaptiveDescriptiveName [
	^ 'This distance between two points %1' translated
]

{ #category : #accessing }
DrGValueDistance2ptsItem >> name [
"When my name is empty, I try to deduce a name from my parent's names if any"
	^ name isEmptyOrNil 
		ifTrue: [
			(parents first name isEmptyOrNil or: [ parents second name isEmptyOrNil])
				ifFalse: [parents first name, parents second name]
				ifTrue: [name]]
		ifFalse: [name]

]

{ #category : #'xml writing' }
DrGValueDistance2ptsItem >> nodeType [
	^#'distance_2pts'
]

{ #category : #updating }
DrGValueDistance2ptsItem >> update [
	self doParentsExist ifTrue:
		[value := parents first point dist: parents second point].

]
