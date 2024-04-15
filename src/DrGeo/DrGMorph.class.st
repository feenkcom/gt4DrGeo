"
An abstract the view for DrGMathItem, model of a geometric object.
The user interact with the mathItem through its morph.
- mathItem: the model
- labelMorph: to display the object name, may be nil
- app: the DrGeo application this morph belong to
- color: additionnaly to style color, we need a color instance to blink a user selected morph

"
Class {
	#name : #DrGMorph,
	#superclass : #Morph,
	#instVars : [
		'drawable',
		'mathItem',
		'style',
		'labelMorph',
		'labelPositionDelta',
		'blink'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #'instance creation' }
DrGMorph class >> for: aMathItem in: aDrawable [
	^ (aMathItem morphClass basicNew)
		drawable: aDrawable ;
		mathItem: aMathItem;
		initialize;
		addMyMorph;
		redrawNeeded;
		yourself
]

{ #category : #'new-morph participation' }
DrGMorph class >> includeInNewMorphMenu [
	^ false
]

{ #category : #'initialize-release' }
DrGMorph >> addMyMorph [
	self isBitmap 
		ifTrue: [self drawable addMorphBack: self]
		ifFalse: [self drawable addMorph: self]
]

{ #category : #printing }
DrGMorph >> asString [
	^ mathItem 
		ifNil: ['nil']
		ifNotNil: [mathItem descriptiveName] 
]

{ #category : #testing }
DrGMorph >> canBeDrawn [
	^ self visible
]

{ #category : #accessing }
DrGMorph >> color: aColor [
	color := aColor
]

{ #category : #label }
DrGMorph >> computeLabelPositionDelta: aVector [
	| distance  |
	labelMorph ifNil: [ ^ (0 @ 0) ].
	"Authorized distance to the item"
	distance := aVector r min: 40.
	labelPositionDelta := aVector normalized * distance - labelMorph morphCenter
]

{ #category : #label }
DrGMorph >> constrainedLabelPosition: aVector [
"Constrains the label arround an anchor object or position
aVector is a shifted direction from the center of the label morph"
	self subclassResponsibility 
]

{ #category : #testing }
DrGMorph >> containsPoint: localPoint [
	^self canBeDrawn and: [self isCloserThan: 5 toPixel: (self drawable morphPositionInWorld + localPoint)]
]

{ #category : #testing }
DrGMorph >> containsPointInWorld: localPoint [
"General expensive version done in DrGeo coordinates. Only used with some morphs.
Other straight line morph use VectorGraphics detection, see contrainsPoint:"
	| worldPoint closestPoint |
	self canBeDrawn ifFalse: [^ false].
	worldPoint := self drawable morphToWorld: localPoint	.
	closestPoint := mathItem closestPointTo: worldPoint.
	^ (closestPoint squaredDistanceTo: worldPoint ) <= (self drawable pixelToWorld: 5) squared
	
]

{ #category : #accessing }
DrGMorph >> domain [
	^ drawable domain
]

{ #category : #accessing }
DrGMorph >> drawable [
	^ drawable 
]

{ #category : #accessing }
DrGMorph >> drawable: aDrawable [
	drawable  :=	 aDrawable 
]

{ #category : #accessing }
DrGMorph >> fontSize: aSmallInteger [ 

]

{ #category : #updating }
DrGMorph >> forceHiddenColor [
	color := DrGTypeColor hiddenColor.

]

{ #category : #updating }
DrGMorph >> forcedVisibility: aBoolean [
"We force this hidden morph to be visible. 
Necessary when one wants to edit the style of an hidden morph
In the process we change its color to inform the user this is a hidden item temporaly set visible."
	style isNotHidden ifTrue: [^false].
	aBoolean 
		ifTrue: 
			[self forceHiddenColor.
			self show]
		ifFalse: 
			[self hide.
			self restoreNormalColor].
	^true
]

{ #category : #'event handling' }
DrGMorph >> handlesMouseDown: evt [
	^ false
]

{ #category : #updating }
DrGMorph >> hide [
	super hide.
	labelMorph ifNotNil: [labelMorph hide].
]

{ #category : #'initialize-release' }
DrGMorph >> initialize [
	super initialize.
	blink := false.
	labelPositionDelta := 7@7.
	self style: (self styleClass newWith: self).
	self labelMorph: mathItem name.
]

{ #category : #'testing type' }
DrGMorph >> isAngle [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isArc [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isBitmap [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isCircle [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isCurve [
	^ false
]

{ #category : #testing }
DrGMorph >> isDrawNeeded [
	^ self itemExist and: [style isNotHidden or: [self isForceVisible]]

]

{ #category : #'testing type' }
DrGMorph >> isFinitCurve [
	^ false
]

{ #category : #testing }
DrGMorph >> isForceVisible [
	^ self presenter isForceVisible 
]

{ #category : #'testing type' }
DrGMorph >> isLine [
	^ false
]

{ #category : #testing }
DrGMorph >> isLockable [
	^mathItem 
		ifNil: [false] 
		ifNotNil: [mathItem isLockable]
]

{ #category : #testing }
DrGMorph >> isLocked [
	^ self isLockable and: [mathItem isLocked]
]

{ #category : #'testing type' }
DrGMorph >> isLocus [
	^ false
]

{ #category : #testing }
DrGMorph >> isNotForAway [
"If not attached to a drawable, considers it not far away, likely used for an icon"
	^ self drawable isNil
]

{ #category : #'testing type' }
DrGMorph >> isPoint [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isRay [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isSegment [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isText [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isValue [
	^ false
]

{ #category : #'testing type' }
DrGMorph >> isVector [
	^ false
]

{ #category : #testing }
DrGMorph >> itemExist [
"If there is not mathItem model, we just respond true"
	^ mathItem 
		ifNil: [true]
		ifNotNil: [mathItem exist]
]

{ #category : #label }
DrGMorph >> labelMorph [
	^ labelMorph 
]

{ #category : #label }
DrGMorph >> labelMorph: aString [
	aString isEmptyOrNil
		ifTrue: 	[self removeLabelMorph]
		ifFalse: 	[labelMorph 
			ifNil: 	[labelMorph := DrGLabel new contents: aString.
				labelMorph morph: self.
				self canBeDrawn ifTrue: [self drawable addMorph: labelMorph.
					labelMorph morphPosition: self labelPosition]]
			ifNotNil: 	[labelMorph contents: aString]]
]

{ #category : #label }
DrGMorph >> labelPosition [
"get an up to date label position in the drawable world coordinates"
	self subclassResponsibility
]

{ #category : #label }
DrGMorph >> labelPositionDelta: aPoint [
"The position of the label from its math object"
	labelPositionDelta := aPoint
]

{ #category : #accessing }
DrGMorph >> locked [
	^ mathItem isLocked
]

{ #category : #accessing }
DrGMorph >> locked: boolean [
	self isLockable ifTrue: [
		mathItem locked: boolean.
		self update: #locked:]
]

{ #category : #accessing }
DrGMorph >> mathItem [
	^ mathItem 
]

{ #category : #accessing }
DrGMorph >> mathItem: aMathItem [
	self removeEvents.
	mathItem := aMathItem.
	self registerEvents.
]

{ #category : #accessing }
DrGMorph >> morphCenter [
"Our center in our drawable"
	^ self displayBounds center - self drawable basicDisplayBounds topLeft
]

{ #category : #accessing }
DrGMorph >> name [
	^ mathItem name ifNil: [ '' ]

]

{ #category : #accessing }
DrGMorph >> name: aString [
	mathItem name: aString asString.
	self labelMorph: mathItem name

]

{ #category : #accessing }
DrGMorph >> presenter [
	^ drawable presenter 
]

{ #category : #printing }
DrGMorph >> printOn: aStream [
	aStream nextPutAll: 'View::'.
	aStream print: mathItem.
]

{ #category : #'initialize-release' }
DrGMorph >> reInitialize [
	"we recover from an undo operation, so let's reInitialize some of my
	aspect "
	self registerEvents.
	self addMyMorph.
	self redrawNeeded.
	self labelMorph: mathItem name.
	self forcedVisibility: false
]

{ #category : #'initialize-release' }
DrGMorph >> registerEvents [
	mathItem
		ifNotNil: [
			mathItem
				when: #deletedMathItem
				send: #deleteItemView:
				to: drawable 
				with: self.
			mathItem 
				when: #updateMyView
				send: #updateAllMathItems
				to: self domain].
	self flag: #drgeoEvent
]

{ #category : #'initialize-release' }
DrGMorph >> release [
	" Flying morph use it. Read DrGMathItemBuilder>>reset "
	self drawable removeMorph: self.
	self removeLabelMorph.
	
	self flag: #drgeoEvent.
	self removeEvents.
]

{ #category : #'initialize-release' }
DrGMorph >> removeEvents [
	mathItem ifNotNil: 
		[mathItem removeActionsWithReceiver: self].
	self breakDependents 
]

{ #category : #'initialize-release' }
DrGMorph >> removeLabelMorph [
	labelMorph ifNotNil:
		[self drawable removeMorph: labelMorph.
		labelMorph := nil]
]

{ #category : #testing }
DrGMorph >> requiresVectorCanvas [
	^ true
]

{ #category : #updating }
DrGMorph >> restoreNormalColor [
	color := Theme current adjustColor: style color
]

{ #category : #updating }
DrGMorph >> show [
	super show.
	labelMorph ifNotNil: 	[
		labelMorph show.
		labelMorph morphPosition: self labelPosition]	
]

{ #category : #'stepping and presenter' }
DrGMorph >> startBlinking [
	blink := true.
	self startStepping 
]

{ #category : #'stepping and presenter' }
DrGMorph >> step [
	blink ifFalse: [^self].
	super step.
	color = DrGTypeColor blinkingColor 
		ifTrue: [color := Theme current adjustColor: style color]
		ifFalse: [color := DrGTypeColor blinkingColor].
	self redrawNeeded
]

{ #category : #'stepping and presenter' }
DrGMorph >> stepTime [
	^500
]

{ #category : #'stepping and presenter' }
DrGMorph >> stopBlinking [
	blink := false.
	self stopStepping.
]

{ #category : #'stepping and presenter' }
DrGMorph >> stopStepping [
	super stopStepping.
	self restoreNormalColor.
	self redrawNeeded 
]

{ #category : #accessing }
DrGMorph >> style [
	^ style
]

{ #category : #accessing }
DrGMorph >> style: aStyle [
	style := aStyle 
]

{ #category : #accessing }
DrGMorph >> styleClass [
	^DrGStyle
]

{ #category : #updating }
DrGMorph >> toggleLocked [
	self isLockable ifTrue: [
		mathItem locked: mathItem isLocked not]
]

{ #category : #updating }
DrGMorph >> unhide [
 "make this morph visible in case it was hidden"
	style isHidden ifTrue: [
		self forcedVisibility: true.
		style hidden: false]
]

{ #category : #updating }
DrGMorph >> update: object [
	self presenter saved: false.
	"morph or canvas redraw?"
	self flag: #drgeoTodo.
	self redrawNeeded 
]

{ #category : #label }
DrGMorph >> updateLabelStatus [
"Update position and visibility if needed"
	labelMorph ifNotNil: [	
		labelMorph show.
		labelMorph 	morphPosition: self labelPosition].
]

{ #category : #updating }
DrGMorph >> updateToInvisible [
	self hide
]

{ #category : #updating }
DrGMorph >> updateToVisible [
	style isNotHidden ifTrue: [	self show		]
]

{ #category : #accessing }
DrGMorph >> view [
	^ drawable view
]

{ #category : #testing }
DrGMorph >> wantsContour [
	^ true
]

{ #category : #'xml writting' }
DrGMorph >> writeAsXmlTo: aNode [ 
"We wrote from the morph because it knows the model, the view and the style"
	self writeAttributesTo: (mathItem writeAsXmlTo: aNode)
]

{ #category : #'xml writting' }
DrGMorph >> writeAttributesTo: aNode [ 
	aNode	attributeAt: #delta put: labelPositionDelta asString.
	self isLockable ifTrue: [
		aNode attributeAt: #locked put: mathItem isLocked asString capitalized].
	style writeAttributesTo: aNode.

]
