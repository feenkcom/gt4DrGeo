"
A tool to edit the property of some object like free point, free point on curve,  free value and script
"
Class {
	#name : #DrGPropertyTool,
	#superclass : #DrGSelectTool,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #documentation }
DrGPropertyTool class >> description [
	^ 'Edit an item''s property' translated
]

{ #category : #documentation }
DrGPropertyTool class >> title [
	^ 'Property' translated
]

{ #category : #testing }
DrGPropertyTool >> isWanted: aMathItemCollection [
" only items whose property are editable "
	^ aMathItemCollection first isPropertyEditable
]

{ #category : #accessing }
DrGPropertyTool >> presenter: aPresenter [
	super presenter: aPresenter.
	self drawable forcedVisibility: false.
]

{ #category : #updating }
DrGPropertyTool >> reset [
	super reset.
	presenter controlsManager propertyFor: nil.
	self switchState: DrGPropertyToolState
]
