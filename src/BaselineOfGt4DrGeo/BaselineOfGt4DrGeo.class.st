Class {
	#name : #BaselineOfGt4DrGeo,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4DrGeo
}

{ #category : #loading }
BaselineOfGt4DrGeo class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4DrGeo' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baselines }
BaselineOfGt4DrGeo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'Gt4DrGeo'.
			spec package: 'DrGeo' ]
]
