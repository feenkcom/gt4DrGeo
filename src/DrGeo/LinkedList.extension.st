Extension { #name : #LinkedList }

{ #category : #'*DrGeo-Link' }
LinkedList >> add: aLink afterLink: otherLink [
	"Add otherLink  after link in the list. Answer aLink."
	| savedLink |
	lastLink == otherLink ifTrue: [^ self addLast: aLink].
	savedLink := otherLink nextLink.
	otherLink nextLink: aLink.
	aLink nextLink:  savedLink.
	^aLink.
]

{ #category : #'*DrGeo-Link' }
LinkedList >> linksDo: aBlock [
	| aLink |
	aLink := firstLink.
	[aLink == nil ] whileFalse: 		[
		aBlock value: aLink.
		aLink := aLink nextLink]
]
