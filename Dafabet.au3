#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Images\roulette.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ImageSearch.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Date.au3>

;~ MsgBox($MB_OK, "Tutorial", "Hello World!")
HotKeySet("{PGUP}","_Begin")
HotKeySet("^{PGUP}","_fixB4Start")
HotKeySet("{INSERT}","_goToRoulette")
HotKeySet("^{INSERT}","_fixB4goTo")
HotKeySet("{PAUSE}", "_Pause")
HotKeySet("{PGDN}", "_Exit")

$X =0
$Y =0
Global 	$CheckNet = true  			;��������ʶҹ���
Global  $Money = 0                  ;�Թ�ҧ����ѹ  - ���������� 0 �ҷ
Global  $dropMoney
Global  $timeRestart				;�Ѻ������ Restart
Global  $profitNow = 0				;���ҧ����ҡ��� �ú 200 �ҷ���ѡ
Global  $profitPerRound =  0  ; profit 10 - 30 bath per round
Global 	$filePath = @ScriptDir&"\LogFile\BetMoney.txt"
While 1  ;��ش�͡�á� start
	local $text =  'Start [PGUP]  Start&fill [Ctrl+PGUP]'&@LF
		  $text &= 'Run First Time [INSERT] First&Fill [Ctrl+INSERT]'&@LF
		  $text &= 'Pause [PAUSE]'&@LF
		  $text &= 'EXIT [PGDN]'&@LF
	ToolTip($text, 19,0 )
    Sleep(4*60*1000)  ;�� 4 �ҷ� ����ѧ��衴 Bot ��������ӧҹ
	Send("^{INSERT}")
WEnd

Func _Begin()
	_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Start Bot")  ;��ʶҹ��Դ�ͷ ŧ���� .log
    Start()
	;_goToRoulette()


EndFunc

func _fixB4goTo()
	ToolTip('Fix Money = 10.1 ', 50,0 )
	$Money = 10.1
	goWriteFile()
	_goToRoulette()
EndFunc

Func _fixB4Start()
	ToolTip('Fix Money = 10.1 ', 50,0 )
	$Money = 10.1
	goWriteFile()
	Start()
EndFunc

