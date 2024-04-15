Class {
	#name : #DrGWrappedCurve,
	#superclass : #DrGWrappedItem,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #updating }
DrGWrappedCurve >> dashed [
	self style lineStyle: #dash


]

{ #category : #updating }
DrGWrappedCurve >> dotted [
	self style lineStyle: #dot
]

{ #category : #updating }
DrGWrappedCurve >> large [
	self style thickness: #large
]

{ #category : #updating }
DrGWrappedCurve >> normal [
	self style thickness: #medium
]

{ #category : #updating }
DrGWrappedCurve >> plain [
	self style lineStyle: #plain

]

{ #category : #updating }
DrGWrappedCurve >> small [
	self style thickness: #small
]
