Class {
	#name : #DrGBuildTool,
	#superclass : #DrGTool,
	#instVars : [
		'selectedMorphs',
		'builder'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #'instance creation' }
DrGBuildTool class >> builder: aBuilderClassName presenter: aPresenter [
	^self basicNew
		builder: aBuilderClassName new;
		presenter: aPresenter;
		initialize;
		yourself
]

{ #category : #adding }
DrGBuildTool >> add: aMorph [
	self stopBlinking.
	selectedMorphs add: aMorph.
	self startBlinking.
]

{ #category : #accessing }
DrGBuildTool >> builder [
	^builder
]

{ #category : #accessing }
DrGBuildTool >> builder: aBuilder [
	builder := aBuilder 
]

{ #category : #accessing }
DrGBuildTool >> description [ 
	^ builder class description
]

{ #category : #'initialize-release' }
DrGBuildTool >> initialize [
	super initialize.
	self switchState:  DrGBuildToolState.
	selectedMorphs := OrderedCollection new
]

{ #category : #testing }
DrGBuildTool >> isWanted: aMathItemCollection [
	^builder isWanted: aMathItemCollection  
]

{ #category : #accessing }
DrGBuildTool >> presenter: aPresenter [
	super presenter: aPresenter.
	builder presenter: aPresenter .
]

{ #category : #updating }
DrGBuildTool >> redrawFlyingMorph [
	builder redrawFlyingMorph 
]

{ #category : #'initialize-release' }
DrGBuildTool >> registerDependant: anObject [
	builder when: #readyToBuild send: #readyToBuild to: anObject
]

{ #category : #'initialize-release' }
DrGBuildTool >> release [
	super release.
	builder release.
	self releaseActionMap. 
]

{ #category : #updating }
DrGBuildTool >> reset [
	super reset.
	self stopBlinking.
	self builder reset.
	selectedMorphs := OrderedCollection new
]

{ #category : #updating }
DrGBuildTool >> startBlinking [
	selectedMorphs do: [ :aMorph | aMorph startBlinking ]
]

{ #category : #updating }
DrGBuildTool >> stopBlinking [
	selectedMorphs do: [ :aMorph | aMorph stopBlinking ]
]