func _goToRoulette()
	$dropMoney = Random(1,3,1)	;������á���random ����ҧ�Թ
	$profitPerRound =   Random(10,30,1)  ; profit 10 - 30 bath per round
	;-----------------------------------------------------
	sleep(1000)
	ToolTip('Go to Roulette ', 50,0 )
	WinActivate("[CLASS:MozillaWindowClass]","")   ;�Դ��������� Firefox �����
	sleep(1000)
	Run("""C:\Program Files\Mozilla Firefox\firefox.exe"" imacros://run/?m=DafabetLogin.js") ; run imacro
	Local $hTimer = TimerInit()  ;������Ѻ����
	While 1
		if search_area("downBar") Then ExitLoop
		if TimerDiff($hTimer) > 3*60*1000 Then  ;������ٻ������Թ 3 �ҷ� ����Ѻ价ӧҹ����
			_goToRoulette()
		EndIf
		sleep(1000)
	WEnd
	click_picture("downBar")
	MouseClick("left",876, 501,1,2)  ;��������������
	click_picture("menuRoulette")
	click_picture("submitDefault")     ;��������ŧ��͹�������
	Start()
EndFunc

Func Start()
	ToolTip('InternetCheck ', 19,0 )
	InternetCheck ()
	ToolTip('Bot Start ', 19,0 )
	$timeRestart = TimerInit()  ;������Ѻ����
	While 1
		While 1
			if  search_area("timeDelay") And search_area("fillMoney")  Then  ; ��ҵ�ǨѺ��������¹���մ� ��� ��ͧ����Թ���բ��
				ToolTip('New Round ', 50,0 )
				click_picture("fillMoney")
				Sleep(300)
				local $moneyOnFile  = FileReadLine($filePath,1)  ;�Դ���֧���
				send($moneyOnFile) ;����Թ㹪�ͧ
				$Money = $moneyOnFile  ;᷹���㹵���� ����������
				FileClose($filePath) ;�Դ File
				Sleep(1000)
				send("{ENTER}")
				Sleep(300)
					if $dropMoney == 1 then
						click_picture("areaLeft")
					ElseIf $dropMoney == 2 then
						click_picture("areaMid")
					ElseIf $dropMoney == 3 then
						click_picture("areaRight")
					EndIf
				click_picture("submitButton") ;��ԡ���� �׹�ѹ
				ExitLoop
			ElseIf search_area("rouletteTimeout") Then  ;��� roullet �ջѭ�� ������� ������ش ���  restart
				_goToRoulette()
			EndIf

		WEnd

		local $winStatus = false     ; �纤��ʶҹ���� �ͺ��骹��������
		ToolTip('Wait Wait ', 50,0 )

		While 1
			if search_area("win") And $winStatus == false Then   ;����� popup ��� ����¹ $winStatus = true  (�ӧҹ�������� ǹ�ͺ���仨����������͹�)
				ToolTip('!!! Win !!!!', 50,0 )
				$winStatus = true
				if $Money > 583   Then
					_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Warning")  ;��ʶҹ�� ŧ���� .log
					goWriteFile()
					warning ()
				EndIf

				if($Money == "10.1") then
					$profitNow += 20
				else
					$profitNow += 10
				EndIf

				If $profitNow >= $profitPerRound then

					_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Profit in day "&$profitNow&" Bath")
					goWriteFile("TotalProfit")
					$Money = 10.1
					goWriteFile()

					Local $rantime = Random(60,150,1)	;random ˹�ǧ���� ��ѧ�ҡ����äú��ͺ���
					$rantime = ($rantime*60)
					While ($rantime>=0)
						Sleep(1000)
						ToolTip("Congreat "&$profitNow&" Bath "& $rantime, 1,0 )
						$rantime-=1
					WEnd
					$profitNow =0
					_goToRoulette()
				EndIf
				goWriteFile("TotalProfit")

				$Money = 10.1  ;᷹��ҵç������� �����ش���¡�͹ restart ��� txt ��
				$dropMoney = Random(1,3,1)  ; random ��ͧ�ҧ�Թ��������ͪ��
			EndIf
			if search_area("alertNewRound") Then   	;����� popup ����ͺ����
				if $winStatus == true Then 			;��Ҫ�� �Թ����ѹ����¹�� 10.1 ��m
					$Money = 10.1
				else    							; ����� �����Թ����ѹ
						If  $Money == 10.1 then
							$Money = 10.2
						ElseIf $Money == 10.2 then
							$Money = 15
						ElseIf $Money == 15 then
							$Money = 23
						ElseIf $Money == 23 then
							$Money = 34
						ElseIf $Money == 34 then
							$Money = 51
						ElseIf $Money == 51 then
							$Money = 77
						ElseIf $Money == 77 then
							$Money = 115
						ElseIf $Money == 115 then
							$Money = 173
						ElseIf $Money == 173 then
							$Money = 259
						ElseIf $Money == 259 then
							$Money = 389
						ElseIf $Money == 389 then
							$Money = 583
						ElseIf $Money == 583 then
							$Money = 875
						ElseIf $Money == 875 then
							$Money = 1312
						ElseIf $Money == 1312 then
							$Money = 1968
						ElseIf $Money == 1968 then
							Exit 0
						EndIf
				EndIf

				goWriteFile()


				If ( TimerDiff($timeRestart)  >= (30*60*1000) ) And $winStatus == true  then
					_goToRoulette()
				EndIf

				ExitLoop
			EndIf
			If search_area("rouletteTimeout") Then  ;��� roullet �ջѭ�� ������� ������ش ���  restart
				_goToRoulette()
			EndIf
			sleep(300)
		WEnd
	WEnd
EndFunc

Func warning ()
	local $delayTime = 60*60 ;��ش��� 60 �ҷ�
	while 1
		ToolTip("!!! WARNING !!! "&Round(($delayTime/60),2), 1,0 )
		Sleep (1000)
		if $delayTime <= 0 Then _goToRoulette()
		$delayTime-=1
	WEnd
EndFunc

Func goWriteFile($menu="BetMoney")
	if $menu == "BetMoney" Then
		Local $fileOpen = FileOpen($filePath,2)
		FileWrite($fileOpen, $Money)
		FileClose($filePath) ;�Դ File
	ElseIf $menu =="TotalProfit" Then
		Local $filePatTotalProfit = @ScriptDir&"\LogFile\TotalProfit.txt"
		local $time  = FileReadLine($filePatTotalProfit,1)  ;�Դ���֧���
		local $TotalProfit  = FileReadLine($filePatTotalProfit,2)  ;�Դ���֧���
		if _NowDate() == $time and $totalProfit < 200 then      ;���������ѹ���ǡѹ
			if($Money == "10.1") then
				$TotalProfit += 20
			else
				$TotalProfit += 10
			EndIf
			ElseIf  _NowDate() == $time and $totalProfit >= 200 Then
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Congreat 200 Bath This time")
				$Money = 10.1
				goWriteFile()
				Local $waittime = ( (((24-@HOUR)*60) + (Random(60,120,1))) *60)  ; find time and + random  time 1-2 hr
				While ($waittime>=0)
					Sleep(1000)
					ToolTip("Congreat Wait Next Day "& $waittime, 1,0 )
					$waittime-=1
				WEnd
				_goToRoulette()
		ElseIf  _NowDate() <> $time then
			$time = _NowDate()
			$TotalProfit = 0
		EndIf
			Local $fileOpenTotalProfit = FileOpen($filePatTotalProfit,2)
			FileWriteLine($fileOpenTotalProfit ,$time)
			FileWriteLine($fileOpenTotalProfit ,$totalProfit)
			FileClose($fileOpenTotalProfit) ;�Դ File
	EndIf

EndFunc

Func InternetCheck ()  ;���ѭ�ҳ Internet
	while 1  ; �� internet ping�google  ��� ping����������� 10�� ����ping���訹���ҨеԴ
		Local $iPing = Ping("google.com", 1000)
		If $iPing Then
			If (Not $CheckNet) Then  ;��������͹䢹��  ����� net lost �ҡ�͹
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Internet Connect")  ;��ʶҹ��Դ�ͷ ŧ���� .log
				$CheckNet = Not $CheckNet  ;��Ѻʶҹ�
			EndIf
			ExitLoop
		Else
			ToolTip('Internet Lost ', 19,0 )
			If ( $CheckNet ) Then   ;��������͹� ����� internet lost
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Internet Lost")  ;��ʶҹ��Դ�ͷ ŧ���� .log
				$CheckNet = Not $CheckNet  ;��Ѻʶҹ�
			EndIf
			Sleep(10000)
		EndIf
	WEnd
EndFunc

Func click_picture($p_name)  ; ��ԡ�ٻ�Ҿ���㹾�鹷��ͧ �ͧ app adpocket

	Local $hTimer = TimerInit()  ;������Ѻ����
	while 1
		$Search = _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
		IF $Search = 1  Then
			MouseClick("left",$X, $Y,1,2)
			ExitLoop

		ElseIf TimerDiff($hTimer) > 60000 Then   ;������ٻ������Թ 60 �� ����Ѻ价ӧҹ����
			_goToRoulette()
		EndIf
         ToolTip("Pic "& $p_name& Round((TimerDiff($hTimer)/1000),1), 1,0 )
		sleep (400)
	WEnd
    Sleep(300)
 EndFunc

Func search_area($p_name)  ;���ٻ�Ҿ���㹾�鹷��ͧ app adpocket
		Return  _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
    Sleep(300)
EndFunc

Func _Pause()
	Global $pssix
    $pssix = Not $pssix
    While $pssix
        Sleep(500)
        ToolTip('PAUSE', 19, 0)
    WEnd
    ToolTip("")
EndFunc

Func _Exit()
	_FileWriteLog(@ScriptDir &"\LogFile\LogData.log", "Close Bot")  ;��ʶҹлԴ�ͷ  ŧ���� .log
    Exit 0
EndFunc