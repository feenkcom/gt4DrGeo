"
I a represent the state of the user selected tool.
The context is the tool (selectTool, buildTool, ...) where the state operate.
"
Class {
	#name : #DrGToolState,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #accessing }
DrGToolState >> context [
	^context
]

{ #category : #accessing }
DrGToolState >> context: aContext [
	context := aContext 
]

{ #category : #accessing }
DrGToolState >> drawable [
	^self context drawable
]

{ #category : #handling }
DrGToolState >> handleChoice: aMorphCollection [
]

{ #category : #handling }
DrGToolState >> handleMouseAt: aPoint [ 
	"Return true if we can process something or we are over something"
	| morphs aTip feedback |
	feedback := true.
	morphs := self context relevantMorphsNear: aPoint.
	morphs size = 1
		ifTrue: [
			aTip := morphs first mathItem descriptiveName.
			feedback := morphs first style isFeedback].
	morphs size > 1
		ifTrue: [aTip := 'Several objects can be selected. Please, choose one.' translated. ].
	(aTip isNil or: [ feedback not ])
		ifTrue: [self drawable hideTip]
		ifFalse: [self drawable tip: aTip at: aPoint].
	^ aTip notNil
]

{ #category : #handling }
DrGToolState >> handlePress: aPoint [
	^ false
]

{ #category : #handling }
DrGToolState >> handlePressShiftKey: aPoint [
"handle pressed mouse bouton with shift key, by default  just handle mouse button press"
	^ self handlePress: aPoint
]

{ #category : #handling }
DrGToolState >> handleRelease: aPoint [ 

]

{ #category : #handling }
DrGToolState >> handleReleaseShiftKey: aPoint [ 
" handle mouse bouton release while shift key down, by default only handle release"
	self handleRelease: aPoint
]

{ #category : #handling }
DrGToolState >> handleShiftKey: aPoint [
"handle shift key down, do nothing by default"
	^ false
]

{ #category : #handling }
DrGToolState >> handleShiftKeyMouseAt: aPoint [ 
"handle moved mouse while shift key down, by default just handle mouse at"
	^ self handleMouseAt: aPoint
]

{ #category : #handling }
DrGToolState >> handleStillPress: aPoint [
	"A 2s mouse down evt, by default do nothing"
]

{ #category : #accessing }
DrGToolState >> presenter [
	^self context presenter
]

{ #category : #state }
DrGToolState >> switchState: aStateClass [
	self context switchState: aStateClass
]

{ #category : #accessing }
DrGToolState >> view [
	^self context presenter view
]
