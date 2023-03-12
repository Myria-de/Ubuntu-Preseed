# Ubuntu-Preseed
Preseed configuration for Ubuntu 22.04

Die Installation von Ubuntu ist zwar nicht besonders aufwendig, erfordert aber dennoch einige Benutzereingaben. Wer das System häufiger neu installiert, etwa in einer virtuellen Maschine oder auf mehreren Schulungs-PCs, kann die Installation komplett oder teilweise automatisieren. Nebenbei kann man das Live-System mit zusätzlichen Paketen und Updates ausstatten, was die Arbeiten nach der Installation reduziert.

Wir verwenden die Desktop-Ausgabe von Ubuntu 22.04. Die Beschreibungen gelten sinngemäß für alle Ubuntu-Varianten, die das gleiche Setup-Tool verwenden, beispielsweise Xubuntu, Kubuntu und Linux Mint, nicht jedoch für Lubuntu, das einen anderen Installer verwendet. Bei Ubuntu-Server kommt ebenfalls ein anderer Installer zum Einsatz (siehe <a href="https://m6u.de/UBSAUT" target="_blank">Automated Server installation</a>).

"preseed-minimal" enthält die Dateien für eine minimal automatische Installation. Lokalisierung, Benutzerkonto und Passwort, Uhr/Zeitzone und Hostname werdem vorbelegt. Per Script wird nach dem Setup ein zufälliger Hostname gesetzt. Außerdem besteht im Script die Möglichkeit, zusätzliche Pakete automatisch zu installieren. Lesen Sie die Kommentare in der Datei "auto-inst.seed" und passen Sie die Angaben an.

"preseed-full" enthält alle Angaben für eine vollautomatische Installation ohne Benutzereingabe. Aber Vorsicht! Die automatische Partitionierung setzt voraus, dass eine eindeutig definierte Zielfestplatte verfügbar ist. Lesen Sie die Kommentare in der Datei "auto-inst.seed" und passen Sie die Angaben an.

## Links
Für die automatische Installation müssen die Dateien aus der [Ubuntu-ISO-Datei](https://ubuntu.com) extrahiert werden. Anschließend baut man die eigenen Konfigurationsdateien ein und erstellt eine neue ISO-Datei. Dabei unterstützt Sie das Tool [Cubic](https://github.com/PJ-Singh-001/Cubic) mit einer grafischen Oberfläche.
