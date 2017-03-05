	DEFC		KernelVariables = $5C00  
	DEFC 		KeycodeSpace	= $20
	DEFC		KeycodeEnter	= $0D
	DEFC 		ScreenSizeX	= $20
	DEFC 		ScreenSizeY	= $18
	DEFC 		ScreenStart	= $4000
	DEFC 		MaxProcesses	= 10



DEFVARS KernelVariables {
	CursorX		ds.b 	1
	CursorY 	ds.b 	1
	CharsetAddr	ds.w 	1
	ProcessTable	ds.w	4 * MaxProcesses
}