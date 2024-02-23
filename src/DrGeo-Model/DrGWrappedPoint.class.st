Class {
	#name : #DrGWrappedPoint,
	#superclass : #DrGWrappedItem,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #accessing }
DrGWrappedPoint >> coordinates [
	^ self mathItem point
]

{ #category : #updating }
DrGWrappedPoint >> cross [
	self style shape: #cross
]

{ #category : #updating }
DrGWrappedPoint >> large [
	self style pointSize: #large
]

{ #category : #updating }
DrGWrappedPoint >> medium [
	self style pointSize: #medium
]

{ #category : #updating }
DrGWrappedPoint >> moveTo: aPoint [
	self mathItem moveTo: aPoint    
]

{ #category : #updating }
DrGWrappedPoint >> round [
	self style shape: #round
]

{ #category : #updating }
DrGWrappedPoint >> small [
	self style pointSize: #small
]

{ #category : #updating }
DrGWrappedPoint >> square [
	self style shape: #square
]

{ #category : #accessing }
DrGWrappedPoint >> x [
	^ self coordinates x
]

{ #category : #accessing }
DrGWrappedPoint >> y [
	^ self coordinates y
]
