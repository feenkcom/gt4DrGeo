"
I wrap an object and just log all the messages sent to it.

NB: I inherit from ProtoObject so I have few methods of my own. 
The few instance messages start with `dg` to minimize the chance of a name conflict.
(This may break some things.)
"
Class {
	#name : #DGLogger,
	#superclass : #ProtoObject,
	#instVars : [
		'messages',
		'dgItem',
		'dgMessages'
	],
	#category : #'Gt4DrGeo-Utility'
}

{ #category : #'*Gt4DrGeo' }
DGLogger class >> for: anObject [
^ self new
	dgItem: anObject
]

{ #category : #accessing }
DGLogger >> dgItem [
	^ dgItem
]

{ #category : #accessing }
DGLogger >> dgItem: anObject [
	dgItem := anObject.
	^ self
]

{ #category : #accessing }
DGLogger >> dgMessages [
	^ dgMessages
]

{ #category : #accessing }
DGLogger >> doesNotUnderstand: aMessage [
	self dgMessages addLast: aMessage
]

{ #category : #accessing }
DGLogger >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 20;
		items: [ self dgMessages ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Message send'
			text: [ :item | item printString ]
			width: 100;
		actionUpdateButton
]

{ #category : #accessing }
DGLogger >> gtSummaryFor: aView [
	<gtView>
	^ aView forward
		title: 'Summary';
		priority: 10;
		object: [ self dgItem ];
		view: #gtSummaryFor:;
		actionUpdateButton
]

{ #category : #accessing }
DGLogger >> initialize [
	dgMessages := OrderedCollection new
]
