Class {
	#name : #DrGValueStyle,
	#superclass : #DrGTextStyle,
	#category : #'DrGeo-Model-Style'
}

{ #category : #'initialize-release' }
DrGValueStyle >> initialize [ 
	super initialize.
	self color: (DrGeoSystem preferences at: #valueColor)

]

{ #category : #accessing }
DrGValueStyle >> rename [
|answer|
	"Not the responsability of this object"
	self flag: #drgeoTodo.
	DrGeoSystem showVirtualKeyboard: true.
	self mathItem name 
		ifNotNil:	[
			answer := self view 
				textEntry:  'Rename this value' translated 
				title: 'Rename this value' translated 
				entryText: self mathItem name.]
		ifNil: [
			answer := self view 
				textEntry:  'Name this value' translated 
				title: 'Name this value' translated].
	answer ifNil: [^self].
	answer isEmpty ifTrue: [answer := nil].
	self mathItem name: answer.
	morph redrawNeeded.
	self changed
]

{ #category : #widget }
DrGValueStyle >> styleWidget [
| controls |
	controls := 	OrderedCollection new
		add: self nameWidget;
		add: self colorWidget;
		yourself.
	controls addAll: self myWidgets.
	controls add: self feedbackWidget.
	controls add: self hiddenWidget.
	morph isLockable ifTrue: [controls add: self lockedWidget].
	^controls
]
