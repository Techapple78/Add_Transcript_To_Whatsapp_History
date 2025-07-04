# === CONFIGURATION ===
$inputFile = "_chat.txt"
$outputFile = "_chat_avec_transcriptions.txt"
$dossierTranscriptions = ".\audios"

# === INITIALISATION ===
$lines = Get-Content $inputFile 
$outputLines = @()

foreach ($line in $lines) {
    $outputLines += $line.TrimEnd()

    if ($line -match "< pièce jointe\s*:\s*(.+?\.opus)\s*>") {
        $nomFichier = $matches[1]  # capture le nom du fichier dans la balise
        $nomTxt = [System.IO.Path]::ChangeExtension($nomFichier, "txt")
        $cheminTxt = Join-Path $dossierTranscriptions $nomTxt

        $outputLines += ""  # ligne vide

        if (Test-Path $cheminTxt) {
            $contenu = Get-Content $cheminTxt -Encoding utf8
            $outputLines += $contenu
        } else {
            $outputLines += "⚠️ Fichier transcription introuvable : $nomTxt"
        }
    }
}

# === SAUVEGARDE DU RÉSULTAT ===
$outputLines | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "✅ Transcriptions insérées dans $outputFile"
