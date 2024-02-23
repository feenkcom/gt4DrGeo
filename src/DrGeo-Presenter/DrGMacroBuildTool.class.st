Class {
	#name : #DrGMacroBuildTool,
	#superclass : #DrGBuildTool,
	#category : #'DrGeo-Presenter-Tool'
}

{ #category : #updating }
DrGMacroBuildTool >> cancel [
	"the builder informs us the user wants to cancel the macro building process"
	presenter move.
]

{ #category : #'initialize-release' }
DrGMacroBuildTool >> initialize [
	super initialize.
	self switchState: DrGMacroToolStateNeutral 
]

{ #category : #'initialize-release' }
DrGMacroBuildTool >> registerDependant: anObject [
	builder when: #changedState send: #switchState: to: self.
	builder when: #cancel send: #cancel to: self.
	builder when: #readyToBuild send: #readyToBuildMacro to: anObject
]

{ #category : #accessing }
DrGMacroBuildTool >> relevantMorphsNear: aPoint [
	^self pointMorphsFirstNear: aPoint 
]

{ #category : #accessing }
DrGMacroBuildTool >> selectInputMorph [
	self selectMorphsFrom: builder input
]

{ #category : #accessing }
DrGMacroBuildTool >> selectMorphsFrom: aMathItemCollection [ 
	presenter ifNil: [^self].
	self stopBlinking.
	selectedMorphs := self drawable viewsOf: aMathItemCollection.
	self startBlinking
]

{ #category : #accessing }
DrGMacroBuildTool >> selectNoMorph [
	self selectMorphsFrom: OrderedCollection new
]

{ #category : #accessing }
DrGMacroBuildTool >> selectOutputMorph [
	self selectMorphsFrom: builder output
]
