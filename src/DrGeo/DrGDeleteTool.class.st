"
A tool to delete the mathItem. With subclass from StyleTool to have hidden costume to be display, so we can delete these ones aswell.
"
Class {
	#name : #DrGDeleteTool,
	#superclass : #DrGStyleTool,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #documentation }
DrGDeleteTool class >> description [ 
	^'Erase an object and all its depedencies.' translated
]

{ #category : #documentation }
DrGDeleteTool class >> title [ 
	^'Eraser' translated 
]

{ #category : #accessing }
DrGDeleteTool >> relevantMorphsNear: aPoint [
	^self myMorphsNear: aPoint 
]

{ #category : #updating }
DrGDeleteTool >> reset [
	super reset.
	self switchState: DrGDeleteToolState
]
