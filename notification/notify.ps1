#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Envía una notificación toast a Windows Desktop.
.DESCRIPTION
    Usa BurntToast si está instalado. Si no, cae en la API nativa de Windows.
.PARAMETER Title
    Título de la notificación (primer texto en negrita).
.PARAMETER Message
    Cuerpo del mensaje (segundo texto).
.PARAMETER Type
    Tipo de notificación: success (verde), error (rojo), info (azul). Por defecto: info.
.PARAMETER Silent
    Si se especifica, no reproduce sonido.
.EXAMPLE
    .\notify.ps1 "Build OK" "Compilación en 3.2s" -Type success
.EXAMPLE
    .\notify.ps1 "Error" "Falló el deploy" -Type error -Silent
#>

param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Title,

    [Parameter(Mandatory, Position = 1)]
    [string]$Message,

    [Parameter(Position = 2)]
    [ValidateSet("success", "error", "info")]
    [string]$Type = "info",

    [switch]$Silent
)

# --- Preferir BurntToast ---
if (Get-Module -ListAvailable -Name BurntToast -ErrorAction SilentlyContinue) {
    try {
        Import-Module BurntToast -ErrorAction Stop
        $text = @($Title, $Message)
        $params = @{ Text = $text }
        if ($Silent) { $params.Silent = $true }
        if ($Type -eq "error") { $params.Text = @("[ERROR] $Title", $Message) }
        if ($Type -eq "success") { $params.Text = @("[OK] $Title", $Message) }
        New-BurntToastNotification @params
        return
    } catch {
        Write-Warning "BurntToast falló, usando fallback nativo: $_"
    }
}

# --- Fallback: API nativa de Windows ---
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    $icon = @{
        success = [System.Drawing.SystemIcons]::Information
        error   = [System.Drawing.SystemIcons]::Error
        info    = [System.Drawing.SystemIcons]::Information
    }[$Type]

    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = $icon
    $notify.BalloonTipTitle = $Title
    $notify.BalloonTipText = $Message
    $notify.Visible = $true
    $notify.ShowBalloonTip(5000)

    # Limpieza después de mostrar
    Start-Sleep -Seconds 6
    $notify.Dispose()
} catch {
    Write-Error "No se pudo mostrar notificación: $_"
}
