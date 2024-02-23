"
I load and execute Smalltalk Sketch files. These sketches may have complex intricacies and should execute without error.
"
Class {
	#name : #DrGeoSmalltalkSketchTest,
	#superclass : #TestCase,
	#category : #'DrGeo-Test'
}

{ #category : #helpers }
DrGeoSmalltalkSketchTest >> launchSketch: aScriptFile [
"Launch a test"
	(DrGeoSystem smalltalkSketchesPath // aScriptFile) readStream fileIn
]

{ #category : #helpers }
DrGeoSmalltalkSketchTest >> tearDown [
	(Delay forMilliseconds: 200) wait.
	DrGeoSketch allInstancesDo: [:aSketch | aSketch terminateDo ].
	DrGeoView allInstancesDo: [:drMorph | drMorph deleteWithoutConfirmation ].
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testArchimedesPI [
	self testOnSketch: 'Archimedes PI.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testArchimedesPIInterval [
	self testOnSketch: 'Archimedes PI Interval.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testArchimedesSpiral [
	self testOnSketch: 'Archimedes Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testBernouilliSpiral [
	self launchSketch: 'Bernouilli Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testBisection [
	self testOnSketch: 'Bisection.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testBranches [
	self testOnSketch: 'Branches.st'.
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testCercleCirconscrit [
	self testOnSketch: 'Cercle circonscrit.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testChaoticSequence [
	self testOnSketch: 'Chaotic sequence.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testCobwebDiagram [
	self testOnSketch: 'Cobweb diagram.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testConwayTesselation [
	self testOnSketch: 'Conway tesselation.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testCotesSpiral [
	self testOnSketch: 'Cotes Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testDurer [
	self testOnSketch: 'Durer.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testFathauer [
	self testOnSketch: 'Fathauer.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testFermatSpiral [
	self testOnSketch: 'Fermat Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testFibonacciSpiral [
	self testOnSketch: 'Fibonacci Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testGalileoSpiral [
	self testOnSketch: 'Galileo Spiral.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testKoch [
	self testOnSketch: 'Koch.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testNewtonRaphson [
	self testOnSketch: 'Newton-Raphson.st'
]

{ #category : #helpers }
DrGeoSmalltalkSketchTest >> testOnSketch: aScriptFile [
	self 
		shouldnt: [self launchSketch: aScriptFile] 
		raise: Error
		description: 'Fail on script ', aScriptFile.	
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testPIMontCarlo [
	self testOnSketch: 'PI-Mont-Carlo.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testSierpinski [
	self testOnSketch: 'sierpinski.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testSierpinskiDragon [
	self testOnSketch: 'Sierpinski Dragon.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testStats [
	self testOnSketch: 'stats.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testTree [
	self testOnSketch: 'Tree.st'
]

{ #category : #tests }
DrGeoSmalltalkSketchTest >> testWave [
	self testOnSketch: 'wave.st'
]
