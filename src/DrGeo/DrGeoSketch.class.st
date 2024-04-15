"
Domain Specific Language (DSL) abstraction to construct programmatically interactive sketch.

| sketch a |
sketch := DrGeoSketch new.
a := sketch point: 1@1.
sketch line: a to: 0@0

"
Class {
	#name : #DrGeoSketch,
	#superclass : #Object,
	#instVars : [
		'presenter',
		'doProcess'
	],
	#category : #'DrGeo-Model-Smalltalk'
}

{ #category : #accessing }
DrGeoSketch >> aPosition [
	^ 10 atRandom - 5 @ (10 atRandom - 5)
]

{ #category : #value }
DrGeoSketch >> abscissaOf: wrpPointOrWrpVectorOrPoint [
	| class wrapped|
	wrapped := self wrappedPoint: wrpPointOrWrpVectorOrPoint.
	wrapped mathItem isPointItem
		ifTrue: [class := DrGValuePtabscissaItem].
	wrapped mathItem isVectorItem
		ifTrue: [class := DrGValueVectorabscissaItem].
	^ self
		finalizeValue: (class newWith: {wrapped mathItem. self aPosition})
]

{ #category : #point }
DrGeoSketch >> altIntersectionOf: wrpCurve1 and: wrpCurve2 [ 
"use this one when you want the intersection point when non straight line are involved"
	| item |
	item := DrGPointIntersectionItem newWith: {wrpCurve1 mathItem. wrpCurve2 mathItem. 0 @ 0}.
	item k: 1.
	^ self finalizePoint: item
]

{ #category : #value }
DrGeoSketch >> angle: wrpVect1 to: wrpVect2 [
	^ self
		finalizeValue: (DrGAngleVectorsItem newWith: {
			(self wrappedVector: wrpVect1) mathItem. 
			(self wrappedVector: wrpVect2) mathItem.
			self aPosition})
		hide: false
]

{ #category : #value }
DrGeoSketch >> angle: wrpPt1 to: wrpPt2 to: wrpPt3 [ 
	^ self
		finalizeValue: (DrGAngle3ptsOrientedItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem. 
			(self wrappedPoint: wrpPt3) mathItem.
			self aPosition})
		hide: false
]

{ #category : #curve }
DrGeoSketch >> angleBisector: wrpAngle [
	^ self finalizeCurve: 
		(DrGLineAngleBisectorItem newWith: {wrpAngle mathItem})
]

{ #category : #curve }
DrGeoSketch >> angleBisectorSummit: wrpSummit side1: wrpPt1 side2: wrpPt2 [
	^ self finalizeCurve: 
		(DrGAngleBisector3ptsItem newWith: 
			{(self wrappedPoint: wrpPt1) mathItem.
			(self wrappedPoint: wrpSummit) mathItem.
			(self wrappedPoint: wrpPt2) mathItem})
]

{ #category : #'curve filled' }
DrGeoSketch >> arc: wrpPt1 to: wrpPt2 to: wrpPt3 [
	^ self
		finalizeFilledCurve: (DrGArc3ptsItem newWith: 
			{(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem. 
			(self wrappedPoint: wrpPt3) mathItem})
]

{ #category : #'curve filled' }
DrGeoSketch >> arcCenter: wrpPt1 from: wrpPt2 to: wrpPt3 [
	^ self
		finalizeFilledCurve: (DrGArcCenterAngleItem newWith: 
			{(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem. 
			(self wrappedPoint: wrpPt3) mathItem})
]

{ #category : #'user interface' }
DrGeoSketch >> axesOn [
	 presenter axesOnOff 
]

{ #category : #transformations }
DrGeoSketch >> canTransform: wrptItem [
	wrptItem mathItem isGeometricItem
		ifFalse: [self error: 'Only geometric object can be transformed.' translated].
]

{ #category : #'user interface' }
DrGeoSketch >> centerTo: aPoint [
	"set the center of the visible canvas to this coordinate"
	presenter drawable 
		ox: aPoint x;
		oy: aPoint y;
		redrawNeeded
]

{ #category : #'curve filled' }
DrGeoSketch >> circleCenter: wrpCenter radius: wrpValue [
	^ self
		finalizeFilledCurve: (DrGCircleRadiusItem  newWith: {
			(self wrappedPoint: wrpCenter) mathItem. 
			(self wrappedValue: wrpValue) mathItem})
]

{ #category : #'curve filled' }
DrGeoSketch >> circleCenter: wrpCenter segment: wrpSegment [
	^ self
		finalizeFilledCurve: (DrGCircleSegmentItem  newWith: {
			(self wrappedPoint: wrpCenter) mathItem. 
			wrpSegment mathItem})
]

{ #category : #'curve filled' }
DrGeoSketch >> circleCenter: wrpCenter to: wrpPt [
	^ self
		finalizeFilledCurve: (DrGCircle2ptsItem newWith: {
			(self wrappedPoint: wrpCenter) mathItem. 
			(self wrappedPoint: wrpPt) mathItem})
]

{ #category : #'initialize-release' }
DrGeoSketch >> delete [
	self view deleteWithoutConfirmation.
	self release
]

{ #category : #value }
DrGeoSketch >> distance: item1 to: item2 [ 
	"Distance from a point to a line or another point"
	| arg class wrpItem1 wrpItem2 |
	"Try to wrap to point in case the user provided point coordinates"
	wrpItem1 := self wrappedPoint: item1.
	wrpItem2 := self wrappedPoint: item2.
	arg := OrderedCollection newFrom: {wrpItem1 mathItem. wrpItem2 mathItem}.
	(arg first isLineItem or: [arg second isLineItem])
		ifTrue: [class := DrGValueDistanceptlineItem.
			arg first isLineItem ifTrue: [arg := arg reverse]]
		ifFalse: [class := DrGValueDistance2ptsItem].
	arg addLast: self aPosition.
	^ self 	finalizeValue: (class newWith: arg)
]

{ #category : #helpers }
DrGeoSketch >> do: aBlock [
	"Execute the given construction in a forked process so the user can see the on going construction or animation"
	doProcess ifNotNil: [doProcess terminate].
	doProcess := aBlock newProcess.
	doProcess priority: Processor userBackgroundPriority.
	doProcess resume
]

{ #category : #accessing }
DrGeoSketch >> domain [
	^ presenter domain
]

{ #category : #accessing }
DrGeoSketch >> drawable [
	^ presenter drawable 
]

{ #category : #equation }
DrGeoSketch >> equationOf: wrpLineOrCircle [
	| class |
	wrpLineOrCircle mathItem isLineItem 
		ifTrue: [class := DrGEquationLineItem ].
	wrpLineOrCircle mathItem isCircleItem
		ifTrue: [class := DrGEquationCircleItem].
	^ self
		finalizeValue: (class newWith: {wrpLineOrCircle mathItem. self aPosition})
]

{ #category : #helpers }
DrGeoSketch >> exportToImage: aFilename [
"Export to a SVG file"
	presenter exportToImage: aFilename
]

{ #category : #curve }
DrGeoSketch >> finalizeCurve: item [
	^ DrGWrappedCurve wrap: (self morphOf: item) 
]

{ #category : #'curve filled' }
DrGeoSketch >> finalizeFilledCurve: item [
	^ DrGWrappedFilledCurve wrap: (self morphOf: item)
]

{ #category : #'curve finit' }
DrGeoSketch >> finalizeFinitCurve: item [
	^ DrGWrappedFinitCurve wrap: (self morphOf: item)
]

{ #category : #point }
DrGeoSketch >> finalizePoint: item [
	| wrappedPoint |
	wrappedPoint := DrGWrappedPoint wrap: (self morphOf: item).
	wrappedPoint square.
	^ wrappedPoint
]

{ #category : #'curve finit' }
DrGeoSketch >> finalizeSegment: item [
	^ DrGWrappedSegment wrap: (self morphOf: item)
]

{ #category : #text }
DrGeoSketch >> finalizeText: item [
	^ DrGWrappedText wrap: (self morphOf: item)
]

{ #category : #transformations }
DrGeoSketch >> finalizeTransformation: string with: arguments [ 
	| class item |
	class := Smalltalk classNamed: 'DrG', arguments first basicType capitalized, string, 'Item'.
	item := class newWith: arguments.
	^ item isPointItem
		ifTrue: [self finalizePoint: item]
		ifFalse: [| finalizedCurve | 
			finalizedCurve := self finalizeCurve: item.
			item isLocusItem ifTrue: [
				self view world doOneMinimalCycleNow .
				self domain updateAllMathItems].
			finalizedCurve ]
]

{ #category : #value }
DrGeoSketch >> finalizeValue: item [
"By default we don't hide the value"
	^ self finalizeValue: item hide: false
]

{ #category : #value }
DrGeoSketch >> finalizeValue: item hide: hide [
"By default we hide the value"
	| wrappedItem |
	wrappedItem := DrGWrappedValue wrap: (self morphOf: item).
	 hide ifTrue: [ wrappedItem hide ].
	^ wrappedItem
]

{ #category : #helpers }
DrGeoSketch >> float: value at: aPoint from: startValue to: endValue [ 
	^ self float: value at: aPoint from: startValue to: endValue name: ''
]

{ #category : #helpers }
DrGeoSketch >> float: aValue at: aPoint from: startValue to: endValue name: name [
"A valueslider ranging between startValue and endValue"
	^ self float: aValue at: aPoint from: startValue to: endValue name: name showValue: false
]

{ #category : #helpers }
DrGeoSketch >> float: aValue at: aPoint from: startValue to: endValue name: name showValue: isValueDisplay [
"A valueslider ranging between startValue and endValue"
	| segment mobile|
	segment := self segment: aPoint to: aPoint + (170 / presenter drawable scale @0).
	mobile := self pointOnLine:  segment at: (aValue - startValue) / (endValue - startValue).
	segment color: Color black; large.
	mobile name: name;
		color: Color black;
		round;
		large.	
	^ isValueDisplay 
		ifTrue:  [[|value |
			value := mobile mathItem abscissa * ( endValue - startValue) + startValue.
			mobile morph labelMorph contents: name,  ' = ', (value printShowingDecimalPlaces: 2).
			value]]
		ifFalse: [[mobile mathItem abscissa * ( endValue - startValue) + startValue]]  	
	
]

{ #category : #value }
DrGeoSketch >> freeValue: aNumber [ 
	^ self freeValue: aNumber at: self aPosition
]

{ #category : #value }
DrGeoSketch >> freeValue: aNumber at: aPosition [
	| answer |
	presenter notInteractive: true.
	answer := self finalizeValue: ((DrGValueValueItem newWith: {aPosition}) valueItem: aNumber).
	presenter notInteractive: false.
	^ answer
]

{ #category : #'user interface' }
DrGeoSketch >> fullScreen [
	presenter view fullScreen
]

{ #category : #obsolete }
DrGeoSketch >> fullscreen [
	
]

{ #category : #value }
DrGeoSketch >> geometricAngle: wrpPt1 to: wrpPt2 to: wrpPt3 [ 
	^ self
		finalizeValue: (DrGAngle3ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem. 
			(self wrappedPoint: wrpPt3) mathItem.
			self aPosition})
		hide: false
]

{ #category : #'user interface' }
DrGeoSketch >> gridOn [
	 presenter gridOnOff 
]

{ #category : #'initialize-release' }
DrGeoSketch >> initialize [
	presenter := DrGeo service
		stSketch: self;
		yourself .
	DrGeoSketch triggerEvent: #newSmalltalkSketch with: self
]

{ #category : #helpers }
DrGeoSketch >> integer: value at: aPoint from: startValue to: endValue [ 
	^ self integer: value at: aPoint from: startValue to: endValue name: ''
]

{ #category : #helpers }
DrGeoSketch >> integer: aValue at: aPoint from: startValue to: endValue name: name [
"A valueslider ranging between startValue and endValue"
	^ self integer: aValue at: aPoint from: startValue to: endValue name: name showValue: false
]

{ #category : #helpers }
DrGeoSketch >> integer: aValue at: aPoint from: startValue to: endValue name: name showValue: isValueDisplay [
"A valueslider ranging between startValue and endValue"
	| segment mobile|
	segment := self segment: aPoint to: aPoint + (170 / presenter drawable scale @0).
	mobile := self pointOnLine:  segment at: (aValue - startValue) / (endValue - startValue).
	segment color: Color black; large.
	mobile name: name;
		color: Color black;
		round;
		large.	
	^ isValueDisplay 
		ifTrue:  [[|value |
			value := (mobile mathItem abscissa * ( endValue - startValue) + startValue) floor.
			mobile morph labelMorph contents: name,  ' = ', value printString.
			value]]
		ifFalse: [[(mobile mathItem abscissa * ( endValue - startValue) + startValue) floor]]  	
	
]

{ #category : #point }
DrGeoSketch >> intersectionOf: wrpCurve1 and: wrpCurve2 [ 
|item|
	item := DrGPointIntersectionItem newWith: {wrpCurve1 mathItem. wrpCurve2 mathItem. 0 @ 0}.
	item k: -1.
	^ self
		finalizePoint: (item)
]

{ #category : #value }
DrGeoSketch >> lengthOf: wrpSegmentOrCircleOrArcOrVectorOrPolygon [
	| class |
	wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem isSegmentItem
		ifTrue: [class := DrGValueSegmentlengthItem].
	wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem isCircleItem
		ifTrue: [class := DrGValueCircleperimeterItem].
	wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem isArcItem
		ifTrue: [class := DrGValueArclengthItem].
	wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem isVectorItem
		ifTrue: [class := DrGValueVectornormItem].
	wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem isPolygonItem
		ifTrue: [class := DrGValuePolygonperimeterItem].

	^ self
		finalizeValue: (class newWith: {wrpSegmentOrCircleOrArcOrVectorOrPolygon mathItem. self aPosition})
]

{ #category : #curve }
DrGeoSketch >> line: wrpPt1 to: wrpPt2 [
	^ self
		finalizeCurve: (DrGLine2ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem })
]

{ #category : #curve }
DrGeoSketch >> locusOf: wrpPt1 when: wrpPt2 [ 
	wrpPt2 mathItem isPointItemOnCurve 
		ifFalse: [self error: 'The second point provided in the call must be on a curve.'].
	^ self
		finalizeCurve: (DrGLocus2ptsItem newWith: {wrpPt2 mathItem. wrpPt1 mathItem})
]

{ #category : #point }
DrGeoSketch >> middleOf: wrpSegment [
	^ self
		finalizePoint: (DrGPointMiddlesegmentItem newWith: {wrpSegment mathItem})
]

{ #category : #point }
DrGeoSketch >> middleOf: wrappedPoint1 and: wrappedPoint2 [ 
	^ self finalizePoint: (DrGPointMiddle2ptsItem newWith: 
		{(self wrappedPoint: wrappedPoint1) mathItem . (self wrappedPoint: wrappedPoint2) mathItem})
]

{ #category : #accessing }
DrGeoSketch >> morphOf: item [
	| finalItem |
	finalItem := self domain createFromMathItemNoCommand: item.
	^ finalItem == item 
		ifTrue: [	self drawable lastItemView ] "We create a new one, get its morph just created"
		ifFalse: [	self drawable viewOf: finalItem] "For twin items, search for the former item"
]

{ #category : #value }
DrGeoSketch >> ordinateOf: wrpPointOrWrpVectorOrPoint [ 
	| class wrapped |
	wrapped := self wrappedPoint: wrpPointOrWrpVectorOrPoint.
	wrapped mathItem isPointItem
		ifTrue: [class := DrGValuePtordinateItem].
	wrapped mathItem isVectorItem
		ifTrue: [class := DrGValueVectorordinateItem].
	^ self
		finalizeValue: (class newWith: {wrapped mathItem. self aPosition})
]

{ #category : #curve }
DrGeoSketch >> parallel: wrpDirection at: wrpPtOrPoint [
	^ self
		finalizeCurve: (DrGLineParallelItem newWith: {
			wrpDirection mathItem. 
			(self wrappedPoint: wrpPtOrPoint) mathItem})
]

{ #category : #curve }
DrGeoSketch >> perpendicular: wrpDirection at: wrpPtOrPoint [ 
	^ self
		finalizeCurve: (DrGLinePerpendicularItem newWith: {
			wrpDirection mathItem. 
			(self wrappedPoint: wrpPtOrPoint) mathItem})
]

{ #category : #curve }
DrGeoSketch >> perpendicularBisector: wrpSegment [
	^ self finalizeCurve: 
		(DrGPerpendicularBisectorItem newWith: {wrpSegment mathItem})
]

{ #category : #curve }
DrGeoSketch >> perpendicularBisector: wrpPt1 to: wrpPt2 [
	^ self
		finalizeCurve: (DrGLinePerpendicularBisector2ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem})
]

{ #category : #helpers }
DrGeoSketch >> plot: f from: x0 to: x1 [
| mobile s pen|
	s := self segment: x0@0 to: x1@0.
	mobile := self pointOnLine: s at: 0.
	pen := self
		point: [:item | item point x @ (f value: item point x)] 
		parent: mobile.
	^ (self locusOf: pen when: mobile) color: Color blue

]

{ #category : #point }
DrGeoSketch >> point: aPointOrBlock [
	^ aPointOrBlock isPoint 
		ifTrue:  [self finalizePoint: (DrGPointFreeItem newWith: {aPointOrBlock})]
		ifFalse: [self finalizePoint: (DrGPointBlockItem newWith: (OrderedCollection with: aPointOrBlock)	)]
]

{ #category : #point }
DrGeoSketch >> point: block parent: wrpValue [
	|collection|
	collection := OrderedCollection with: block.
	collection add: wrpValue mathItem.
	^ self finalizePoint: (DrGPointBlockItem newWith: collection)
]

{ #category : #point }
DrGeoSketch >> point: block parents: wrpValueArray [
	|collection|
	collection := OrderedCollection with: block.
	collection addAll: (wrpValueArray collect: [:wrp | wrp mathItem]).
	^ self finalizePoint: (DrGPointBlockItem newWith: collection)
]

{ #category : #point }
DrGeoSketch >> pointOnLine: wrpCurve at: abscissa [ 
	| item |
	item := DrGPointOncurveItem newWith: {wrpCurve mathItem. 0 @ 0}.
	item setCurveAbscissa: abscissa.
	^ self finalizePoint: item
]

{ #category : #point }
DrGeoSketch >> pointX: wrpValue1 Y: wrpValue2 [
	^ self
		finalizePoint: (DrGPointCoordinateItem  newWith: {wrpValue1 mathItem . wrpValue2 mathItem })
]

{ #category : #'curve filled' }
DrGeoSketch >> polygon: arguments [
	^ self
		finalizeFilledCurve: (DrGPolygonNptsItem  newWith: (arguments collect: [:wrp | 
				(self wrappedPoint: wrp) mathItem]))
]

{ #category : #accessing }
DrGeoSketch >> presenter [
	^ presenter 
]

{ #category : #curve }
DrGeoSketch >> ray: wrpPt1 to: wrpPt2 [
	^ self
		finalizeCurve: (DrGRay2ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem })
]

{ #category : #transformations }
DrGeoSketch >> reflect: wrpItem axis: wrpLine [ 
	self canTransform: wrpItem.
	^ self finalizeTransformation: 'Reflexion' with: {wrpItem mathItem. wrpLine mathItem}
]

{ #category : #'curve filled' }
DrGeoSketch >> regularPolygonCenter: wrpCenter vertex: wrpVertex sides: wrpValue [
	^ self
		finalizeFilledCurve: (DrGPolygonRegularItem newWith: {
			(self wrappedPoint: wrpCenter) mathItem. 
			(self wrappedPoint: wrpVertex) mathItem.
			(self wrappedValue: wrpValue) mathItem})
]

{ #category : #'initialize-release' }
DrGeoSketch >> release [
	presenter ifNotNil: [presenter release].
	presenter := nil.
	self terminateDo 
]

{ #category : #transformations }
DrGeoSketch >> rotate: wrpItem center: wrpCenter angle: wrpValue [ 
	self canTransform: wrpItem.
	^ self finalizeTransformation: 'Rotation' with:  {
		wrpItem mathItem. 
		(self wrappedPoint: wrpCenter) mathItem. 
		(self wrappedValue: wrpValue) mathItem}.
	
]

{ #category : #transformations }
DrGeoSketch >> rotate: wrpItem center: wrpCenter angleDegrees: wrpValue [ 
"Only work when wrpVAlue is a number and not an already existing value item, otherwise it is ignored"
	| convertedValue |
	convertedValue := wrpValue 	isNumber 	ifTrue: [wrpValue degreesToRadians] 		ifFalse: [wrpValue].
	^ self rotate: wrpItem center: wrpCenter angle: convertedValue 
]

{ #category : #'user interface' }
DrGeoSketch >> scale: anInteger [
	"set scale of the canvas"
	presenter drawable 
		setScaleTo: anInteger
]

{ #category : #transformations }
DrGeoSketch >> scale: wrpItem center: wrpCenter factor: wrpValue [ 
	self canTransform: wrpItem.
	^ self finalizeTransformation: 'Homothety' with: {
		wrpItem mathItem. 
		(self wrappedPoint: wrpCenter) mathItem.
		(self wrappedValue: wrpValue) mathItem} 

]

{ #category : #'curve finit' }
DrGeoSketch >> segment: wrpPt1 to: wrpPt2 [
	^ self
		finalizeSegment: (DrGSegment2ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem})
]

{ #category : #value }
DrGeoSketch >> slopeOf: wrpLine [
	^ self
		finalizeValue: (DrGValueSlopeItem newWith: {wrpLine mathItem. self aPosition})
]

{ #category : #transformations }
DrGeoSketch >> symmetry: wrpItem center: wrpCenter [ 
	self canTransform: wrpItem.
	^ self finalizeTransformation: 'Symmetry' with: {
		wrpItem mathItem. 
		(self wrappedPoint: wrpCenter) mathItem}
]

{ #category : #helpers }
DrGeoSketch >> terminateDo [
	doProcess  ifNotNil: [
		doProcess terminate.
		doProcess := nil]
]

{ #category : #text }
DrGeoSketch >> text: aText [
	^ self text:aText at: self aPosition
]

{ #category : #text }
DrGeoSketch >> text: aText at: aPosition [
	| answer |
	presenter notInteractive: true.
	answer := self finalizeText: ((DrGTextItem newWith: {aPosition}) text: aText asText).
	presenter notInteractive: false.
	^ answer
]

{ #category : #transformations }
DrGeoSketch >> translate: wrpItem vector: wrpVector [ 
	self canTransform: wrpItem.
	^ self finalizeTransformation: 'Translation' with: 
		{wrpItem mathItem. 
		(self wrappedVector: wrpVector) mathItem}
]

{ #category : #processing }
DrGeoSketch >> update [
	self domain updateAllMathItems
]

{ #category : #'curve finit' }
DrGeoSketch >> vector: wrpPt [
	^ self
		finalizeCurve: (DrGVector2ptsItem newWith: {
			(self wrappedPoint: 0@0) mathItem. 
			(self wrappedPoint: wrpPt) mathItem})
]

{ #category : #'curve finit' }
DrGeoSketch >> vector: wrpPt1 to: wrpPt2 [ 
	^ self
		finalizeCurve: (DrGVector2ptsItem newWith: {
			(self wrappedPoint: wrpPt1) mathItem. 
			(self wrappedPoint: wrpPt2) mathItem})
]

{ #category : #accessing }
DrGeoSketch >> view [
	^ presenter view
]

{ #category : #point }
DrGeoSketch >> wrappedPoint: aPointOrWrappedPointItem [
"ensure a wrapped point"
	^ aPointOrWrappedPointItem isPoint 
		ifTrue: [(self point: aPointOrWrappedPointItem) hide] 
		ifFalse:   [aPointOrWrappedPointItem]
]

{ #category : #value }
DrGeoSketch >> wrappedValue: aNumberOrWrappedValueItem [
"ensure a wrapped value"
	^ aNumberOrWrappedValueItem  isNumber 
		ifTrue: [(self freeValue: aNumberOrWrappedValueItem ) hide] 
		ifFalse:   [aNumberOrWrappedValueItem]
]

{ #category : #'curve finit' }
DrGeoSketch >> wrappedVector: aVectorOrWrappedVectorItem [
"ensure a wrapped vector"
	^ aVectorOrWrappedVectorItem isPoint 
		ifTrue: [(self vector: aVectorOrWrappedVectorItem) hide] 
		ifFalse:   [aVectorOrWrappedVectorItem]
]
