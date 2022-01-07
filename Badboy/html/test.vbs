'
' Example Program to Demonstrate OLE Scripting Access to Badboy
'
' This program shows how you can manipulate Badboy as an OLE object 
' via the Windows Scripting Host.  You can load scripts and play them
' in a scripted environment this way.
'
' Expect many more OLE methods & properties to be exposed in the future!
'
' Create a Badboy instance
  Dim badboy
  Set badboy = WScript.CreateObject("Badboy.Document")

' Open a file to play
  badboy.openFile2("c:\test.bb")

  ' Note: at this point the window will be invisible.  If you want to see it 
  ' then you can set the visible property directly:
  ' badboy.Visible = true

  ' Tell badboy to start playing the script
  badboy.play

  ' If the script exits then the badboy instance will be destroyed.
  ' so sleep while it is playing to let it finish
  while badboy.isPlaying
      WScript.Sleep(1000)
  wend

  ' Get the number of failures
  failures = badboy.summary(1, "failed")

  ' Save response times
  badboy.saveResponseTimes("c:\\test.csv")

  MsgBox("Done with " & failures & " failures")

