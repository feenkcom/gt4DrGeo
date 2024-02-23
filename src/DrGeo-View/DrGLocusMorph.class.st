"
- free: the mobile point on a line
- constrainted: a point dependant to the free point, we want to compute its locus
- samples : a linked list of DrGLocusSample
- minAbscissaDelta : the minimum abscissa delta between two samples
- maxAbscissaDelta : the maximum abscissa delta between two samples
- maxScreenDelta : the maximum delta between two samples in the screen
"
Class {
	#name : #DrGLocusMorph,
	#superclass : #DrGPolylineMorph,
	#instVars : [
		'free',
		'constrained',
		'minAbscissaDelta',
		'maxScreenDelta',
		'maxAbscissaDelta',
		'freeIndex',
		'constrainedIndex',
		'samples',
		'worldBound'
	],
	#category : #'DrGeo-View-Item'
}

{ #category : #testing }
DrGLocusMorph >> canBeDrawn [
	^ vertices isEmptyOrNil not
]

{ #category : #testing }
DrGLocusMorph >> containsPoint: localPoint [
	^ self containsPointInWorld: localPoint
]

{ #category : #drawing }
DrGLocusMorph >> drawOn: aCanvas [ 
	| prevPoint p |
	self isDrawNeeded ifFalse: [^ self].
	self getVertices.
	self canBeDrawn ifFalse: [^ self].
	self updateLabelStatus.
	prevPoint := vertices first.
	aCanvas strokeWidth: borderWidth color: borderColor 
	strokeDashArray: dashedBorder strokeDashArrayOffset: 0.0  do: [
		aCanvas moveTo: prevPoint.
		2 to: vertices	 size do: [:i |
			p := vertices at: i.
			(prevPoint squaredDistanceTo: p) < 900
				ifTrue: [aCanvas lineTo: p]
				ifFalse: [aCanvas moveTo: p].
			prevPoint := p]
		]

]

{ #category : #accessing }
DrGLocusMorph >> factory [
	^ self domain factory
]

{ #category : #sampling }
DrGLocusMorph >> free: freeItem constrained: constrainedItem [ 
	| link0 link1 x0 validSamples factory  |
	x0 := freeItem abscissa.
	factory := self factory.
	worldBound := self drawable worldBound.
	free := freeItem.
	constrained := constrainedItem.
	freeIndex := factory indexOf: free.
	constrainedIndex := factory indexOf: constrained.
	"maxAbscissaDelta := self drawable scale > 100 ifTrue: [1e-4] ifFalse: [1e-3]."
	samples := LinkedList new.
	link0 := samples add: (self sample: minAbscissaDelta ).
	link1 := samples add: (self sample: 1 - minAbscissaDelta) afterLink: link0.
	self samplingFrom: link0 to: link1.
	validSamples := self selectValidSamples.
	free abscissa: x0.
	factory updateAllMathItemsButLocusFrom: freeIndex to: constrainedIndex.
	mathItem
		points: (validSamples	 collect: [:s | s pointWorld]);
		samplesQty: validSamples size.
	vertices := validSamples collect: [:s | s pointScreen].
]

{ #category : #accessing }
DrGLocusMorph >> getVertices [
	self free: mathItem freePoint constrained: mathItem constrainedPoint.
]

{ #category : #initialization }
DrGLocusMorph >> initialize [
	super initialize.
	minAbscissaDelta := 1e-5.
	maxScreenDelta := 64.
	maxAbscissaDelta := 1e-1
]

{ #category : #'testing type' }
DrGLocusMorph >> isLocus [
	^ true
]

{ #category : #sampling }
DrGLocusMorph >> sample: abscissa [ 
"Create a new sample with the given curvilinear abscissa"
	| sample |
	sample := DrGLocusSample new x: abscissa.
	free abscissa: abscissa.
	self factory updateAllMathItemsButLocusFrom: freeIndex to: constrainedIndex.
	(sample isValid: constrained exist) ifTrue: 
		[sample pointWorld: constrained point;
		pointScreen: (self drawable worldToMorph: constrained point);
		offScreen: (worldBound containsPoint: constrained point) not].
	^ sample
]

{ #category : #sampling }
DrGLocusMorph >> samplingFrom: sample1 to: sample2 [
	| newSample screenSamplesDistance samplesDelta|
	samplesDelta := sample2 x - sample1 x.
	screenSamplesDistance := 10.
	(samplesDelta > minAbscissaDelta
		and: [(sample1 isNotValid or: [sample2 isNotValid]) 
			or: [samplesDelta > maxAbscissaDelta
				or: [(screenSamplesDistance  := sample1 pointScreen squaredDistanceTo: sample2 pointScreen) > maxScreenDelta]]])
		ifTrue: [
			(screenSamplesDistance < 2 and: [samplesDelta < maxAbscissaDelta] ) ifTrue: [^ self].
			newSample := self sample: sample1 x + sample2 x / 2.0.
			samples add: newSample afterLink: sample1.
			self samplingFrom: sample1 to: newSample.
			self samplingFrom: newSample to: sample2			]
]

{ #category : #sampling }
DrGLocusMorph >> selectValidSamples [
	| validSamples prevLink|
	validSamples := OrderedCollection new.
	prevLink := DrGLocusSample new isValid: false; yourself.
	samples 	linksDo: [:sample | 
		sample isValidAndOnScreen 		
			ifTrue: [validSamples add: sample]
			ifFalse: [
			"unvalid or offscreen, in case it is just offscreen check if next/prev sample is on-screen, 
			so we need 		this sample for the drawing"
				sample isValid ifTrue: [
					sample nextLink ifNotNil: [:nextSample | 
						nextSample isValidAndOnScreen 
							ifTrue: [validSamples add: sample]
							ifFalse: [prevLink isValidAndOnScreen ifTrue: [validSamples add: sample]]
							]
						]
					].
				prevLink := sample].
	^ validSamples 
]

{ #category : #accessing }
DrGLocusMorph >> styleClass [
	^ DrGLocusStyle
]

{ #category : #label }
DrGLocusMorph >> updateLabelStatus [
"In some circumstance, I may be unable to draw myself. So I need to update my label status accordingly"
	labelMorph ifNotNil: [
		self isDrawNeeded 
			ifTrue:[
				labelMorph owner ifNil: [self drawable addMorph: labelMorph].
				labelMorph show; morphPosition: self labelPosition]
			ifFalse: [labelMorph hide]	]
]
