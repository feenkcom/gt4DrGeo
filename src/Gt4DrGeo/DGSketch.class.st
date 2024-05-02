"
I am a subclass of DrGeoSketch that does not depend on morphs at all.
Instead of creating math items that sit inside views, they are completely independent, and communicate with Bloc views using MVC.
"
Class {
	#name : #DGSketch,
	#superclass : #DrGeoSketch,
	#instVars : [
		'mathItems',
		'announcer'
	],
	#category : #'Gt4DrGeo-Model'
}

{ #category : #updating }
DGSketch >> addItem: aMathItem [
	self mathItems addLast: aMathItem.
	aMathItem
		when: #updateMyView
		send: #updateAllMathItems
		to: self
]

{ #category : #accessing }
DGSketch >> announcer [
	^ announcer
]

{ #category : #accessing }
DGSketch >> announcer: anObject [
	announcer := anObject
]

{ #category : #accessing }
DGSketch >> asElement [
	^ DGSketchElement for: self
]

{ #category : #curve }
DGSketch >> finalizeCurve: item [
	^ DrGWrappedCurve wrap: (self morphOf: item) 
]

{ #category : #point }
DGSketch >> finalizeItem: aMathItem [
	self addItem: aMathItem.
	^ aMathItem
]

{ #category : #point }
DGSketch >> finalizePoint: aPointItem [
	^ self finalizeItem: aPointItem
]

{ #category : #view }
DGSketch >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 10;
		object: [ self asElement asPinchablePannable zoomToActualSize ];
		view: #gtLiveFor:;
		actionUpdateButton;
		updateWhen: DGSketchUpdated in: self announcer
]

{ #category : #accessing }
DGSketch >> gtMathItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Math Items';
		priority: 20;
		items: [ self mathItems ];
		actionUpdateButtonTooltip: 'Update item list';
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Item' text: [ :eachItem | eachItem gtDisplayText ];
		updateWhen: DGSketchUpdated in: self announcer
]

{ #category : #initalization }
DGSketch >> initialize [
	announcer := Announcer new.
	mathItems := OrderedCollection new
]

{ #category : #accessing }
DGSketch >> isEmpty [
	^ self mathItems isEmpty
]

{ #category : #curve }
DGSketch >> line: aPoint1 to: aPoint2 [
	^ self
		finalizeItem: (DrGLine2ptsItem
				newWith: {aPoint1.
						aPoint2})
]

{ #category : #accessing }
DGSketch >> mathItems [
	^ mathItems
]

{ #category : #accessing }
DGSketch >> mathItems: anObject [
	mathItems := anObject
]

{ #category : #announcements }
DGSketch >> updateAllMathItems [
	"Bridge from EventManager to Annkuncements!"

	self announcer announce: DGSketchUpdated new
]
