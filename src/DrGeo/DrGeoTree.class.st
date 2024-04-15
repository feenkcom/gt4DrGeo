"
I am a model to present the constructed math item in a hierarchy list.
- app: the DrGeo instance
"
Class {
	#name : #DrGeoTree,
	#superclass : #Object,
	#instVars : [
		'selectedItem',
		'presenter'
	],
	#category : #'DrGeo-Model'
}

{ #category : #'instance creation' }
DrGeoTree class >> on: aPresenter [
	^ self new
		presenter: aPresenter ;
		yourself
]

{ #category : #accessing }
DrGeoTree >> mathItem: aMathItem [
"select given a math item"
	selectedItem := self pool detect: [:wrappedItem | wrappedItem item == aMathItem] ifNone: [nil].
	self changed: #selectedItem.
]

{ #category : #accessing }
DrGeoTree >> pool [
	^ presenter drawable itemViews 
		select: [:aMorph | aMorph itemExist and: [aMorph style isNotHidden]] 
		thenCollect: [:aMorph | 
			(DrGeoTreeNode with: aMorph mathItem)
				hasContents: aMorph mathItem parents isNil not ;
				yourself]
]

{ #category : #accessing }
DrGeoTree >> presenter: aPresenter [
	presenter := aPresenter .
	presenter domain
		when: #updatedItems
		send: #changed:
		to: self
		with: #pool
	
	
]

{ #category : #accessing }
DrGeoTree >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
DrGeoTree >> selectedItem: anItemWrapper [
	selectedItem := anItemWrapper.
	self changed: #selectedItem.
	presenter updateSelection 
]

{ #category : #updating }
DrGeoTree >> update: symbol [
"pass on the notified change"
	self changed: symbol
]
