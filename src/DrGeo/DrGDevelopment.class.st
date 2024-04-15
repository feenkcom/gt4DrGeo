"
Preferences for a Dr. Geo development environment
"
Class {
	#name : #DrGDevelopment,
	#superclass : #DrGPlatform,
	#category : #'DrGeo-System'
}

{ #category : #path }
DrGDevelopment >> backgroundsPath [
	^ self resourcesPath / 'graphics' / 'backgrounds'
]

{ #category : #path }
DrGDevelopment >> iconsPath [
	^ self resourcesPath / 'graphics' / 'iconsSVG'
]

{ #category : #initialization }
DrGDevelopment >> initialize [
	self initFontManager.
	canWeDisplaySpinner := false.
	self flag: #drgeoTodo.
	Preferences 
		at: #fullScreenLeavesDeskMargins put: true;
		at: #worldMenu put: TheWorldMenu.
]

{ #category : #testing }
DrGDevelopment >> isSystem [
"I hold the Dr. Geo development environment preferences"
	^ true
]

{ #category : #path }
DrGDevelopment >> resourcesPath [
"	The resources are in the Dr. Geo source code local repository "
	^ self rootPath / 'drgeo' / 'resources'
]

{ #category : #path }
DrGDevelopment >> rootPath [
"	Regarding the development environement, we consider the root path to be 
	Cuis-Smalltalk-Dev from where is taking place the DrGeo development "

	^ DirectoryEntry smalltalkImageDirectory parent
]

{ #category : #font }
DrGDevelopment >> setFontPreferences [
	PreferenceSet setDefaultFont: 'DejaVu Sans'.
	Preferences at: #defaultFontSize put: 11.

]
