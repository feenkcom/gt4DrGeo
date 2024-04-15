"
A simplified Debugger window, with translated labels and helps.
"
Class {
	#name : #DrGDebuggerWindow,
	#superclass : #DebuggerWindow,
	#category : #'DrGeo-View-Dialog'
}

{ #category : #'instance creation' }
DrGDebuggerWindow class >> open: model [
	^ self new 
		model: model;
		buildMorphicWindow;
		yourself

]

{ #category : #'GUI building' }
DrGDebuggerWindow >> buildLowerPanes [
	^ LayoutMorph newColumn 
		addMorph: self customButtonRow fixedHeight: self defaultButtonPaneHeight;
		addMorph: self buildMorphicCodePane proportionalHeight: 1.0;
		yourself
]

{ #category : #'GUI building' }
DrGDebuggerWindow >> buildMorphicWindow [
	"Open a full morphic debugger with the given label"

	| bottomMorph |

	self receiverInspector doubleClickSelector: #inspectSelection.
	self contextVariableInspector doubleClickSelector: #inspectSelection.
	"Instantiate, but not used on the GUI"
	self receiverInspectorText.
	
	bottomMorph := LayoutMorph newRow.
	bottomMorph
		addAdjusterAndMorph: self contextVariableInspector proportionalWidth: 0.30;
		addAdjusterAndMorph: self contextVariableInspectorText proportionalWidth: 0.70.

	self layoutMorph
		addAdjusterAndMorph: self buildLowerPanes proportionalHeight: 0.7;
		addAdjusterAndMorph: bottomMorph proportionalHeight: 0.3.
]

{ #category : #'GUI building' }
DrGDebuggerWindow >> customButtonSpecs [
	"Answer an array of elements of the form wording, selector, help-message, that characterize the custom button row of a debugger."

	^{
		{'Restart' translated . #restart	 . 		'Restart the step by step execution from its start.' translated } .
		{'Step'	 translated . 	#doStep .			 'Execute the current message and go to the next message.' translated } .
		{'Step into'		 translated . #stepIntoBlock		 . 'Step into a block.' translated } .
		{'Run to Cursor' translated . #runToCursor	 . 	'Execute the code up to the cursor position.' translated }
	}
]

{ #category : #'GUI building' }
DrGDebuggerWindow >> initialExtent [
	^ 600 @ 400
]

{ #category : #accessing }
DrGDebuggerWindow >> layerNumber [
	^ 50
]
