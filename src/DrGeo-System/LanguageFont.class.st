"
Associate several LocaleIDs (fr_FR, zh_TW, zh_CN, ko) (with or without country code) with an appropriate font.
- locales : a collection of LocaleID
- family : a String, font family name
- file : a String, file name of the font
"
Class {
	#name : #LanguageFont,
	#superclass : #Object,
	#instVars : [
		'locales',
		'family',
		'file'
	],
	#category : #'DrGeo-System'
}

{ #category : #'instance creation' }
LanguageFont class >> family: aString1 file: aString2 [
	^ self new
		family: aString1;
		file: aString2 ;
		yourself
]

{ #category : #accessing }
LanguageFont >> addLocale: aLocaleID [
	locales add: aLocaleID 
]

{ #category : #accessing }
LanguageFont >> family [
	^ family
]

{ #category : #accessing }
LanguageFont >> family: aFamilyFont [
	family := aFamilyFont 
]

{ #category : #accessing }
LanguageFont >> file [
	^ file 
]

{ #category : #accessing }
LanguageFont >> file: aFontFile [
	file := aFontFile 
]

{ #category : #accessing }
LanguageFont >> handles: aLocaleID [
	^  aLocaleID isoCountry 
		ifNotNil:  [
			(locales includes: aLocaleID) or: [
				"may be some locale indicate not country, check if it is a match for aLocaleID "
				locales anySatisfy: [:each |
					each isoCountry isNil and: [each isoLanguage = aLocaleID isoLanguage] ] ]
				]
		ifNil: [locales anySatisfy: [:each | each isoLanguage = aLocaleID isoLanguage] ].

]

{ #category : #initialization }
LanguageFont >> initialize [
	super initialize.
	locales := OrderedCollection new
]

{ #category : #printing }
LanguageFont >> printOn: str [
	str nextPutAll: 'LanguageFont for '.
	locales 
		do: [:each |str nextPutAll: each isoString] 
		separatedBy: [str nextPut: Character space]
	
]
