	DEFC		True			= 1
	DEFC		False			= 0
	DEFC		KernelVariables 	= $5B00  
	DEFC 		KeycodeSpace		= $20
	DEFC		KeycodeEnter		= $0D
	DEFC 		ScreenSizeX		= $20
	DEFC 		ScreenSizeY		= $18
	DEFC 		ScreenStart		= $4000
	DEFC 		MaxProcesses		= 10
	DEFC		ProcessDescriptorSize	= 8
	DEFC		StatusStopped		= 0
	DEFC		StatusRunning		= 1
	DEFC		StatusSleeping		= 2

DEFVARS KernelVariables {
	CursorX		ds.b 	1
	CursorY 	ds.b 	1
	CharsetAddr	ds.w 	1
	ProcessCurrent	ds.b	1
	ProcessTable	ds.b	ProcessDescriptorSize * MaxProcesses
}