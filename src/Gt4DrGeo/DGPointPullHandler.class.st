"
I'm a {{gtClass:BlPullHandler}} that does not listen to CTRL events (so they can be handled by a drag handler for my parent instead).

AS says:

in the future if you see that you have another case when you would like to prevent an existing event handler from handling events based on some condition you can decorate that event handler with an event handler decorator that checks the condition and then forwards the event if condition is met. Something like {{gtClass:name=BlEventForwarder}}.
I was originally created as a `HypernodePullHandler` for the IMAD project.

"
Class {
	#name : #DGPointPullHandler,
	#superclass : #BlPullHandler,
	#instVars : [
		'element'
	],
	#category : #'Gt4DrGeo-View'
}

{ #category : #'instance creation' }
DGPointPullHandler class >> for: aHypernodeElement [
	^ self new
		element: aHypernodeElement;
		yourself
]

{ #category : #handling }
DGPointPullHandler >> dragEndEvent: anEvent [
	| newPosition |
	super dragEndEvent: anEvent.
	"anEvent consumed: true."
	newPosition := self element constraints position.
	self element mathItem moveTo: newPosition.
	self element mathItem changed
]

{ #category : #accessing }
DGPointPullHandler >> element [
	^ element
]

{ #category : #accessing }
DGPointPullHandler >> element: anElement [
	self assert: anElement isDGPointElement.
	element := anElement
]

{ #category : #events }
DGPointPullHandler >> wantsEvent: anEvent [
	"I ignore Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl not ]
]
