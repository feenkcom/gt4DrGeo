Class {
	#name : #DGLoggerExamples,
	#superclass : #Object,
	#category : #'Gt4DrGeo-Examples'
}

{ #category : #example }
DGLoggerExamples >> logger [
	<gtExample>
	| logger |
	logger := DGLogger for: Morph new.
	self assert: logger dgMessages isEmpty.
	^ logger
]

{ #category : #example }
DGLoggerExamples >> morphWith2Messages [
	<gtExample>
	| logger |
	logger := self logger.
	logger repaint.
	logger moveTo: 10 @ 10.
	self assert: logger dgMessages size equals: 2.
	self assert: logger dgMessages first selector equals: #repaint.
	self assert: logger dgMessages second selector equals: #moveTo:.
	^ logger
]
