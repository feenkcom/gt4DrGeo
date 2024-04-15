Class {
	#name : #DrGeoTreeNode,
	#superclass : #ListItemWrapper,
	#instVars : [
		'hasContents'
	],
	#category : #'DrGeo-Model'
}

{ #category : #'as yet unclassified' }
DrGeoTreeNode >> contents [
	^ item parents 
		ifNotNil: [:array | array collect: [:each | DrGeoTreeNode with: each] ]
		ifNil: [(#())]
]

{ #category : #'as yet unclassified' }
DrGeoTreeNode >> hasContents [
	^ hasContents
]

{ #category : #'as yet unclassified' }
DrGeoTreeNode >> hasContents: boolean [
	hasContents := boolean 
]

{ #category : #initialization }
DrGeoTreeNode >> initialize [
	super initialize.
	hasContents := false.
]
