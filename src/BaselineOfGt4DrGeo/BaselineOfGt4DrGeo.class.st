Class {
	#name : #BaselineOfGt4DrGeo,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4DrGeo
}

{ #category : #accessing }
BaselineOfGt4DrGeo >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'Gt4DrGeo' ]
]
