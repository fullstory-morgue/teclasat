Eine ausführliche Beschreibung des tecla-Pakets steht in der beigefügten Hilfe-Datei tecla08e-help-de, die als einfacher Text lesbar ist.

Eine Installationsanleitung findet sich im Anhang der  Hilfe-Datei tecla08e-help-de.

Wichtige Änderung bei tecla08d-02 gegenüber früheren Versionen:
Hilfsdateien für den Suchlauf:
Das Verzeichnis */initscan/* wurde umbenannt in */scanctrl/* .
Die Suchlisten sind nicht mehr gemeinsam mit den dvb-Dateien gespeichert, sondern in einem Verzeichnis */scanctrl/listfiles/ .
Bei Kaltstart werden soweit nötig alle 4 Senderlisten automatisch von /usr/share/teclasat/ nach .tecla kopiert.

Wichtige Änderung bei tecla08d-03: Hauptfenster aufgeräumt, tecla-Script intern aufgeräumt.

Wichtige Änderung bei tecla08e-01: Hauptfenster aufgeräumt; der 'kleine Editor', d.h. die Senderlistenbearbeitung direkt beim Hauptfenster, ist ganz wesentlich erweitert; u.a. ist eine Zwischenablage verfügbar. Die 'Selektion', d.h. die Auswahl des angewählten Senders, wird für jede Listenart (Favo1,2, Arbeits- u.Basisliste) getrennt gespeichert und auch nach einem Neustart richtig eingestellt.

Wichtige Änderung bei tecla08e-02: die Version 08e-01 wurde intensiv getestet. Anschließend wurden für die Version 08e-02 nur einige wichtige Fehler behoben, so dass sie funktionsmäßig mit der Vorgängerversion übereinstimmt und als 'stabil' gelten kann.
*** Hinweis: die Änderungen sind im Hilfe-Text noch nicht aufgenommen.


Installationsanleitung in Kurzform:
Je nach Verwendungszweck werden zwei Versionen angeboten, Details s. Hilfe-Datei.
Version A: Standard-Version als Multimedia-Paket.
Version B: 'Bastlerversion', flexibel+schnell zum Kennenlernen + Experimentieren.


A: Standard-Version.

A1: das Paket tecla08e-02.zip speichern z.B. als ~/work0/tecla08e-02.zip

A2: entpacken:
> cd work0
> unzip tecla08e-02.zip
... in ~/work0/ entstehen einige Ordner und Dateien.

A3: Als 'root' diese Verzeichnisse anlegen (falls noch nicht vorhanden):
/usr/share/teclasat/
/usr/share/teclasat/scanctrl

A4:  tecla-Script + Dienstdateien ablegen (falls noch nicht vorhanden):
/usr/share/teclasat/tecla08e-02.sh
... ~/work0/utils/* kopieren nach /usr/share/teclasat/* :
/usr/share/teclasat/tecla08d-help-de
/usr/share/teclasat/tecla08d-msg-de
/usr/share/teclasat/teclasat.ppm

A5: Transponderlisten für Suchlauf ablegen (falls noch nicht vorhanden):
... ~/work0/scanctrl/* kopieren nach /usr/share/teclasat/scanctrl/* :
/usr/share/teclasat/scanctrl/Astra-19.2E  (etc, für dvb-Scan)
/usr/share/teclasat/scanctrl/de-Berlin (etc, für dvb-t + dvb-c)
/usr/share/teclasat/scanctrl/listfiles/astra-list0 (etc, für Listen-Suchlauf)

A6: Arbeitsdateien
... ~/work0/channels/* kopieren nach ~/.tecla/* :
~/.tecla/channels.conf (etc, Senderlisten...)
~/.tecla/ARD-Favos , ~/.tecla/Radio , und ggf. noch andere.
Achtung: Wenn tecla bei einem Kaltstart diese Arbeitsdateien nicht in ~/.tecla/ vorfindet, dann versucht tecla sie von /usr/share/teclasat/ nach ~/.tecla/ zu kopieren, oder legt sie ersatzweise als Leerdateien an.

A7: Das Script /usr/share/teclasat/tecla08e-02.sh 'ausführbar' machen.
ggf. einen Soft-link 'teclasat' oder 'ted' oder ähnlich anlegen.
Ggf. als Starthilfe ein Icon 'teclasat' oder ähnlich anlegen.

A8: Optional: Es ist möglich, eine vorgefertigte Konfigurationsdatei abzuspeichern.
Stattdessen wird jedoch ein 'Kaltstart' empfohlen. Einzelheiten s. Hilfe-Datei.
Die mitgelieferte tecla08d.conf ist auf die Bastler-Version (B) abgestimmt.
Ggf. wäre abzuändern:
utildir   = /usr/share/teclasat
scanfile  = /usr/share/teclasat/scanctrl/de-Berlin
scandir   = /usr/share/teclasat/initscan
Bei Kaltstart werden diese Einstellungen von tecla automatisch eingerichtet.



B: 'Bastlerversion'.

B1: das Paket tecla08e-02.zip speichern z.B. als ~/work0/tecla08e-02.zip

B2: entpacken:
> cd work0
> unzip tecla08e-02.zip
... in ~/work0/ entstehen einige Ordner und Dateien.

B3: Verzeichnisse anlegen:
~/pctv/tecla
~/pctv/utils
~/pctv/scanctrl

B4:  tecla-Script + Dienstdateien ablegen:
~/pctv/tecla/tecla08e-02.sh
... ~/work0/utils/* kopieren nach ~/pctv/utils/* :
~/pctv/utils/tecla08d-help-de
~/pctv/utils/tecla08d-msg-de
~/pctv/utils/teclasat.ppm

B5: Transponderlisten für Suchlauf ablegen:
... ~/work0/scanctrl/* kopieren nach ~/pctv/scanctrl/* :
~/pctv/scanctrl/Astra-19.2E  (etc, für dvb-Scan)
~/pctv/scanctrl/de-Berlin (etc, für dvb-t + dvb-c , soweit nötig)
~/pctv/initscan/astra-shortlist (etc, für Listen-Suchlauf)

B6: Arbeitsdateien
... ~/work0/channels/* kopieren nach ~/.tecla/* :
~/.tecla/channels.conf (etc, Senderlisten...)
~/.tecla/ARD-Favos , ~/.tecla/Radio , und ggf. noch andere.
Wenn diese Arbeitsdateien nicht installiert werden, dann legt tecla sie als Leerdateien an.

B7: Das Script ~/pctv/tecla/tecla08e-02.sh 'ausführbar' machen.
Ggf. als Starthilfe ein Icon 'teclasat' oder ähnlich anlegen, bzw. einen Softlink anlegen.

B8: Optional: Konfigurationsdatei abspeichern.
Die mitgelieferte Datei tecla08d.conf kann installiert werden,
ein 'Kaltstart' wird jedoch empfohlen. Einzelheiten s. Hilfe-Datei.
