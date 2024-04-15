Extension { #name : #Debugger }

{ #category : #'*DrGeo' }
Debugger class >> openMinimalDebugging: aBlock to: aCompiledMethod [ 
	"Create a new process to debug aBlock, and step into it."

	| processToDebug debugger window |
	debugger := self new.
	processToDebug := aBlock newProcess name: 'debugIt'.
	debugger process: processToDebug context: processToDebug suspendedContext.
	window := debugger openMinimalMorphic.
	[debugger interruptedContext method == aCompiledMethod]
		whileFalse: [debugger send].
	^ window 
]

{ #category : #'*DrGeo' }
Debugger class >> openMinimalDebuggingProcess: process context: context [
"Open a Minimal Debugger on an existing process."
	| debugger |
	<primitive: 19> "Simulation guard"

	debugger := self new.
	debugger process: process context: context.
	^ debugger openMinimalMorphic.
	
]

{ #category : #'*DrGeo' }
Debugger >> openMinimalMorphic [
	"Open a panel debugger"

	| oldContextStackIndex window |
	oldContextStackIndex := contextStackIndex.
	self expandStack. "Sets contextStackIndex to zero."

	window := DrGDebuggerWindow open: self .
	self toggleContextStackIndex: oldContextStackIndex.
	^ window
]
