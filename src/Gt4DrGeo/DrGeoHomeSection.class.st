Class {
	#name : #DrGeoHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'Gt4DrGeo-Sections'
}

{ #category : #accessing }
DrGeoHomeSection >> drGeoCard [
	<gtSectionCard>
	<gtExample>
	^ GtHomeCard page
		title: 'Dr Geo';
		description: 'Porting Dr Geo to GT';
		databaseName: 'feenkcom/gt4DrGeo/lepiter';
		pageName: 'Dr Geo';
		priority: 10;
		assertInvariant;
		yourself
]

{ #category : #accessing }
DrGeoHomeSection >> sectionTitle [
	^ 'Dr Geo project'
]
