on run
	tell application "Finder"
		set fileItem to choose folder
	end tell
	openFile(fileItem)
end run

on open fileItem
	openFile(fileItem)
end open

on openFile(fileItem)
	set unixPath to POSIX path of fileItem
	set unixPath to removeLastSlash(unixPath)
	set directoryName to lastPathComponent(unixPath)
	activate
	set inputPassword to display dialog "Password:" default answer ""
	
	set excludeDSStore to display dialog "Exclude " & quote & ".DS_Store" & quote & "?" buttons {"Yes", "No"} default button 1
	
	set unixCommand to "cd " & unixPath & "/.. ; zip -r "
	if text returned of inputPassword is not "" then
		set unixCommand to unixCommand & "-P " & text returned of inputPassword & " "
	end if
	set unixCommand to unixCommand & directoryName & ".zip " & directoryName & " "
	if button returned of excludeDSStore is "Yes" then
		set unixCommand to unixCommand & "-x " & quote & "*.DS_Store" & quote & " " & quote & "*__MACOSX*" & quote
	end if
	
	try
		set commandResult to (do shell script unixCommand)
		display dialog commandResult buttons {"OK"} default button 1
	on error theError
		display dialog theError buttons {"OK"} default button 1
	end try
	
end openFile

on escapeSpace(inputString)
	set theResult to ""
	repeat with i from 1 to the number of characters in inputString
		if character i of inputString is " " then
			set theResult to theResult & "\\"
		end if
		set theResult to theResult & character i of inputString
	end repeat
	return theResult
end escapeSpace

on removeLastSlash(inputString)
	if last character of inputString is "/" then
		return characters 1 thru ((number of characters in inputString) - 1) of inputString as string
	end if
	return inputString as string
end removeLastSlash

on lastPathComponent(inputString)
	set originalDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "/"
	set theResult to last text item of (inputString as string)
	set AppleScript's text item delimiters to originalDelimiter
	return theResult as string
end lastPathComponent