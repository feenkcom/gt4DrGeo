"
This is the macro player activated when the user directly selects a macro from the macro-menu in the toolbar. This player does not show up the usual wizard to select the macro to play as it is already selected from the menu.
"
Class {
	#name : #DrGMacroPlayerHeadless,
	#superclass : #DrGMacroPlayer,
	#category : #'DrGeo-Presenter-Builder'
}

{ #category : #'initialize-release' }
DrGMacroPlayerHeadless >> initialize [ 
	input := OrderedCollection new.

]

{ #category : #'initialize-release' }
DrGMacroPlayerHeadless >> release [
]
