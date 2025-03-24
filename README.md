# Ubuntu-Preseed
Preseed configuration for Ubuntu 22.04 and 24.04

Die Installation von Ubuntu ist zwar nicht besonders aufwendig, erfordert aber dennoch einige Benutzereingaben. Wer das System häufiger neu installiert, etwa in einer virtuellen Maschine oder auf mehreren Schulungs-PCs, kann die Installation komplett oder teilweise automatisieren. Nebenbei kann man das Live-System mit zusätzlichen Paketen und Updates ausstatten, was die Arbeiten nach der Installation reduziert.

## Die Automatisierung der Ubuntu-Installer
Auf Ubuntu basierende Distributionen verwenden unterschiedliche Tools für die Installation. Bis einschließlich Ubuntu 22.04 kam Ubiquity zum Einsatz, das mit dem Debian-Installationsassistenten verwandt ist (Dokumentation siehe https://bit.ly/UBPRE). Linux Mint 22.1 verwendet diesen Installer weiterhin. 

Ubuntu Server ab 20.04 und jetzt auch Ubuntu Desktop ab 24.04 nutzen stattdessen Subiquity, eine komplette Neuentwicklung (Dokumentation siehe https://m6u.de/SUBQU). Einige Ubuntu-Derivate wie Kubuntu und Lubuntu setzen auf Calamares.

Die Installation mit Ubiquity und Subiquity kann komplett oder teilweise automatisiert werden. Das geschieht über eine Konfigurationsdatei, die man im Installationsmedium unterbringt oder über das Netzwerk lädt. Subiquity bietet „Automatische Installation“ als Option während der Neuinstallation an. Sie müssen nur die URL oder den Pfad zur Konfigurationsdatei angeben. Die automatische Installation ohne Benutzereingabe kann man über Optionen in der Konfiguration des Bootloaders Grub festlegen.

Die Konfigurationsdateien von Ubiquity und Subiquity unterscheiden sich grundsätzlich, erfüllen aber in etwa die gleichen Aufgaben. Sie finden Dateien mit Beispielkonfigurationen in den Ordnern für das jeweilige System.

**Wichtig:** Sehen Sie sie die Beispielkonfiguration genau an und passen Sie dieses für Ihr eigenes Vorhaben an.

**"preseed-manual-partition"** enthält die Dateien für eine minimal automatische Installation. Lokalisierung, Benutzerkonto und Passwort, Uhr/Zeitzone und Hostname werdem vorbelegt. Per Script wird nach dem Setup ein zufälliger Hostname gesetzt. Außerdem besteht im Script die Möglichkeit, zusätzliche Pakete automatisch zu installieren. Lesen Sie die Kommentare in der Datei "auto-inst.seed" beziehungsweise "autoinstall.yaml" und passen Sie die Angaben an.

**"preseed-full-vm"** enthält alle Angaben für eine vollautomatische Installation ohne Benutzereingabe. Aber Vorsicht! Die automatische Partitionierung setzt voraus, dass eine eindeutig definierte Zielfestplatte verfügbar ist. Lesen Sie die Kommentare in der Datei "auto-inst.seed" beziehungsweise "autoinstall.yaml" und passen Sie die Angaben an. Diese Methode ist vor allem für virtuelle Maschinen geeignet oder wenn sich auf physischer Hardware die Zielfestplatte eindeutig bestimmen lässt.

**Das Basissystem aus der ISO-Datei:** Wenn Sie beim Gnome-Desktop bleiben wollen, verwenden Sie das ISO des Ubuntu-Desktopsystems (https://ubuntu.com/desktop), andernfalls Ubuntu Server (https://ubuntu.com/server). Der Unterbau von Ubuntu Server unterscheidet sich kaum von der Desktop-Version, eine grafische Oberfläche wird standardmäßig nicht installiert. Xfce, Cinnamon oder KDE lassen sich daher problemlos ergänzen. Bei Ubuntu Desktop bleibt Gnome erhalten, eine andere Oberfläche wird zusätzlich installiert.

https://m6u.de/UBPRE

## Angepasstes Live-System mit Cubic erstellen
Das Tool Cubic (https://m6u.de/CUBIC) hilft mit einem Assistenten beim Erstellen einer angepassten ISO-Datei für das Ubuntu-Installationssystem. Richten Sie das Tool mit diesen vier Befehlszeilen ein:
```
sudo apt-add-repository universe
sudo apt-add-repository ppa:cubic-wizard/release
sudo apt update
sudo apt install --no-install-recommends cubic
```
Als Vorbereitung laden Sie über https://m6u.de/UBPRE das Archiv mit den Beispieldateien herunter.

**Wichtiger Hinweis:** Cubic aus dem PPA trägt zurzeit die Versionsnummer 2024.09.89 und kann mit ISO-Dateien bis Ubuntu 24.04.01 umgehen. In Ubuntu 24.04.2 hat Canonical die Struktur der Dateien verändert, woran Cubuc scheitert. Verwenden Sie daher weiter die Version 24.04.1, aus der über die Updates auch Version 24.04.2 wird. Alternativ finden Sie unter https://github.com/muquit/cubic-ubuntu-server-fix eine Cubic-Version, in der das Problem behoben ist. 

**Schritt 1:** Starten Sie das Tool und geben Sie ein Arbeitsverzeichnis an, etwa den Ordner „Cubic“ in Ihrem Home-Verzeichnis. Wenn Sie später unterschiedliche Distributionen anpassen, erstellen Sie dafür jeweils ein eigenes Arbeitsverzeichnis. Nach einem Klick auf „Next“ wählen Sie hinter „Filename“ die ISO-Datei des Ubuntu-Installationsmediums. Vergeben Sie unter "Custom Disk..." hinter "Filename" eine sinvolle Bezeichung, beispielsweise "ubuntu-server-24.04-custom.iso"

**Schritt 2:** Nach einem Klick auf „Next“ befinden sich in der virtuellen Umgebung („chroot“), also im Dateisystem des Installationssystems. Mit 
```
apt update && apt upgrade
```
aktualisieren Sie die Dateien im Live-System. Zusätzliche Pakete können Sie ebenfalls mit apt installieren. Beispielsweise Midnight Commander mit
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

**Schritt 3:** Mit einem Klick auf „Next“ verlassen Sie die chroot-Umgebung. Die Seite zeigt drei Bereiche für die entscheidenden Anpassungen. Kopieren Sie von den Beispieldateien etwa aus dem Ordner „Ubuntu_24.04_Server“ den Ordner „boot“ nach „[Arbeitsverzeichnis]/custom-disk“. Wenn Sie das Desktop-ISO verwenden, kopieren Sie den Inhalt von „Ubuntu_24.04_Desktop“. Kopieren Sie den Inhalt des Ordners "preseed-vm-full" (für eine VM) oder "preseed-manual-partiton" (für die manuelle Partitionieruing) in den Ordner „[Arbeitsverzeichnis]/custom-disk/preseed“.

Entsprechend verfahren Sie mit den Dateien aus den Ordnern "Ubuntu_22.04" und "Linux_Mint_22" beide verwenden Konfigurationsdateien für den älteren Ubiquity-Installer.

**Schritt 4:** In Cubic sind die Dateien auf den Registerkarten „Preseed“ sowie „Boot“ zu sehen und Sie können Anpassungen in den Dateien „autoinstall.yaml“ und „postinstall.sh“ vornehmen. Die Konfiguration ist kommentiert und weist auf mögliche Änderungen hin, etwa für die Einrichtung einer anderen Desktop-Umgebung. Danach klicken Sie auf „Next“.

**Wichtig:** Achten Sie auf korrekte Einrückungen in der Datei „autoinstall.yaml“. Ansonsten tritt ein Fehler auf und die automatische Installation schlägt fehl.

In der Datei „[Arbeitsverzeichnis]/custom-disk/boot/grub/grub.cfg“ sind die Menüeinträge für das Grub-Bootmenü enthalten. Darüber lässt sich steuern, welche Desktopumgebung installiert werden soll. Ein Beispiel für KDE:
```
menuentry "KDE Auto-Installation mit autoinstall.yaml" {
  set gfxpayload=keep
  linux /casper/vmlinuz ipv6.disable=1 debug firefoxdeb kde autoinstall subiquity.autoinstallpath=/cdrom/preseed/autoinstall.yaml ---
  initrd  /casper/initrd.gz
}
```
Mögliche Werte sind "ubuntu" für eine Gnome-Desktop sowie "xubuntu" und "cinnamon".

Die zusätzliche Angabe "firefoxdeb" installiert Firefox als deb-Paket. Verwenden Sie stattdessen "chromiumdeb", wenn Sie Chromium installieren wollen.

Klicken Sie auf "Next".

![autoinstall.yaml](/images/Cubic_autoinstall.yaml.png "autoinstall.yaml")

**Schritt 5:** Wählen Sie die Komprimierungsmethode. Für eine geringere Dateigröße verwenden Sie „xz“ oder für eine schnellere, aber weniger effiziente Komprimierung eine der anderen Optionen. Abschließend klicken Sie auf „Generate“.

Die angepasste ISO-Datei liegt danach im Arbeitsverzeichnis und lässt sich jetzt für die Ubuntu-Neuinstallation verwenden. Im Bootmenü sorgt „Auto-Installation mit autoinstall.yaml“ für die automatische Installation, mit den nachfolgenden Einträgen gelangen Sie wie gewohnt in das Live-System.

## Einige Besonderheiten

Die Beispieldateien für die automatische Installation decken einige Spezialfälle bei der Konfiguration ab.

**Netzwerk:** Ubuntu-Server verwendet standardmäßig Netplan für die Netzwerkkonfiguration, beim Desktop kommt dageben Network Manager zum Einsatz. Für die frühe Installation verwendet man
```
  packages:
    - network-manager
```
in der Datei autoinstall.yaml. Damit Network Manager statt systemd-networkd verwendet wird, muss die Datei "00-network-manager-all.yaml" im Ordner "/usr/lib/netplan" liegen. Diese hat folgenden Inhalt:
```
network:
  version: 2
  renderer: NetworkManager
```  
Wer Ubuntu-Desktop als Basis verwendet benötigt das nicht, weil Network Manager die Konfiguration bereits mitbringt.

**Vorgabe von Einstellungen:** Wer mit der Ubuntu-Standardkonfiguration nicht zufrieden ist, kann die Einstellungen ändern. Ein Beispiel dafür zeigt "20-nautilus-settings", womit sich die Standardansicht im Dateimanager Nautilus von "Symbolansicht" auf "Listenansicht" setzen lässt. Die Datei gehört nach "/etc/dconf/db/local.d/". Dazu benötigt man noch die Datei "/etc/dconf/profile/user". Mit "dconf update" wird der Wert in die dconf-Datenbank geschrieben.

**Paket-Download beschleunigen:** Wer mehrere Linux-PCs (Ubuntu, Linux Mint, Debian) verwendet kann den Download von Paketen bei der Installation und bei Updates mit einem Cache beschleunigen. Das ist auch bei häufigen automatischen Installationen nützlich. Die Installation des Cache erfolgt auf einem ständig verfügbaren Server-PC mit 
```  
sudo apt install apt-cacher-ng
```  
Für weitere Infos siehe [Schnellere Updates für Linux-PCs auf gleicher Basis](https://www.pcwelt.de/1150247)

Auf den Clients benötigt man die Datei „/etc/apt/apt.conf.d/02proxy“ mit einem Inhalt wie
```  
Acquire::http { Proxy "http://192.168.178.111:3142"; };
Acquire::https { Proxy "https//"; };
```
Ersetzen Sie die IP-Nummer durch die Ihres Server-PCs. Kopieren Sie "02proxy" bei Cubic in den Ordner "custom-root/etc/apt/apt.conf.d", damit das Installationssystem den Cache verwendet. In der Datei "autoinstall.yaml" sorgt die Zeile
```
- cp /cdrom/preseed/02proxy /target/etc/apt/apt.conf.d/
```
dafür, dass der Cache auch später im installierten System verwendet wird.

## Die angepasste ISO-Datei in einer virtuellen Maschine verwenden
In der Regel richtet man virtuelle Maschinen über die grafische Oberfläche Virtual Machine Manager (KVM) oder Oracle VM VirtualBox Manager (Virtualbox)  ein. Per Script geht das im Terminal auch automatisch. Die Beispieldateien finden Sie im Ordner "Create_VMs". Verwenden Sie zum Beispiel "create_qcow_vm_ubuntu_server_24.04.sh", um eine VM für Virtual Machine Manager mit einer ISO-Datei zu erstellen, die Sie auf Basis von Ubuntu Server erzeugt haben.

Das Script erwarte die ISO-Datei im Ordner "ISO" im Arbeitsverzeichnis. Passen Sie den Namen im Script an, außerdem die Bezeichung für die VM. Starten Sie das Script mit 
```
./create_qcow_vm_ubuntu_server_24.04.sh
```
Im Virtual Machine Manager erscheint eine neue VM, die automatisch startet. Wählen Sie im Grub-Bootmenü den gewünschten Einrtrag und warten Sie, bis die Installation abgeschlossen ist.

![grub_menu](/images/Grub_Menu.png "grub_menu")

Mit Virtualbox läuft es entsprechend ab. Verwenden Sie beispielsweise das Script "create_vbox_vm_ubuntu_24.04_server.sh", das Sie entsprechend Ihrer Konfiguration anpassen.

## Links
Für die automatische Installation müssen die Dateien aus der [Ubuntu-ISO-Datei](https://ubuntu.com) extrahiert werden. Anschließend baut man die eigenen Konfigurationsdateien ein und erstellt eine neue ISO-Datei. Dabei unterstützt Sie das Tool [Cubic](https://github.com/PJ-Singh-001/Cubic) mit einer grafischen Oberfläche.

Subiquity-Documentation: https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
