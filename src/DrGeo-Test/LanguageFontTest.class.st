Class {
	#name : #LanguageFontTest,
	#superclass : #TestCase,
	#instVars : [
		'fontManager'
	],
	#category : #'DrGeo-Test'
}

{ #category : #'setUp/tearDown' }
LanguageFontTest >> setUp [
	| font |
	fontManager := LanguageFontManager new.
	font := LanguageFont family: 'UnDotum' file: 'UnDotum.ttf'.
	font addLocale: (LocaleID isoString: 'ko-KO');
		addLocale: (LocaleID isoString: 'zh-TW').
	fontManager add: font.
	font := LanguageFont family: 'Klingon' file: 'Klingon.ttf'.
	font addLocale: (LocaleID isoLanguage: 'kl').
	fontManager add: font
]

{ #category : #testing }
LanguageFontTest >> testChinese [
" No font for Mandarin in China "
	| font |
	font := fontManager languageFontFor: (LocaleID isoString: 'zh-CN').
	self assert: font isNil
]

{ #category : #testing }
LanguageFontTest >> testEuropean [
" European languages use the default font in Cuis "
	self assert: (fontManager languageFontFor: (LocaleID isoString: 'fr-FR')) isNil.
	self assert: (fontManager languageFontFor: (LocaleID isoLanguage: 'fr')) isNil
]

{ #category : #testing }
LanguageFontTest >> testKlingonOnEarth [
" font for Klingo wathever the country  "
	| font |
	font := fontManager languageFontFor: (LocaleID isoString: 'kl-SOL').
	self assert: font notNil.
	self assert: font family = 'Klingon'
]

{ #category : #testing }
LanguageFontTest >> testKorean [
" Font for Korean in Korea "
	| font |
	font := fontManager languageFontFor: (LocaleID isoString: 'ko-KO').
	self assert: font family = 'UnDotum'.
	font := fontManager languageFontFor: (LocaleID isoLanguage: 'ko').
	self assert: font notNil
]

{ #category : #testing }
LanguageFontTest >> testMandarin [
" Font for Mandarin, whatever the country TW, HK, CN "
	| font |
	font := fontManager languageFontFor: (LocaleID isoLanguage: 'zh').
	self assert: font family = 'UnDotum'
]

{ #category : #testing }
LanguageFontTest >> testTaiwan [
" Font for Mandarin in Taiwan "
	| font |
	font := fontManager languageFontFor: (LocaleID isoString: 'zh-TW').
	self assert: font family = 'UnDotum'
]

{ #category : #testing }
LanguageFontTest >> testThai [
" No font for Thai, with and without country code "
	| font |
	font := fontManager languageFontFor: (LocaleID isoString: 'th-TH').
	self assert: font isNil.
		font := fontManager languageFontFor: (LocaleID isoLanguage: 'th').
	self assert: font isNil
]
