# Ubuntu-Preseed
Preseed configuration for Ubuntu 22.04

Die Installation von Ubuntu ist zwar nicht besonders aufwendig, erfordert aber dennoch einige Benutzereingaben. Wer das System häufiger neu installiert, etwa in einer virtuellen Maschine oder auf mehreren Schulungs-PCs, kann die Installation komplett oder teilweise automatisieren. Nebenbei kann man das Live-System mit zusätzlichen Paketen und Updates ausstatten, was die Arbeiten nach der Installation reduziert.

Wir verwenden die Desktop-Ausgabe von Ubuntu 22.04. Die Beschreibungen gelten sinngemäß für alle Ubuntu-Varianten, die das gleiche Setup-Tool verwenden, beispielsweise Xubuntu, Kubuntu und Linux Mint, nicht jedoch für Lubuntu, das einen anderen Installer verwendet. Bei Ubuntu-Server kommt ebenfalls ein anderer Installer zum Einsatz (siehe <a href="https://m6u.de/UBSAUT" target="_blank">Automated Server installation</a>).

**"preseed-minimal"** enthält die Dateien für eine minimal automatische Installation. Lokalisierung, Benutzerkonto und Passwort, Uhr/Zeitzone und Hostname werdem vorbelegt. Per Script wird nach dem Setup ein zufälliger Hostname gesetzt. Außerdem besteht im Script die Möglichkeit, zusätzliche Pakete automatisch zu installieren. Lesen Sie die Kommentare in der Datei "auto-inst.seed" und passen Sie die Angaben an.

**"preseed-full"** enthält alle Angaben für eine vollautomatische Installation ohne Benutzereingabe. Aber Vorsicht! Die automatische Partitionierung setzt voraus, dass eine eindeutig definierte Zielfestplatte verfügbar ist. Lesen Sie die Kommentare in der Datei "auto-inst.seed" und passen Sie die Angaben an. Zur Sicherheit erfolgt eine Nachfrage vor der Partitionierung. Wenn Sie sich sicher sind, entfernen Sie die Kommentarzeichen bei diesem Abschnitt.

## Angepasstes Livesystem mit Cubic
Für die automatische Installation müssen die Dateien aus der Ubuntu-ISO-Datei (https://ubuntu.com) extrahiert werden. Anschließend baut man die eigenen Konfigurationsdateien ein und erstellt eine neue ISO-Datei. Dabei unterstützt Sie das Tool Cubic (https://github.com/PJ-Singh-001/Cubic) mit einer grafischen Oberfläche. Installieren Sie Cubic im Terminal mit diesen vier Befehlszeilen:
```
sudo apt-add-repository universe
sudo apt-add-repository ppa:cubic-wizard/release
sudo apt update
sudo apt install --no-install-recommends cubic
```
**Schritt 1:** Starten Sie das Tool und geben Sie ein Arbeitsverzeichnis an, beispielsweise den Ordner „Cubic“ in Ihrem Home-Verzeichnis. Nach einem Klick auf „Next“ wählen Sie hinter „Filename“ die ISO-Datei des Ubuntu-Installationsmediums. Klicken Sie auf „Next“.

**Schritt 2:** Sie befinden sich jetzt in der virtuellen Umgebung („chroot“), also im Dateisystem des Installationssystems. Mit
```
apt update && apt upgrade
```
bringen Sie das Livesystem auf den neusten Stand. Sie können zusätzliche Pakete installieren, beispielsweise den Terminal-Dateimanager Midnight Commander mit den zwei Zeilen
```
apt-add-repository universe
apt install mc
```
Zusätzliche und aktualisierte Pakete vom Livesystem werden auch in das installierte System kopiert. Zum Abschluss starten Sie
```
apt autoremove
```
und
```
apt-get clean
```
Damit räumen Sie das System auf und entfernen unnötige Dateien.

**Schritt 3:** Mit einem Klick auf „Next“ verlassen Sie die chroot-Umgebung. Cubic zeigt eine Liste mit Paketen, die im Livesystem enthalten sind, bei der Installation jedoch entfernt werden sollen. In der Regel können Sie die Einstellungen übernehmen oder Sie entfernen die Häkchen vor Paketen, die Sie behalten möchten. Setzen oder entfernen Sie die Häkchen in den Spalten „Typical“ und/oder „Minimal“, je nachdem, welche Installationsvariante Sie später verwenden. Klicken Sie auf „Next“.

**Schritt 4:** Diese Seite zeigt drei Bereiche für die entscheidenden Anpassungen. Unter „Kernel“ wählen Sie in der Regel die aktuelle Version. Gehen Sie auf „Preseed“. In der Baumansicht auf der linken Seite klicken Sie auf „preseed“ und dann in der Symbolleiste auf das Icon „Create a new file“. Geben Sie der Datei den Namen „auto-inst.seed“. Für eine minimale Konfiguration und einen ersten Test genügen die Zeilen aus der Abbildung. Damit werden Sprache, Benutzerkonto sowie die Zeitzone vorgegeben, müssen also bei der Installation nicht eingegeben werden.

![auto-inst.seed-minimal](/images/302_01_Preseed.png "auto-inst.seed-minimal")

**Schritt 5:** Gehen Sie auf „Boot“ und klicken Sie auf „grub.cfg“. Wir ergänzen hier den Menüeintrag „Auto-Installation mit Preseed“, der die neue seed-Datei berücksichtigt (siehe Abbildung). Die Option „automatic-ubiquity“ sorgt dafür, dass der Setupassistent Seiten überspringt, für die Werte bereits definiert sind. In die Datei „loopback.cfg“ wird der gleiche Inhalt eingetragen. Sie wird verwendet, wenn die Installation nicht direkt von einer DVD oder einem USB-Stick erfolgt, sondern über eine per Grub eingebundene ISO-Datei. Klicken Sie auf „Next“.

![grub.cfg](/images/302_02_Boot.png "grub.cfg")

**Schritt 6:** Wählen Sie die Komprimierungsmethode. Für eine möglichst geringe Größe wählen Sie „xz“, für schnellere Komprimierung eine der anderen Optionen. Danach klicken Sie auf „Generate“. Die angepasste ISO-Datei liegt danach im Arbeitsverzeichnis. Per Klick auf „Test“ lässt sich das Livesystem in Qemu starten und testen, ob das System bootet. Eine Installation ist jedoch nicht möglich, weil Cubic keine virtuelle Festplatte erstellt. 

In den Beispieldateien finden Sie im Ordner „qemu“ das Script „install_qemu.sh“, über die sich Ubuntu testweise in Qemu installieren lässt. Passen Sie den Pfad zur ISO-Datei und die Bezeichnung der virtuellen Festplatte an. Bitte beachten Sie, dass die Festplatte dafür in „auto-inst.seed“ mit
```
d-i partman-auto/disk string /dev/vda
```
angegeben sein muss (nur bei preseed-full). Mit „run-qemu.sh“ lässt sich das System nach der Installation in Qemu starten.

## Links
Für die automatische Installation müssen die Dateien aus der [Ubuntu-ISO-Datei](https://ubuntu.com) extrahiert werden. Anschließend baut man die eigenen Konfigurationsdateien ein und erstellt eine neue ISO-Datei. Dabei unterstützt Sie das Tool [Cubic](https://github.com/PJ-Singh-001/Cubic) mit einer grafischen Oberfläche.
