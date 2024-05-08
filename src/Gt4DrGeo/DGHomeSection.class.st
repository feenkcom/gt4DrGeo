"
I define the cards for the GT Home when this repo is loaded.
"
Class {
	#name : #DGHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'Gt4DrGeo-Sections'
}

{ #category : #accessing }
DGHomeSection >> defaultPriority [
	^ 5
]

{ #category : #accessing }
DGHomeSection >> drGeoCard [
	<gtSectionCard>
	<gtExample>
	^ GtHomeCard page
		title: 'Dr Geo';
		description: 'Porting Dr Geo to GT';
		databaseName: 'DrGeoLepiter';
		pageName: 'Dr Geo';
		priority: 10;
		assertInvariant;
		yourself
]

{ #category : #accessing }
DGHomeSection >> sectionTitle [
	^ 'Dr Geo project'
]
