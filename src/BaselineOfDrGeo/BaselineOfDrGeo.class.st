Class {
	#name : #BaselineOfDrGeo,
	#superclass : #BaselineOf,
	#category : #BaselineOfDrGeo
}

{ #category : #baselines }
BaselineOfDrGeo >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'DrGeo' ]
]
