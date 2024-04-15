Class {
	#name : #DrGCommandStack,
	#superclass : #ReadWriteStream,
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'instance creation' }
DrGCommandStack class >> new [
	^self on: Array new
]

{ #category : #accessing }
DrGCommandStack >> nextPut: aCommand [
	super nextPut: aCommand.
	self truncate.
	^ aCommand 
]

{ #category : #accessing }
DrGCommandStack >> previous [
	self position = 0 ifTrue: [^nil].
	self position: self position - 1.
	^self peek.
]

{ #category : #private }
DrGCommandStack >> truncate [
	|oldReadLimit|
	oldReadLimit := readLimit.
	readLimit := position.
	oldReadLimit > readLimit ifTrue:
			[readLimit to: oldReadLimit do:
				[:index| collection at: index + 1 put: nil]]
]
