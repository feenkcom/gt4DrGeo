"
The Factory is where are manufactured new mathematic or macro-constrcution items.
It owns a pool of the already manufactured items. 
In last is the latested created (or recreated) item, 
Carefull! last may not be equal to 'pool last' when the user try
to instantiate an already created object, in this case last returns 
the original copy somewhere in the pool.

When manufacturing a new item it checks for its unicity.
It works with the help of the MathItem and macro Builder.
Related patterns: flyweight.
"
Class {
	#name : #DrGFactory,
	#superclass : #Object,
	#instVars : [
		'pool',
		'last'
	],
	#category : #'DrGeo-Factories'
}

{ #category : #accessing }
DrGFactory >> add: item [ 
	self last: item.
	pool addLast: item.
	^ item
]

{ #category : #accessing }
DrGFactory >> add: anObject beforeIndex: index [
	^ pool add: anObject beforeIndex: index
]

{ #category : #accessing }
DrGFactory >> at: integer [
	^ self pool at: integer ifAbsent: [nil]
]

{ #category : #accessing }
DrGFactory >> findInPool: item [ 
	"Try to find a twin of this mathItem, if so return the twin, otherwise nil"
	^ self at: (self indexOf: item)
]

{ #category : #enumerating }
DrGFactory >> from: item do: aBlock [
	(self indexOf: item) 
		to: pool size 
		do: [:index | aBlock value: (pool at: index)]
]

{ #category : #accessing }
DrGFactory >> indexOf: anItem [
 ^ self indexOf: anItem in: pool
]

{ #category : #accessing }
DrGFactory >> indexOf: anItem in: aPool [
"No identity equality but hashed value to detect duplicated object we must consider as equal"
 ^ anItem 
		ifNil: [0]
		ifNotNil: [aPool findFirst: [ :each | 
				each hash = anItem hash  
					and: ["double check when hash is equal (can be a collision)"
						 each = anItem ]  
			]
		]
]

{ #category : #'initialize-release' }
DrGFactory >> initialize [
	super initialize.
	pool := OrderedCollection new.

]

{ #category : #testing }
DrGFactory >> is: item1 before: item2 [
	^ (self indexOf: item1) < (self indexOf: item2)
]

{ #category : #testing }
DrGFactory >> isAnyInPool: itemList [ 
	^itemList anySatisfy: [:item | (self findInPool: item) isNil not].
]

{ #category : #testing }
DrGFactory >> isInPool: item [
	^ (self findInPool: item) isNil not
]

{ #category : #accessing }
DrGFactory >> last [
	^last
]

{ #category : #accessing }
DrGFactory >> last: item [ 
	"push item as the last instantiated item in the pool, purelly artificial however
	as the items order in the pool is not changed"
	last := item
]

{ #category : #accessing }
DrGFactory >> pool [
	^pool 
]

{ #category : #removing }
DrGFactory >> purge [
	pool do: [ :aMathItem | aMathItem release].
	pool := OrderedCollection new.
	self changed: #pool
]

{ #category : #updating }
DrGFactory >> pushAsLastWhenInPool: anItem [
	"if this item has a twin in the pool, push as last this last one and
return true, otherwise return false"

	^ (self findInPool: anItem)
		ifNotNil: [ :item | 
			self last: item.
			true ]
		ifNil: [ false ]
]

{ #category : #'initialize-release' }
DrGFactory >> release [
	pool do: [ :item | item release].
]

{ #category : #removing }
DrGFactory >> remove: itemCollection [ 
	pool := pool copyWithoutAll: itemCollection.
	itemCollection do: [ :aMathItem | aMathItem release ].
	self flag: #drgeoEvent
]

{ #category : #removing }
DrGFactory >> removeAt: index [
	| item |
	item := self at: index.
	last = item ifTrue: [last := nil].
	pool removeAt: index
]

{ #category : #accessing }
DrGFactory >> subPool: item [
"The items comming after me in the pool"
	^ self subPool: item from: pool
]

{ #category : #accessing }
DrGFactory >> subPool: item from: aPool [
"The items comming after me in aPool"
	^ aPool allButFirst: (self indexOf: item in: aPool)
]
