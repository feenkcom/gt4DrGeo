Extension { #name : #PreferenceBrowserVisitor }

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypeArrowPreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #arrowMorphCollection 
		indexGetter: #arrowIndex 
		indexSetter: #arrowIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypeColorPreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #colorMorphCollection 
		indexGetter: #colorIndex 
		indexSetter: #colorIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypeMarkPreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #markMorphCollection 
		indexGetter: #markIndex 
		indexSetter: #markIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypePointShapePreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #shapeMorphCollection 
		indexGetter: #pointShapeIndex 
		indexSetter: #pointShapeIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypePointSizePreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #sizeMorphCollection 
		indexGetter: #pointSizeIndex 
		indexSetter: #pointSizeIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypeStylePreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #styleMorphCollection 
		indexGetter: #styleIndex 
		indexSetter: #styleIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]

{ #category : #'*DrGeo-visitors type' }
PreferenceBrowserVisitor >> visitDrGTypeThicknessPreference: aPref [
	| listMorph |
	listMorph  := (DropDownButtonMorph 
		model: aPref type 
		listGetter: #thicknessMorphCollection 
		indexGetter: #thicknessIndex 
		indexSetter: #thicknessIndex:)
		autoDeselect: false;
		setBalloonText: aPref description.
	views at: aPref nameDetailed put: listMorph
]
