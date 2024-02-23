Class {
	#name : #DrGMutatorToolStateDragged,
	#superclass : #DrGSelectToolStateDragged,
	#instVars : [
		'mutator',
		'originalPointClass'
	],
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #accessing }
DrGMutatorToolStateDragged >> context: aContext [
	super context: aContext.
	originalPointClass := context mathItem class.
]

{ #category : #handling }
DrGMutatorToolStateDragged >> handleMouseAt: aPoint [
	| morphs aTip|
	"First handle the redraw"
	super handleMouseAt: aPoint.
	"Detect for mutation candidate"
	morphs := self context curvesToMutatePointIntoNear: aPoint.
	(morphs isEmpty and: [self isMutantFreePoint not]) ifTrue: [
		aTip := 'Change as a free point on the plane.' translated].
	morphs size = 1 ifTrue: [
		aTip := 'Change as a free point on this curve.' translated].
	morphs size > 1 ifTrue: [
		aTip := 'Change as this intersection.' translated].
	aTip 
		ifNil: [self drawable hideTip]
		ifNotNil: [self drawable tip: aTip at: aPoint].
	^ aTip isNil not
]

{ #category : #handling }
DrGMutatorToolStateDragged >> handleRelease: aPoint [
	| morphs |
	self drawable hideTip.
	"Detect for mutation candidate"
	morphs := self context curvesToMutatePointIntoNear: aPoint.
	morphs size = 1 ifTrue: [
		self context domain
			mutate: self mathItem 
			asFreeOn: morphs first mathItem 
			at: (self drawable gridWorldPoint: aPoint)].
	morphs size > 1 ifTrue: [
		self context domain 
			mutate: self mathItem 
			asIntersectionWith: morphs first mathItem  
			and: morphs second mathItem  
			at: (self drawable gridWorldPoint: aPoint)]. 
	self presenter saved: false.
	self switchState: DrGSelectToolStateNeutral.
	self context reset

]

{ #category : #'as yet unclassified' }
DrGMutatorToolStateDragged >> isMutantFreePoint [
	^ originalPointClass = DrGPointFreeItem
]
