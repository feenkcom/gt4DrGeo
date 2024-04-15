Extension { #name : #LinkedList }

{ #category : #'*DrGeo-Link' }
LinkedList >> add: aLink after: otherLink [
	"Add otherLink  after link in the list. Answer aLink."
	| savedLink |
	lastLink == otherLink ifTrue: [^ self addLast: aLink].
	savedLink := otherLink nextLink.
	otherLink nextLink: aLink.
	aLink nextLink:  savedLink.
	^aLink.
]
