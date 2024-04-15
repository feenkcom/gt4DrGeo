"
I am an abstract class to modelise access to plateform preferences and information.
Pattern: strategy
"
Class {
	#name : #DrGPlatform,
	#superclass : #Object,
	#instVars : [
		'toolbarIconSize',
		'canWeDisplaySpinner',
		'preferences',
		'fontManager'
	],
	#category : #'DrGeo-System'
}

{ #category : #'default preferences' }
DrGPlatform >> arcPreferences [
" name - description - category - type - value "
| category |
	category := #arc translated asSymbol.
	^ {
	{#arcColor. 'Colour' translated. category.	DrGTypeColor with: #arcColor in: preferences. Color black} .
	{#arcThickness.	'Thickness' translated. category. DrGTypeThickness with: #arcThickness in: preferences. #small}.
	{#arcStyle. 'Style' translated. category. DrGTypeStyle with: #arcStyle in: preferences. #plain}.
	{#arcArrow. 'Arrow' translated. category. DrGTypeArrow with: #arcArrow in: preferences. #none	}.
	{#arcFilled. 'Fill' translated. category. Boolean. false} .
	{#arcTranslucent. 'Translucent' translated. category. Boolean. false}
	}
]

{ #category : #'initialize-release' }
DrGPlatform >> backgroundImage [
	WorldMorph allInstances first backgroundImageData: 	
		(DrGeoSystem backgroundsPath files 
			atRandom: (Random  seed: Time now 	nanoSecond))  binaryContents 
]

{ #category : #path }
DrGPlatform >> backgroundsPath [
	^ self iconsPath / 'backgrounds'
]

{ #category : #accessing }
DrGPlatform >> canWeDisplaySpinner [
	^ canWeDisplaySpinner
]

{ #category : #font }
DrGPlatform >> canvasFontSize [
	^ 9
]

{ #category : #'initialize-release' }
DrGPlatform >> checkForPaths [
	self mySketchesPath assureExistence.
	self mySmalltalkSketchesPath assureExistence 
]

{ #category : #'default preferences' }
DrGPlatform >> circlePreferences [
" name - description - category - type - value "
| category |
	category := #circle translated asSymbol.
	^ {
	{#circleColor. 'Colour' translated. category. DrGTypeColor with: #circleColor in: preferences. Color black} .
	{#circleThickness. 'Thickness' translated. category. DrGTypeThickness with: #circleThickness in: preferences. #small} .
	{#circleStyle. 'Style' translated. category. DrGTypeStyle with: #circleStyle in: preferences. #plain} .
	{#circleFilled. 'Fill' translated. category. Boolean. false} .
	{#circleTranslucent. 'Translucent' translated. category. Boolean. false}
	}
]

{ #category : #path }
DrGPlatform >> examplesPath [
	^ self resourcesPath / 'Sketches'
]

{ #category : #font }
DrGPlatform >> fontManager [
	^ fontManager ifNil: [fontManager := self initFontManager]
]

{ #category : #path }
DrGPlatform >> fontPath [
	^  self resourcesPath / 'fonts'
]

{ #category : #path }
DrGPlatform >> iconsPath [
	^ self resourcesPath / 'icons'
]

{ #category : #font }
DrGPlatform >> initFontManager [
	| font |
	fontManager := LanguageFontManager new.
	font := LanguageFont family: 'IPAexGothic' file: 'ipaexg.ttf'.
	font addLocale: (LocaleID isoLanguage: 'ja').
	fontManager add: font.
	font := LanguageFont family: 'WenQuanYi Zen Hei Sharp' file: 'WenQuanYiZenHeiSharpRegular.ttf'.
	font 
		addLocale:(LocaleID isoLanguage: 'zh');
		addLocale: (LocaleID isoLanguage: 'ko').
	fontManager add: font.

]

{ #category : #testing }
DrGPlatform >> isAndroid [
	^ false
]

{ #category : #testing }
DrGPlatform >> isSystem [
"Preferences for a DrGeo development environment"
	^ false
]

{ #category : #testing }
DrGPlatform >> isWorkstation [
"Preferences for Windows/Linux/Mac workstation"
	^ false
]

{ #category : #testing }
DrGPlatform >> isiPad [
	^ false
]

{ #category : #'default preferences' }
DrGPlatform >> linePreferences [
" name - description - category - type - value "
| category |
	category := #line translated asSymbol.
	^ {
	{#lineColor. 'Colour' translated. category. DrGTypeColor with: #lineColor in: preferences. Color black} .
	{#lineThickness. 'Thickness' translated. category. DrGTypeThickness with: #lineThickness in: preferences. #small} .
	{#lineStyle. 'Style' translated. category. DrGTypeStyle with: #lineStyle in: preferences. #plain}
	}
]

{ #category : #'default preferences' }
DrGPlatform >> locusPreferences [
" name - description - category - type - value "
| category |
	category := #locus translated asSymbol.
	^ {
	{#locusColor. 'Colour' translated. category. DrGTypeColor with: #locusColor in: preferences. Color black} .
	{#locusThickness. 'Thickness' translated. category. DrGTypeThickness with: #locusThickness in: preferences. #small} .
	{#locusStyle. 'Style' translated. category. DrGTypeStyle with: #locusStyle in: preferences. #plain}
	}
]

{ #category : #'default preferences' }
DrGPlatform >> miscPreferences [
" name - description - category - type - value "
| category |
	category := #miscellaneous translated asSymbol.
	^ {
	{#userPath. 'Path for user created resources as sketches, Smalltalk sketches, exported image. An empty path locates these resources in the Dr. Geo application folder. Relative path accepted, home/user directory is then prepended' translated. category. nil. ''} .
	{#autoName. 'Autoname new object' translated. category. Boolean. false} .
	{#advancedDebugger. 'Full debugger when executing Smalltalk sketch.' . category. Boolean. true }
	}
]

{ #category : #path }
DrGPlatform >> myExportsPath [
	^ self userPath / 'MyExports'
]

{ #category : #path }
DrGPlatform >> mySketchesPath [
	^self userPath / 'MySketches'
]

{ #category : #path }
DrGPlatform >> mySmalltalkSketchesPath [
	^self userPath / 'MySmalltalkSketches'
]

{ #category : #'default preferences' }
DrGPlatform >> pointPreferences [
" name - description - category - type - value "
| category |
	category := #point translated asSymbol.
	^ {
	{#pointColor. 'Colour' translated. category. DrGTypeColor with: #pointColor in: preferences. Color red} .
	{#pointSize. 'Size' translated. category. DrGTypePointSize with: #pointSize in: preferences. #small}	.
	{#pointShape. 'Shape' translated. category. DrGTypePointShape with: #pointShape in: preferences. #cross}
	}
]

{ #category : #'default preferences' }
DrGPlatform >> polygonPreferences [
" name - description - category - type - value "
| category |
	category := #polygon translated asSymbol.
	^ {
	{#polygonColor. 'Colour' translated. category. DrGTypeColor with: #polygonColor in: preferences. Color black} .
	{#polygonThickness. 'Thickness' translated. category. DrGTypeThickness with: #polygonThickness in: preferences. #small} .
	{#polygonStyle. 'Style' translated. category. DrGTypeStyle with: #polygonStyle in: preferences. #plain} .
	{#polygonFilled. 'Fill' translated. category. Boolean. false} .
	{#polygonTranslucent. 'Translucent' translated. category. Boolean. false}
	}
]

{ #category : #accessing }
DrGPlatform >> preferences [
	^ preferences ifNil: [self setDefaultPreferences]
]

{ #category : #'default preferences' }
DrGPlatform >> programmingPreferences [
" name - description - category - type - value "
| category |
	category := #programming translated asSymbol.
	^ {
	{#programmingCodeCompletion. 'Code completion on' translated. category. nil . DrGeoSketch}
	}
]

{ #category : #'default preferences' }
DrGPlatform >> rayPreferences [
" name - description - category - type - value "
| category |
	category := #ray translated asSymbol.
	^ {
	{#rayColor. 'Colour' translated. category. DrGTypeColor with: #rayColor in: preferences. Color black}.
	{#rayThickness. 'Thickness' translated. category.	DrGTypeThickness with: #rayThickness in: preferences. #small} .
	{#rayStyle. 'Style' translated. category. DrGTypeStyle with: #rayStyle in: preferences. #plain}
	}
]

{ #category : #'initialize-release' }
DrGPlatform >> reset [
	toolbarIconSize := nil.
	preferences := nil
]

{ #category : #path }
DrGPlatform >> resourcesPath [
"Where are located folders for icons, fonts, sketches, scripts, documentation, images, user created resources"
	^ self rootPath / 'Resources'
]

{ #category : #path }
DrGPlatform >> rootPath [
"When deployed, the DrGeo/ directory"
	^ DirectoryEntry smalltalkImageDirectory parent parent
]

{ #category : #'default preferences' }
DrGPlatform >> segmentPreferences [
" name - description - category - type - value "
| category |
	category := #segment translated asSymbol.
	^ {
	{#segmentColor. 'Colour' translated. category.	DrGTypeColor with: #segmentColor in: preferences. Color black} .
	{#segmentThickness.	'Thickness' translated. category. DrGTypeThickness with: #segmentThickness in: preferences. #small} .
	{#segmentStyle. 'Style' translated. category. DrGTypeStyle with: #segmentStyle in: preferences. #plain} .
	{#segmentMark. 'Mark' translated. category. DrGTypeMark with: #segmentMark in: preferences. #none} .
	{#segmentArrow. 'Arrow' translated. category. DrGTypeArrow with: #segmentArrow in: preferences. #none	}
	}
]

{ #category : #'initialize-release' }
DrGPlatform >> setCodeCompletion [
	| class |
	class := Locale current isoLanguage asSymbol 
		caseOf: {
			[#fr] -> [DrGeoFigure].
			[#es] -> [DrGeoFigura]
			}
		 otherwise: [DrGeoSketch].
	DrGeoSystem preferences at: #programmingCodeCompletion put: class
]

{ #category : #'initialize-release' }
DrGPlatform >> setDefaultPreferences [
	preferences := PreferenceSet new.
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
	^ preferences
]

{ #category : #font }
DrGPlatform >> setFontPreferences [
	| languageFont |
	" Pick an appropriate font file for the current locale, if necessary "
	languageFont := self fontManager languageFontFor: Locale current.
	languageFont ifNotNil: [
		TrueTypeFontFamily readTrueTypeFontEntry: self fontPath // languageFont file.
		PreferenceSet setDefaultFont: languageFont family	].
	Preferences at: #defaultFontSize put: 12
]

{ #category : #'user interface' }
DrGPlatform >> showVirtualKeyboard: boolean [

]

{ #category : #path }
DrGPlatform >> smalltalkSketchesPath [
	^self resourcesPath / 'SmalltalkSketches'
]

{ #category : #'initialize-release' }
DrGPlatform >> splash [
| splash copy  background position path |
	path := 	DrGeoSystem iconsPath.
	"path := path parent / 'banner'."
	path print.
	splash := ImageReadWriter formFromFileEntry: path // 'splash.png'.
	position := Display center - (splash extent // 2).
	background := Form fromDisplay: (position extent: splash extent).
	0.0 to: 1.0 by: 0.2 do: [:t |
		copy := background copy.
		copy copyBits: splash at: 0@0 translucent: t.
		copy displayAt:  position.
		(Delay forMilliseconds: 100) wait].
	(Delay forSeconds: 2) wait.
	background displayAt: position
]

{ #category : #'initialize-release' }
DrGPlatform >> startUp [
	self setFontPreferences.
	Transcript show: '[DrGeo] Font installed'; cr.
	self checkForPaths.
	Transcript show: '[DrGeo] Paths checked'; cr.
	self setCodeCompletion.
	Transcript show: '[DrGeo] Code completion set'; cr.
]

{ #category : #'default preferences' }
DrGPlatform >> textPreferences [
" name - description - category - type - value "
| category |
	category := #text translated asSymbol.
	^ {
	{#textColor. 'Colour' translated. category. DrGTypeColor with: #textColor in: preferences. Color black} .
	{#textBackgroundColor. 'Background' translated. category. DrGTypeColor with: #textBackgroundColor in: preferences. Color white }.
	{#textBorderColor. 'Border' translated. category. DrGTypeColor with: #textBorderColor in: preferences. Color white }.	
	}
]

{ #category : #'user interface' }
DrGPlatform >> toggleFullscreen [
	| isFullscreen |
	isFullscreen := [ Preferences at: #fullscreen ] 
		on: Error 
		do: [Preferences name: #fullscreen category: #gui value: true.
			true].
	Preferences at: #fullscreen put: isFullscreen not.
	Display fullScreenMode: isFullscreen not
]

{ #category : #path }
DrGPlatform >> userPath [
"Where are located user created resources as sketch, Smalltalk sketch and exported sketch to image"
	^ (self preferences at: #userPath) 
		ifNotEmpty: [:userPath | | userDirectoryEntry |
			userDirectoryEntry := userPath asDirectoryEntry .
			" Check if it is a relative path or an absolute path "
			userDirectoryEntry pathName = userPath
				ifTrue: [userDirectoryEntry "Absolute path"]
				ifFalse: ["Relative path, append the home/user directory if any"
					Smalltalk at: #home 
						ifPresent: [:home |			home / userPath]
						ifAbsent: [userDirectoryEntry ] ] ]
		ifEmpty: [self resourcesPath]
		
]

{ #category : #'default preferences' }
DrGPlatform >> valuePreferences [
" name - description - category - type - value "
| category |
	category := #value translated asSymbol.
	^ {
	{#valueColor. 'Colour' translated. category. DrGTypeColor with: #valueColor in: preferences. Color black} .
	{#valueDecimal. 'Number of decimal' translated. category. (0 to: 9) asArray. 2}
	}
]

{ #category : #'default preferences' }
DrGPlatform >> vectorPreferences [
" name - description - category - type - value "
| category |
	category := #vector translated asSymbol.
	^ {
	{#vectorColor. 'Colour' translated. category. DrGTypeColor with: #vectorColor in: preferences. Color black} .
	{#vectorThickness. 'Thickness' translated. category. DrGTypeThickness with: #vectorThickness in: preferences. #small} .
	{#vectorStyle. 'Style' translated. category. DrGTypeStyle with: #vectorStyle in: preferences. #plain}
	}
]
