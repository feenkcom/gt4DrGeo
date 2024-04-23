"
Platform preferences for GT.
"
Class {
	#name : #DGPlatform,
	#superclass : #DrGPlatform,
	#category : #'Gt4DrGeo-System'
}

{ #category : #accessing }
DGPlatform >> setDefaultPreferences [
	"preferences := PreferenceSet new.
	#(pointPreferences linePreferences 	rayPreferences segmentPreferences 	circlePreferences 
	arcPreferences polygonPreferences vectorPreferences locusPreferences
	textPreferences valuePreferences programmingPreferences miscPreferences) do: [:preferencesData|
		(self perform: preferencesData) do: [:data |
			preferences 
				name: data first
				description: data second 
				category: data third 
				type: data fourth
				value: data fifth ] ].
	^ preferences"
	^ Dictionary new
]
