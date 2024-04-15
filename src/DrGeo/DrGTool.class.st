"
The root of the class hierarchy to handle tool. A tool is used to process the user inputs and to give appropriate feedbacks to the user depending on the operation the user can conduct. It works in close relation with a builder (see presenter-builder).

- state: state of the tool
- presenter: from which presenter is used this tool
- spot: 	xy-postition of the selected item when selecting one among several
- last: last mouse xy-position (used during drag)
- morph: 	a selected DrGMorph during the last multiple choice selection
- mathItemUnderMouse: 	mathItem under mouse
 
"
Class {
	#name : #DrGTool,
	#superclass : #Object,
	#instVars : [
		'state',
		'presenter',
		'spot',
		'last',
		'morph',
		'mathItemUnderMouse'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #'instance creation' }
DrGTool class >> new [
	self error: 'Instanciate with #presenter: message'
]

{ #category : #'instance creation' }
DrGTool class >> presenter: aPresenter [
	^ self basicNew
		presenter: aPresenter;
		initialize;
		yourself
]

{ #category : #handling }
DrGTool >> chooseMorph: morphs [ 
	self chooseMorph: morphs title: 'Select an object' translated.
]

{ #category : #handling }
DrGTool >> chooseMorph: morphs title: aTitle [
	| menu |
	menu := DrGDrawableMenu entitled: aTitle.
	menu tool: self.
	morphs do: [ :aMorph | 
		menu add: aMorph asString target: self action: #handleChoice: argument: {aMorph}].
	menu popUpInWorld. 
]

{ #category : #accessing }
DrGTool >> description [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
DrGTool >> domain [ 
	^presenter domain
]

{ #category : #accessing }
DrGTool >> drawable [ 
	^presenter drawable
]

{ #category : #accessing }
DrGTool >> factory [  
	^self domain factory
]

{ #category : #updating }
DrGTool >> gridPoint: ungriddedPoint [
	^ self drawable gridPoint: ungriddedPoint.
]

{ #category : #handling }
DrGTool >> handleChoice: aMorphCollection [
	^ self state handleChoice: aMorphCollection 
]

{ #category : #handling }
DrGTool >> handleMouseAt: aPoint [
	^self state handleMouseAt: aPoint
]

{ #category : #handling }
DrGTool >> handlePress: aPoint [
	^self state handlePress: aPoint 
]

{ #category : #handling }
DrGTool >> handlePressShiftKey: aPoint [
	^self state handlePressShiftKey: aPoint 
]

{ #category : #handling }
DrGTool >> handleRelease: aPoint [
	self state handleRelease: aPoint 
]

{ #category : #handling }
DrGTool >> handleReleaseShiftKey: aPoint [
	self state handleReleaseShiftKey: aPoint 
]

{ #category : #handling }
DrGTool >> handleShiftKey: aPoint [
	^self state handleShiftKey: aPoint 
]

{ #category : #handling }
DrGTool >> handleShiftKeyMouseAt: aPoint [
	^self state handleShiftKeyMouseAt: aPoint
]

{ #category : #handling }
DrGTool >> handleStillPress: aPoint [
	self state handleStillPress: aPoint
]

{ #category : #'initialize-release' }
DrGTool >> initialize [
	morph := nil.
	self last: 0@0.
]

{ #category : #testing }
DrGTool >> isBuilding [
"does the tool build new object ?"
	^ true
]

{ #category : #testing }
DrGTool >> isCloning [
	^ false
]

{ #category : #testing }
DrGTool >> isGridded [
	^presenter isGridded
]

{ #category : #testing }
DrGTool >> isWanted: aMathItem [
	^true
]

{ #category : #accessing }
DrGTool >> last [
	^last
]

{ #category : #accessing }
DrGTool >> last: aPoint [
	last := aPoint
]

{ #category : #accessing }
DrGTool >> mathItem [
	^self morph mathItem
]

{ #category : #accessing }
DrGTool >> morph [
	^morph 
]

{ #category : #accessing }
DrGTool >> morph: aMorph [
	morph ifNotNil: [
		morph stopBlinking.
		presenter controlsManager tree ifNotNil: [:aTree | aTree mathItem: nil]].
	morph := aMorph.
	morph ifNotNil: [
		morph startBlinking.
		presenter controlsManager tree ifNotNil: [:aTree | aTree mathItem: morph mathItem]
	]
	
]

{ #category : #private }
DrGTool >> myMorphsNear: aPoint [
"Only morphs where feedback and action are wished,  	not hidden, wanted and under mouse cursor"
	^self drawable itemViews select: [:aMorph | 
		aMorph style isNotHidden 
			and: [(self isWanted: {aMorph mathItem})
			and: [aMorph containsPoint: aPoint]]]
]

{ #category : #private }
DrGTool >> pointMorphsFirstNear: aPoint [ 
	"When the user moves the mouse over a collection of geometric items, if there
are any point items, we discard all the other geometric items"
	| myMorphs pointMorphs |
	myMorphs := self myMorphsNear: aPoint.
	pointMorphs := myMorphs select: [:aMorph | aMorph isPoint].
	pointMorphs ifNotEmpty: [ ^ pointMorphs ].
	^ myMorphs
]

{ #category : #private }
DrGTool >> pointMorphsNear: aPoint [ 
	"List of point under the mouse cursor"
	^ (self myMorphsNear: aPoint) select: [:aMorph | aMorph isPoint].
]

{ #category : #accessing }
DrGTool >> presenter [
	^presenter 
]

{ #category : #accessing }
DrGTool >> presenter: aPresenter [
	presenter := aPresenter 
]

{ #category : #updating }
DrGTool >> redrawFlyingMorph [
]

{ #category : #'initialize-release' }
DrGTool >> registerDependant: anObject [
]

{ #category : #'initialize-release' }
DrGTool >> release [
	self reset.
]

{ #category : #accessing }
DrGTool >> relevantMorphsNear: aPoint [
"return the list of morphs at position aPoint relevant to me, override if needed"
	^self myMorphsNear: aPoint 
]

{ #category : #'initialize-release' }
DrGTool >> reset [
	self morph: nil;
		last: nil;
		spot: nil.
	mathItemUnderMouse := nil
]

{ #category : #'initialize-release' }
DrGTool >> resetForFreshStart [ 
	self reset.
]

{ #category : #accessing }
DrGTool >> spot [
	^spot
]

{ #category : #accessing }
DrGTool >> spot: aPoint [
	spot := aPoint 
]

{ #category : #accessing }
DrGTool >> state [
	^state
]

{ #category : #accessing }
DrGTool >> state: aState [
	state :=	aState 
]

{ #category : #updating }
DrGTool >> switchState: aStateClass [
	self state: (aStateClass new context: self)
]
