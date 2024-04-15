Class {
	#name : #LanguageFontManager,
	#superclass : #Object,
	#instVars : [
		'languageFonts'
	],
	#category : #'DrGeo-System'
}

{ #category : #accessing }
LanguageFontManager >> add: aLanguageFont [
	languageFonts add: aLanguageFont 
]

{ #category : #accessing }
LanguageFontManager >> europeanLang [
	^ (#(#ast #ca #cs #da #de #en #es #fi #fr #it #nl #pt #ru #sv #tr #uk))
]

{ #category : #initialization }
LanguageFontManager >> initialize [
	super initialize.
	languageFonts := OrderedCollection new
]

{ #category : #accessing }
LanguageFontManager >> languageFontFor: aLocaleID [
	(self europeanLang includes: aLocaleID isoLanguage asSymbol) 		ifTrue: [^ nil]. "Use Deja Vu font within Cuis"
	^ languageFonts detect: [:each | each handles: aLocaleID] ifNone: [nil]
]
