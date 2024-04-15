"
A panel to edit the style of items in the DrGeo canvas (drawable)
"
Class {
	#name : #DrGStylePanel,
	#superclass : #Panel,
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'GUI building' }
DrGStylePanel >> buildMorphicWindow [
	| labelWidth widgets |
	titleMorph showButtonsNamed: #(#close).
	self layoutMorph separation: (Theme current scale: 4) ;
		axisEdgeWeight: #columnTop.
	widgets := model styleWidget.
	labelWidth := widgets max: [:rowOfMorph | (self searchLabelIn: 		rowOfMorph) morphWidth].
	widgets do: [:rowOfMorph |
		(self searchLabelIn: rowOfMorph) morphWidth: labelWidth.
		self addMorph: rowOfMorph].
	self morphExtent: self minimumExtent 
	
]

{ #category : #'as yet unclassified' }
DrGStylePanel >> defaultColor [
	^ self windowColor 
]

{ #category : #'GUI building' }
DrGStylePanel >> searchLabelIn: aMorph [
" Dirty, search for the label morph "
	(aMorph isKindOf: LabelMorph)
		ifTrue: [^ aMorph]
		ifFalse: [
			aMorph submorphs do: [:each |		 
				(self searchLabelIn: each) ifNotNil: [:found | ^ found  ] ]		].
		^ nil	
				
				
				
		
]

{ #category : #'as yet unclassified' }
DrGStylePanel >> windowColor [
	^ Theme current transcript 
]
