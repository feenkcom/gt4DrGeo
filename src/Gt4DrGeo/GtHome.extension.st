Extension { #name : #GtHome }

{ #category : #'*Gt4DrGeo' }
GtHome >> drGeoSection [
	<gtHomeSection>
	^ GtHomeStartPageSection new 
		title: 'Dr Geo';
		description: 'Porting Dr Geo to GT';
		databaseName: 'feenkcom/gt4DrGeo/lepiter';
		startPageName: 'Porting Dr Geo';
		priority: 10
]
