function powershell.exe
    # Check if the command is trying to 'start' a URL
    if test "$argv[1]" = "start"
        # Extract the URL (removes potential outer single/double quotes)
        set -l url (string trim -c "'\"" $argv)

        # Define the path to Brave cleanly without inline escaping
        set -l brave_path "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"

		echo $url | $brave_path | powershell.exe start "'$brave_path'" "'$url'"


        # Execute the real binary using variables to handle the quotes perfectly
        command powershell.exe start "'$brave_path'" "'$url'"
    else
        # Pass through to regular PowerShell for all other tasks
        command powershell.exe $argv
    end
end
