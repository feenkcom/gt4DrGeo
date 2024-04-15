"
See superclass comments.
This factory interface in extended to handle mathItem specific action
"
Class {
	#name : #DrGMathItemFactory,
	#superclass : #DrGFactory,
	#category : #'DrGeo-Factories'
}

{ #category : #accessing }
DrGMathItemFactory >> childrenOf: mathItemIndex [
	|children directChildren|
	directChildren := OrderedCollection withAll: (self directChildrenOf: mathItemIndex).
	children := Set new addAll: directChildren; yourself.
	directChildren do: [:childIndex | children addAll: (self childrenOf: childIndex)].
	^ children
]

{ #category : #accessing }
DrGMathItemFactory >> dependentMathItem: theMathItem [ 
	"Return a collection of the dependents items of theMathItem, 
	Caution: it is not following the creation order, further traitment is need for that"
	^ self dependentMathItem: theMathItem in: (self subPool: theMathItem )
]

{ #category : #accessing }
DrGMathItemFactory >> dependentMathItem: dependentItem in: subPool [
	"Return a collection of the dependents items of theMathItem in a subpool"
	| dependents |
	dependents := IdentitySet with: dependentItem.
	subPool do: [:aMathItem |
		(aMathItem parentsIncludes: dependentItem) ifTrue: 
			[dependents addAll: 
				(self dependentMathItem: aMathItem in: (self subPool: aMathItem from: subPool))]].
	^ dependents
]

{ #category : #accessing }
DrGMathItemFactory >> directChildrenOf: parent [
"return the collection of my direct child"
	^ pool select: [:item| | parents|
		parents := item parents.
		parents notNil and: [(parents anySatisfy: [:aParent | aParent = parent])]].

]

{ #category : #accessing }
DrGMathItemFactory >> findInPoolById: anID [
"Try to find an item given its unique ID, it used to load Dr. Geo 1.1 file"
	^ pool detect: [:each | each id = anID ]
	
]

{ #category : #testing }
DrGMathItemFactory >> is: item parentWithTest: testSelector [
	self from: item do: [:aChild |
		((aChild perform: testSelector)
			and: [aChild parents includes: item]) ifTrue: [^ true]].
	^ false
]

{ #category : #accessing }
DrGMathItemFactory >> moveableParentsOf: theMathItem in: parents [
	"Return a collection of the parents items of theMathItem, sensidble to reverse dragging
	Caution: we may have duplicated item"
	| safeParents areParentsMoveable |
	safeParents := theMathItem parents.
	theMathItem parents: #().
	areParentsMoveable := theMathItem moveParent: 0@0.
	theMathItem parents: safeParents.
	areParentsMoveable ifTrue: [
		(parents addAll: safeParents) do: [:aParent |
			self moveableParentsOf: aParent in: parents]].

]

{ #category : #accessing }
DrGMathItemFactory >> ordered: aMathItemCollection [
"sort the the math item according to the pool order"
	^ pool select: [:item | aMathItemCollection includes: item]
]

{ #category : #accessing }
DrGMathItemFactory >> orderedDependentMathItem: aMathItem [
	^self ordered: (self dependentMathItem: aMathItem )
]

{ #category : #updating }
DrGMathItemFactory >> rehash [
	pool do: [:mathIten | mathIten rehash]
]

{ #category : #updating }
DrGMathItemFactory >> updateAllMathItems [
	"stupidly update all math item"
	pool
		do: [:aMathItem | aMathItem update]
]

{ #category : #updating }
DrGMathItemFactory >> updateAllMathItemsButLocus [
	"stupidly update all math item but the loci ones"
	pool
		do: [:aMathItem | aMathItem isLocusItem not ifTrue: [ aMathItem update]]
]

{ #category : #updating }
DrGMathItemFactory >> updateAllMathItemsButLocusFrom: startIndex to: endIndex [ 
	"stupidly update math item in the given range"
	pool
		from: startIndex
		to: endIndex
		do: [:aMathItem | aMathItem isLocusItem not
				ifTrue: [aMathItem update]]
]
