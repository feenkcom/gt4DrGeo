Extension { #name : #Class }

{ #category : #'*DrGeo-subclass creation' }
Class >> xsubclass: t instanceVariableNames: f classVariableNames: d package: cat [
"This is a hack to import DrGeo Pharo code"
	
	| answer |
	answer := ClassBuilder new
		superclass: self
		subclass: t
		instanceVariableNames: f
		classVariableNames: d
		poolDictionaries: nil
		category: cat.
		
	Smalltalk
		logChange: answer definition 
		preamble: answer definitionPreamble.
	^answer

]
