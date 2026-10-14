# tortuga.ps1 - Tortuga ASCII que camina en un circuito y gira la cabeza segun la direccion.
#
# Uso desde GitHub (PowerShell, sin instalar nada):
#   irm https://raw.githubusercontent.com/USUARIO/REPO/main/tortuga.ps1 | iex
#
# Uso local:
#   .\tortuga.ps1
#
# Ctrl+C para detener.

$Width = 40         # largo del tramo horizontal (arriba/abajo)
$Height = 10        # largo del tramo vertical (izquierda/derecha)
$Velocidad = 80     # milisegundos entre cada frame (mas bajo = mas rapido)

# --- Mirando a la derecha (camina por arriba y por el lado derecho) ---
$RightFrame1 = @(
    "  _____     ____",
    " /      \  |  o | ",
    "|        |/ ___\| ",
    "|_________/     ",
    "|_|_| |_|_|"
)
$RightFrame2 = @(
    "  _____     ____",
    " /      \  |  o | ",
    "|        |/ ___\| ",
    "|_________/     ",
    " |_| |_|_|_|"
)

# --- Mirando a la izquierda (camina por abajo y por el lado izquierdo) ---
$LeftFrame1 = @(
    "____     _____  ",
    " | o  |  /      \ ",
    "|\___ \|        |",
    "     \_________|",
    "|_|_| |_|_|"
)
$LeftFrame2 = @(
    "____     _____  ",
    " | o  |  /      \ ",
    "|\___ \|        |",
    "     \_________|",
    " |_|_|_| |_| "
)

function Show-Frame {
    param($Frame, $X, $Y)
    Clear-Host
    for ($i = 0; $i -lt $Y; $i++) { Write-Host "" }
    foreach ($line in $Frame) {
        Write-Host ((" " * $X) + $line)
    }
}

try { [Console]::CursorVisible = $false } catch {}

$x = 0
$y = 0
$edge = 0   # 0 = arriba (->), 1 = derecha (abajo), 2 = abajo (<-), 3 = izquierda (arriba)
$step = 0

try {
    while ($true) {
        $legVariant = ([math]::Floor($step / 2) % 2)

        if ($edge -eq 0 -or $edge -eq 1) {
            if ($legVariant -eq 0) { $frame = $RightFrame1 } else { $frame = $RightFrame2 }
        } else {
            if ($legVariant -eq 0) { $frame = $LeftFrame1 } else { $frame = $LeftFrame2 }
        }

        Show-Frame -Frame $frame -X $x -Y $y

        switch ($edge) {
            0 { $x++; if ($x -ge $Width)  { $edge = 1 } }
            1 { $y++; if ($y -ge $Height) { $edge = 2 } }
            2 { $x--; if ($x -le 0)       { $edge = 3 } }
            3 { $y--; if ($y -le 0)       { $edge = 0 } }
        }

        $step++
        Start-Sleep -Milliseconds $Velocidad
    }
}
finally {
    try { [Console]::CursorVisible = $true } catch {}
}
