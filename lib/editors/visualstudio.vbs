' Copyright (c) 2016, Evgeny Panasyuk

' Permission is hereby granted, free of charge, to any person or organization
' obtaining a copy of the software and accompanying documentation covered by
' this license (the "Software") to use, reproduce, display, distribute,
' execute, and transmit the Software, and to prepare derivative works of the
' Software, and to permit third-parties to whom the Software is furnished to
' do so, all subject to the following:
' 
' The copyright notices in the Software and this entire statement, including
' the above license grant, this restriction and the following disclaimer,
' must be included in all copies of the Software, in whole or in part, and
' all derivative works of the Software, unless such copies or derivative
' works are solely in the form of machine-executable object code generated by
' a source language processor.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
' SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
' FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
' ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.

' e-mail: E?????[dot]P???????[at]gmail.???

Option Explicit

Dim filename, line, column
Dim MSVS_versions, version
Dim dte, fso, wshShell
Dim fullpath

filename = WScript.Arguments(0)
line = WScript.Arguments(1)
column = WScript.Arguments(2)

MSVS_versions = Array _
( _
    "VisualStudio.DTE.7", _
    "VisualStudio.DTE.7.1", _
    "VisualStudio.DTE.8.0", _
    "VisualStudio.DTE.9.0", _
    "VisualStudio.DTE.10.0", _
    "VisualStudio.DTE.11.0", _
    "VisualStudio.DTE.12.0", _
    "VisualStudio.DTE.14.0", _
    "VisualStudio.DTE.15.0" _
)

On Error Resume Next

For each version in MSVS_versions
    Err.Clear
    Set dte = getObject(,version)
    If Err.Number = 0 Then
        Exit For
    End If
Next

If Err.Number <> 0 Then
    Set dte = WScript.CreateObject("VisualStudio.DTE")
    Err.Clear
End If

Set wshShell = WScript.CreateObject("WScript.Shell")
Set fso = WScript.CreateObject("Scripting.FileSystemObject")
fullpath = fso.GetAbsolutePathName(filename)

dte.MainWindow.Activate()
dte.MainWindow.Visible = True
dte.UserControl = True
wshShell.AppActivate dte.MainWindow.Caption

dte.ItemOperations.OpenFile fullpath
dte.ActiveDocument.Selection.MoveToLineAndOffset line, column + 1

if Err.Number <> 0 Then
    WScript.Quit Err.Number
End If

On Error Goto 0
