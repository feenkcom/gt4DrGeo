Class {
	#name : #DrGPolygonNptsItem,
	#superclass : #DrGPolygonItem,
	#category : #'DrGeo-Model-Item'
}

{ #category : #'xml writing' }
DrGPolygonNptsItem >> nodeType [
	^ #npts
]

{ #category : #comparing }
DrGPolygonNptsItem >> parentsEqual: aPolygon [
	|shiftedCollection|
	parents size = aPolygon parents size ifFalse: [^false].
	shiftedCollection := parents.
	shiftedCollection size timesRepeat: [
		shiftedCollection = aPolygon parents ifTrue: [^true].
		shiftedCollection := shiftedCollection shiftRight].
	shiftedCollection := parents reverse.
	shiftedCollection size timesRepeat: [
		shiftedCollection = aPolygon parents ifTrue: [^true].
		shiftedCollection := shiftedCollection shiftRight].
	^ false
]

{ #category : #updating }
DrGPolygonNptsItem >> update [
	self doParentsExist ifTrue: [
		points := OrderedCollection new.
		parents do: [:pointItem | points add: pointItem point].
		self computeLength].

]
