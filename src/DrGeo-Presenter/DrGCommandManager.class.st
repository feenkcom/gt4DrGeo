Class {
	#name : #DrGCommandManager,
	#superclass : #Object,
	#instVars : [
		'stack',
		'domain'
	],
	#category : #'DrGeo-Presenter-Command'
}

{ #category : #'command exec' }
DrGCommandManager >> buildCommandFor: aMathItem [
	|command|
	command := stack nextPut: (DrGMathItemCommand for: aMathItem in: domain).
	^command execute
]

{ #category : #'command exec' }
DrGCommandManager >> buildCommandWith: aBuilder [
	|command|
	command := stack nextPut: (DrGMathItemCommand with: aBuilder in: domain).
	^command execute
]

{ #category : #'command exec' }
DrGCommandManager >> compositeCommandFor: aMathItemSelection [
|command|
	command := stack nextPut: (DrGCompositeCommand with: aMathItemSelection in: domain).
	command execute.
]

{ #category : #'command exec' }
DrGCommandManager >> deleteCommandFor: aMathItem [
|command|
	command := stack nextPut: (DrGDeleteCommand for: aMathItem in: domain).
	command execute
]

{ #category : #accessing }
DrGCommandManager >> domain: aDomain [
	domain := aDomain
]

{ #category : #initialization }
DrGCommandManager >> initialize [
	stack := DrGCommandStack new
]

{ #category : #'command exec' }
DrGCommandManager >> mergeCommandFor: aMathItem with: aTarget [
"create a merge command"
|command|
	command := stack nextPut: (DrGMergeCommand merge: aMathItem with: aTarget in: domain).
	command execute
]

{ #category : #'command exec' }
DrGCommandManager >> moveCommandFor: aMathItem with: aPoint [
	stack nextPut: (DrGMoveCommand for: aMathItem with: aPoint in: domain).
]

{ #category : #'command exec' }
DrGCommandManager >> propertyCommandFor: aMathItem with: aProperty [
	|command|
	command := stack nextPut: (DrGPropertyCommand for: aMathItem with: aProperty in: domain).
	command execute
]

{ #category : #'command exec' }
DrGCommandManager >> redo [
|command|
	command := stack next.
	command ifNotNil:	[command execute]
]

{ #category : #'dependents access' }
DrGCommandManager >> release [
	stack contents do: [:c | c release].
]

{ #category : #'command exec' }
DrGCommandManager >> undo [
|command|
	command := stack previous.
	command ifNotNil: [command unexecute]
]
