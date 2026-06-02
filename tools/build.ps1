# Builds MMOSkillTamingPack.zip with forward-slash entries. Hytale's asset
# loader silently drops the backslash separators that Compress-Archive writes
# on Windows, so we use the lower-level ZipFile API. Pass -Install:$false to
# build without copying to the Hytale Mods folder.
param([bool]$Install = $true)

$ErrorActionPreference = 'Stop'
$pack = Split-Path -Parent $PSScriptRoot   # tools/ -> pack root
$zipPath = Join-Path $pack 'MMOSkillTamingPack.zip'
Remove-Item $zipPath -ErrorAction SilentlyContinue

Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
try {
    $exclude = 'MMOSkillTamingPack.zip', 'README.md', 'CURSEFORGE.md', 'CLAUDE.md', 'LICENSE', '.gitignore'
    $files = Get-ChildItem -Path $pack -Recurse -File | Where-Object {
        $_.Name -notin $exclude -and $_.FullName -notlike "$pack\tools\*"
    }
    # The pack ships a .lang (token item names). Hytale's
    # I18nModule.loadMessagesFromPack gates on Files.isDirectory(Server/Languages),
    # which Java's ZipFileSystem reports false for unless the zip has explicit
    # directory entries. Emit one for every ancestor path before each file.
    $createdDirs = @{}
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($pack.Length + 1).Replace('\', '/')

        $parts = $rel -split '/'
        for ($i = 1; $i -lt $parts.Length; $i++) {
            $dir = ($parts[0..($i - 1)] -join '/') + '/'
            if (-not $createdDirs.ContainsKey($dir)) {
                $zip.CreateEntry($dir, [System.IO.Compression.CompressionLevel]::NoCompression).Open().Close()
                $createdDirs[$dir] = $true
            }
        }

        $entry = $zip.CreateEntry($rel, [System.IO.Compression.CompressionLevel]::Optimal)
        $stream = $entry.Open()
        $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Close()
    }
} finally {
    $zip.Dispose()
}
Write-Host "Built $zipPath"

if ($Install) {
    $dest = 'D:\Games\Hytale\UserData\Mods\MMOSkillTamingPack.zip'
    Copy-Item $zipPath $dest -Force
    Write-Host "Deployed to $dest"
}
