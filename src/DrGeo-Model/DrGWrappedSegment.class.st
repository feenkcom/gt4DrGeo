Class {
	#name : #DrGWrappedSegment,
	#superclass : #DrGWrappedFinitCurve,
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #updating }
DrGWrappedSegment >> circleMark [
	self style mark: #circle
]

{ #category : #updating }
DrGWrappedSegment >> discMark [
	self style mark: #disc
]

{ #category : #updating }
DrGWrappedSegment >> doubleMark [
	self style mark: #mark2
]

{ #category : #updating }
DrGWrappedSegment >> noMark [
	self style mark: #none
]

{ #category : #updating }
DrGWrappedSegment >> simpleMark [
	self style mark: #mark1
]

{ #category : #updating }
DrGWrappedSegment >> tripleMark [
	self style mark: #mark3
]
