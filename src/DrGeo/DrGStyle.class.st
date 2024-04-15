"
I am an abstract class to set a style to a morph item (DrGMorph hierarchy).
"
Class {
	#name : #DrGStyle,
	#superclass : #Object,
	#instVars : [
		'morph',
		'color',
		'hidden',
		'feedback'
	],
	#category : #'DrGeo-Model-Style'
}

{ #category : #'instance creation' }
DrGStyle class >> newWith: aMorph [
	^self basicNew morph: aMorph; initialize
]

{ #category : #accessing }
DrGStyle >> arrow: boolean [
" Does nothing by default "
]

{ #category : #accessing }
DrGStyle >> baseColor [
	"Answer color whatever it is hidden or not"

	^ color alpha: 1
]

{ #category : #accessing }
DrGStyle >> borderColor [
	self shouldNotImplement 
]

{ #category : #accessing }
DrGStyle >> color [
	"Answer the value of color"

	^hidden ifTrue: [DrGTypeColor hiddenColor] ifFalse: [color]
]

{ #category : #accessing }
DrGStyle >> color: anObject [
	"Set the value of color"
	color := anObject.
	morph 
		color: (Theme current adjustColor: self color);
		redrawNeeded
]

{ #category : #widget }
DrGStyle >> colorIndex [
	^ DrGTypeColor colorIndexOf: self baseColor
]

{ #category : #widget }
DrGStyle >> colorIndex: index [
	self color: (DrGTypeColor colorFor: index).
	self changed: #colorIndex:
]

{ #category : #widget }
DrGStyle >> colorMorphCollection [
	^ DrGTypeColor colorMorphCollection
]

{ #category : #widget }
DrGStyle >> colorWidget [
	^ self 	widget: (
		(DropDownButtonMorph 
			model: self 
			listGetter: #colorMorphCollection 
			indexGetter: #colorIndex
			indexSetter: #colorIndex:)
			autoDeselect: false;
			yourself)
		named:  'Colour' translated
		help: 	'Set the colour.' translated
]

{ #category : #accessing }
DrGStyle >> feedback [
	^ feedback
]

{ #category : #accessing }
DrGStyle >> feedback: aBoolean [
" Do I provide feedback when mouse over me?"
	feedback := aBoolean.
	self changed: #feedback:
]

{ #category : #widget }
DrGStyle >> feedbackWidget [
	^ (PluggableCheckboxMorph 
		model: self 
		getSelected: #feedback 
		setSelected:  #feedback:
		label: 'Feedback' translated)
		setBalloonText:  'Toggle to provide feedback and interaction when the mouse cursor is over the object.' translated;
		yourself
]

{ #category : #accessing }
DrGStyle >> fill: boolean [
" Does nothing by default "
]

{ #category : #accessing }
DrGStyle >> hidden [
	^ self isHidden
]

{ #category : #accessing }
DrGStyle >> hidden: anObject [ 
	"Set the value to isHidden"
	hidden := anObject.
	hidden 	ifFalse: [morph color: self color].
	morph redrawNeeded.
	self changed: #hidden:
]

{ #category : #widget }
DrGStyle >> hiddenWidget [
	^ (PluggableCheckboxMorph 
		model: self 
		getSelected: #hidden 
		setSelected: #hidden:
		label: 'Hide' translated)		
		setBalloonText:  'Toggle to hide the object.' translated;
		yourself
]

{ #category : #'initialize-release' }
DrGStyle >> initialize [
	feedback := true.
	hidden := false.
	color := Color black
]

{ #category : #testing }
DrGStyle >> isFeedback [
	^ feedback 
]

{ #category : #testing }
DrGStyle >> isFilled [
	^ false
]

{ #category : #accessing }
DrGStyle >> isHidden [
	"Answer the value of isHidden"

	^ hidden ifNil: [hidden := false]
]

{ #category : #testing }
DrGStyle >> isNotHidden [
	"Answer the value of isHidden"

	^ hidden not
]

{ #category : #testing }
DrGStyle >> isTranslucent [ 
	^ false
]

{ #category : #widget }
DrGStyle >> lockedWidget [
	^ (PluggableCheckboxMorph 
		model: morph
		getSelected: #locked
		setSelected: #locked: 
		label:  'Lock' translated)
		setBalloonText: 'Toggle to lock the object to its position.' translated;
		yourself
]

{ #category : #accessing }
DrGStyle >> mathItem [
	^ morph mathItem
]

{ #category : #accessing }
DrGStyle >> morph [
	^ morph
]

{ #category : #accessing }
DrGStyle >> morph: aMorph [
	morph := aMorph 
]

{ #category : #widget }
DrGStyle >> myWidgets [
"overwrite to add specific widget to edit specific style"
	^ OrderedCollection new
]

{ #category : #widget }
DrGStyle >> nameWidget [
 | inputWidget |
	inputWidget := (TextModelMorph textProvider: morph textGetter: #name textSetter: #name:)
			hideScrollBarsIndefinitely;
			askBeforeDiscardingEdits: false;
			borderWidth: 1;
			acceptOnCR: true;
			yourself	.
	inputWidget scroller setProperty: #keyStroke: toValue: [:event | inputWidget scroller acceptContents]. 
	^ self 
		widget: inputWidget 
		named:  'Name' translated
		help: 'Rename this object.' translated	
]

{ #category : #widget }
DrGStyle >> styleWidget [
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

{ #category : #accessing }
DrGStyle >> translucent: boolean [
" Does nothing by default "
]

{ #category : #accessing }
DrGStyle >> view [
	^ morph view
]

{ #category : #widget }
DrGStyle >> widget: aWidget named: aLabel help: aString [
| label |
	^ LayoutMorph newRow
		separation: 5;
		color: Color transparent;
		axisEdgeWeight: #rowLeft;
		addMorph: (label := LabelMorph contents: aLabel);
		addMorph: aWidget layoutSpec: (LayoutSpec fixedHeight: label morphHeight) ;
		setBalloonText: aString;
		yourself.
		
]

{ #category : #'xml writing' }
DrGStyle >> writeAttributesTo: aNode [
	aNode 
		attributeAt: #color put: self baseColor colorName asString capitalized;
		attributeAt: #masked put: hidden asString capitalized;
		attributeAt: #feedback put: feedback asString capitalized
]
