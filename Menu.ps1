# Global variables
$actualMenu = 0
$selected = 0
$rows = $host.UI.RawUI.WindowSize.Height
$cols = $host.UI.RawUI.WindowSize.Width
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
chcp 655001 > $null
# Initialize menus and header items
function InitMenus {
    $script:title = "D K U K L I N S K I"

    $script:menu1 = @(
        "[A] - About",
        "[B] - Script B",
        "[C] - Script C",
        "[D] - Script D",
        "[E] - Exit",
        "[F] - Script F",
        "[G] - Script G",
        "[H] - Help",
        "[N] - Next screen"
    )

    $script:menu2 = @(
        "[I] - Script I",
        "[J] - Script J",
        "[K] - Script K",
        "[L] - Script L",
        "[M] - Script M",
        "[O] - Script O",
        "[R] - Script R",
        "[N] - Next screen",
        "[P] - Previous screen"
    )

    $script:menu3 = @(
        "[S] - Script S",
        "[T] - Script T",
        "[U] - Script U",
        "[V] - Script V",
        "[X] - Script X",
        "[Y] - Script Y",
        "[Z] - Script Z",
        "[N] - Next screen",
        "[P] - Previous screen"
    )

    $script:headerItems = @(
        "1 item1", "2 item2", "3 item3", "4 item4",
        "5 item5", "6 item6", "7 item7", "8 item8", "9 item9"
    )
}

# Draw header with background and items
function DrawHeader {
    # Set background and foreground colors
    $host.UI.RawUI.BackgroundColor = "DarkBlue"
    $host.UI.RawUI.ForegroundColor = "White"

    # Fill the entire row
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, 0)
    Write-Host (" " * $cols) -NoNewline

    # Draw header items
    for ($i = 0; $i -lt $script:headerItems.Count; $i++) {
        $10i = $i * 10
        $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($10i, 0)
        Write-Host $script:headerItems[$i] -NoNewline
    }

    # Reset colors
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "White"
}

# Draw footer with information
function DrawFooter {
    # Set background and foreground colors
    $host.UI.RawUI.BackgroundColor = "DarkBlue"
    $host.UI.RawUI.ForegroundColor = "White"

    # Fill the entire row
    $rowsminus1 = $rows -1
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, $rowsminus1)
    Write-Host (" " * $cols) -NoNewline

    # Write footer information
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, $rowsminus1)
    Write-Host "Dariusz Kuklinski v 1.0. 0 | Menu=$actualMenu | Selected=$selected | $cols x $rows" -NoNewline

    # Reset colors
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "White"
}

# Draw a box with borders
function DrawBox {
    param (
        [int]$row,
        [int]$col,
        [int]$width,
        [int]$height
    )

    $tl = ([char]0x250c); $tr = ([char]0x2510); $bl = ([char]0x2514); $br = ([char]0x2518)
    $hor = "-"; $ver = ([char]0x2502)

    # Top border
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($col, $row)
    Write-Host "$tl$($hor * ($width - 2))$tr" -NoNewline

    # Middle rows
    for ($i = 1; $i -lt $height - 1; $i++) {
        $rowplusi = $row + $i
        $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($col, $rowplusi)
        Write-Host "$ver$(" " * ($width - 2))$ver" -NoNewline
    }

    # Bottom border
    $rowheightminus1 = $row + $height - 1
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($col, $rowheightminus1 )
    Write-Host "$bl$($hor * ($width - 2))$br" -NoNewline
}

# Draw all boxes based on current menu
function DrawBoxes {
    $box_width = 60
    $box_height = 16

    $start_row = [math]::Floor(($rows - $box_height) / 2)
    $start_col = [math]::Floor(($cols - $box_width) / 2)

    switch ($actualMenu) {
        0 {
            DrawBox $start_row $start_col $box_width $box_height
            DrawBox ($start_row - 2) ($start_col - 2) $box_width $box_height
            DrawBox ($start_row - 4) ($start_col - 4) $box_width $box_height
            $base_row = $start_row - 4
            $base_col = $start_col - 4
            $menu = $script:menu1
            break
        }
        1 {
            DrawBox $start_row $start_col $box_width $box_height
            DrawBox ($start_row - 4) ($start_col - 4) $box_width $box_height
            DrawBox ($start_row - 2) ($start_col - 2) $box_width $box_height
            $base_row = $start_row - 2
            $base_col = $start_col - 2
            $menu = $script:menu2
            break
        }
        2 {
            DrawBox ($start_row - 4) ($start_col - 4) $box_width $box_height
            DrawBox ($start_row - 2) ($start_col - 2) $box_width $box_height
            DrawBox $start_row $start_col $box_width $box_height
            $base_row = $start_row
            $base_col = $start_col
            $menu = $script:menu3
            break
        }
    }

    # Draw title
    $colx = $base_col + $box_width / 3
    $rowy = $base_row + 2
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($colx, $rowy)
    Write-Host $script:title -NoNewline

    # Draw menu items
    $row = $base_row + 4
    $basecolplus2= $base_col + 2
    for ($i = 0; $i -lt $menu.Count; $i++) {
        $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($basecolplus2, $row)

        $text = $menu[$i]
        $inner_width = $box_width - 4  # padding 2 from left and 2 from right

        if ($i -eq $selected) {
            $host.UI.RawUI.BackgroundColor = "White"
            $host.UI.RawUI.ForegroundColor = "Black"
            Write-Host $text.PadRight($inner_width) -NoNewline
            $host.UI.RawUI.BackgroundColor = "Black"
            $host.UI.RawUI.ForegroundColor = "White"
        } else {
            Write-Host $text.PadRight($inner_width) -NoNewline
        }

        $row++
    }
}

