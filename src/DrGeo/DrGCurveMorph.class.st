"
An abstract class to represent curve. My only attribute is an anchorAbscissa in [0 ; 1]
"
Class {
	#name : #DrGCurveMorph,
	#superclass : #DrGMorph,
	#instVars : [
		'borderColor',
		'borderWidth',
		'anchorAbscissa',
		'dashedBorder'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #accessing }
DrGCurveMorph >> anchorAbscissa: number [
	anchorAbscissa := number 
]

{ #category : #accessing }
DrGCurveMorph >> borderColor: aColor [
	borderColor := aColor 
]

{ #category : #accessing }
DrGCurveMorph >> borderWidth: pixels [
	borderWidth := pixels
]

{ #category : #label }
DrGCurveMorph >> constrainedLabelPosition: aPosition [
	| center |
	center := mathItem closestPointTo: (self drawable morphToWorld: aPosition).
	anchorAbscissa := mathItem abscissaOf: center.
	center := self drawable worldToMorph: center.
	self computeLabelPositionDelta: aPosition - center.

]

{ #category : #dashes }
DrGCurveMorph >> dashedBorder: dashSpec [
	dashedBorder := dashSpec.
]

{ #category : #updating }
DrGCurveMorph >> forceHiddenColor [
	color := (style isFilled ifTrue: [DrGTypeColor hiddenColor] ifFalse: [Color transparent]).
	borderColor := DrGTypeColor hiddenColor.
]

{ #category : #'initialize-release' }
DrGCurveMorph >> initialize [
	anchorAbscissa := 0.5.
	super initialize.
	borderColor := Theme current adjustColor: style borderColor.
	borderWidth := style borderWidth.
	color := Theme current adjustColor: style color
]

{ #category : #'testing type' }
DrGCurveMorph >> isCurve [
	^ true
]

{ #category : #label }
DrGCurveMorph >> labelPosition [
	^(self drawable worldToMorph: (mathItem pointAt: anchorAbscissa)) + labelPositionDelta
]

{ #category : #updating }
DrGCurveMorph >> restoreNormalColor [
	color :=  (style isFilled ifTrue: [Theme current adjustColor: style color] ifFalse: [Color transparent]).
	borderColor := Theme current adjustColor: style borderColor
]

{ #category : #'stepping and presenter' }
DrGCurveMorph >> step [
	blink ifFalse: [^self].
	super step.
	borderColor = DrGTypeColor blinkingColor 
		ifTrue: [borderColor := Theme current adjustColor: style borderColor]
		ifFalse: [borderColor := DrGTypeColor blinkingColor]
]

{ #category : #'testing type' }
DrGCurveMorph >> styleClass [
	^ DrGCurveStyle
]

{ #category : #'xml writting' }
DrGCurveMorph >> writeAttributesTo: aNode [
	aNode attributeAt: #anchor put: anchorAbscissa asString.
	super writeAttributesTo: aNode.

]