# Draw the complete menu
function DrawMenu {
    Clear-Host
    DrawHeader
    DrawBoxes
    DrawFooter
}

# Execute the selected option
function ExecuteOption {
    param ([int]$option)

    switch ($option) {
        1 { .\item1.ps1 }
        2 { .\item2.ps1 }
        3 { .\item3.ps1 }
        4 { .\item4.ps1 }
        5 { .\item5.ps1 }
        6 { .\item6.ps1 }
        7 { .\item7.ps1 }
        8 { .\item8.ps1 }
        9 { .\item9.ps1 }
    }
}

# Read key input
function ReadKey {
    $keyInfo = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    if ($keyInfo.VirtualKeyCode -eq 27) {  # ESC key
        $keyInfo = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($keyInfo.VirtualKeyCode -eq 65) {  # Up arrow
            $script:selected--
        } elseif ($keyInfo.VirtualKeyCode -eq 66) {  # Down arrow
            $script:selected++
        }
    } else {
        $key = $keyInfo.Character

        switch ($key) {
            'P' { $script:actualMenu++; if ($script:actualMenu -gt 2) { $script:actualMenu = 0 } }
            'p' { $script:actualMenu++; if ($script:actualMenu -gt 2) { $script:actualMenu = 0 } }
            'N' { $script:actualMenu--; if ($script:actualMenu -lt 0) { $script:actualMenu = 2 } }
            'n' { $script:actualMenu--; if ($script:actualMenu -lt 0) { $script:actualMenu = 2 } }

            'a' { .\about.ps1 }
            'A' { .\about.ps1 }
            'b' { .\scriptB.ps1 }
            'B' { .\scriptB.ps1 }
            'c' { .\scriptC.ps1 }
            'C' { .\scriptC.ps1 }
            'd' { .\scriptD.ps1 }
            'D' { .\scriptD.ps1 }
            'e' { exit }
            'E' { exit }
            'f' { .\scriptF.ps1 }
            'F' { .\scriptF.ps1 }
            'g' { .\scriptG.ps1 }
            'G' { .\scriptG.ps1 }
            'h' { .\help.ps1 }
            'H' { .\help.ps1 }

            'i' { .\scriptI.ps1 }
            'I' { .\scriptI.ps1 }
            'j' { .\scriptJ.ps1 }
            'J' { .\scriptJ.ps1 }
            'k' { .\scriptK.ps1 }
            'K' { .\scriptK.ps1 }
            'l' { .\scriptL.ps1 }
            'L' { .\scriptL.ps1 }
            'm' { .\scriptM.ps1 }
            'M' { .\scriptM.ps1 }

            's' { .\scriptS.ps1 }
            'S' { .\scriptS.ps1 }
            't' { .\scriptT.ps1 }
            'T' { .\scriptT.ps1 }
            'u' { .\scriptU.ps1 }
            'U' { .\scriptU.ps1 }
            'v' { .\scriptV.ps1 }
            'V' { .\scriptV.ps1 }
            'x' { .\scriptX.ps1 }
            'X' { .\scriptX.ps1 }
            'y' { .\scriptY.ps1 }
            'Y' { .\scriptY.ps1 }
            'z' { .\scriptZ.ps1 }
            'Z' { .\scriptZ.ps1 }

            '1' { ExecuteOption 1 }
            '2' { ExecuteOption 2 }
            '3' { ExecuteOption 3 }
            '4' { ExecuteOption 4 }
            '5' { ExecuteOption 5 }
            '6' { ExecuteOption 6 }
            '7' { ExecuteOption 7 }
            '8' { ExecuteOption 8 }
            '9' { ExecuteOption 9 }
        }
    }
}

# Main loop function
function MainLoop {
    while ($true) {
        # Get current menu size
        switch ($actualMenu) {
            0 { $menuSize = $script:menu1.Count }
            1 { $menuSize = $script:menu2.Count }
            2 { $menuSize = $script:menu3.Count }
        }

        # Handle selection boundaries
        if ($selected -lt 0) { $selected = $menuSize - 1 }
        if ($selected -ge $menuSize) { $selected = 0 }

        DrawMenu
        ReadKey
    }
}

# Check terminal size
function OnResize {
    $script:rows = $host.UI.RawUI.WindowSize.Height
    $script:cols = $host.UI.RawUI.WindowSize.Width

    if ($cols -lt 80 -or $rows -lt 25) {
        Clear-Host
        Write-Host "Terminal too small. Minimum 80x25"
        exit 1
    }
}

# Register window resize event
$windowSizeAction = {
    OnResize
}
$host.UI.RawUI.WindowTitle = "Menu System"
$host.UI.RawUI.Size = New-Object System.Management.Automation.Host.Size(80, 25)
$host.UI.RawUI.AddKeyDownHandler($windowSizeAction)

# Initialize and start
OnResize
InitMenus
MainLoop
