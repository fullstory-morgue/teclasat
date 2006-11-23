#!/bin/sh
#  tom/wol 20.04.2006
# starten der tcl shell \
exec wish "$0" "$@" "$HOME"
# Prozeduren fuer die Tabs inkludieren ;  test code Umlauts: äöüÄÖÜß
package require Iwidgets 4.0
#
    set myVersion0 tecla08e-02          ;#  Version Name (complete)
    set home       $argv                ;#  home directory (automatically set)
    set tmsg       tecla08e-msg         ;#  file for labels & message texts
    set thelp      tecla08e-help        ;#  file for help text
    set lang       -default             ;#  default language
    set dutil1     /usr/share/teclasat  ;#  std. directory for utility files
    set dutil2     $home/pctv/utils     ;# alternative directory for utility files
    set dutil3     $home/.tecla         ;# alternative directory for utility files
    set dutil4     /usr/local/share/teclasat  ;#  altern.directory for utility files
    set dutil      $dutil1                  ;# initial directory
    set teclaconf  $dutil3/tecla08e.conf    ;#  configuration directory + file
#  possible suffixes for fmsg + fhelp: -de -en -es -test -default
#
#
#
#
#######################################################################################
# Dieses Script wird freigegeben in sinngemaesser Anwendung der GPL, wie folgt:       #
# 1. Jedermann darf das Script unentgeltlich benutzen, aendern und weitergeben.       #
# 2. Jede Weitergabe darf nur unter diesen gleichen Bedingungen erfolgen.             #
# 3. Wer das Script veraendert, muss als erstes in Zeile 8 den Versionscode abaendern:#
#    Das Format 'teclaXXA-YY' (z.B. tecla06p-03) ist fuer das Pinux-Team reserviert.  #
#    Fuer modifizierte Scripte soll als Suffix '-YY' ein Namenskuerzel sowie          #
#    eine Kennnummer geschrieben werden, z.B. tecla06q-tt4.                           #
# 4. Die Versionsnummer soll sich auch im Datei- oder Paket-Namen wiederspiegeln.     #
#######################################################################################

#*************************************************************************************************
#     Prozedur view-on {}  startet die Receiver und die Player
#*************************************************************************************************
#
proc view-on {} {
    global tan home receivertyp playertyp recchan recmode playmode
    global tab sel cbut1 zap wait1 ad optvs optas CHAN sel
    global ms73 ms74 ms76 ms77 ms78 ms79 ms80 ms81 ms82 ms83 ms85
#
# ausgewaeltes Element der Liste einlesen
    $tab selection set $sel($tan) ; update  ;# Selektion sicherstellen
    if {[catch {  $tab get $sel($tan) } CHAN ] } { Err 46 $ms73 ; return }
    set playchan $CHAN      ;# save the channel name
    set liste [aLif]  ;# aktuelle Senderliste waehlen: blist wlist favo1 favo2
#
#  recmode pruefen:  0 = record aus, 1 = record Pause, 2 = record ein
#
    if { $recmode == 2 } { ;#  recmode = 2:  Aufnahme aktiv;
      tk_messageBox -type ok -message "$ms74$recchan; \n$ms85" ; return
    } elseif { $recmode == 1 } {
#   recmode = 1:  Aufnahme 'Pause'
      if { $recchan != $playchan } {
        set button [tk_messageBox -type okcancel -icon warning\
	  -message "$ms76$recchan; \n$ms77$playchan?"]
        if { $button == "cancel" } { return }
      } ;#  end if new channel
    } ;#  end if recmode = 1 or 2, i.e. recording active
#
#  recording inactive:
    view-off    ;#  aktive Receiver+Player killen
#puts "view-on; exec= *exec $zap -a$ad -c /$liste -r $CHAN &*"
#  angewaehlten Receiver + Player starten:
#  player = xine
    if {$playertyp == "xine" } {
      if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x0] {
        tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
      if [catch {exec xine -g stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x1] {
	if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x2] {
	  tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
	exec sleep [ expr $wait1/double(1000) ]
	if [catch {exec xine -g stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x3] {
          exec sleep 2
          if [catch {exec xine -g stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x4] {
            tk_messageBox -type ok -message $ms80 ; return }
	} ;# end 2nd attempt
      } ;# end if $zap+xine gestartet
#
#  player = kaffeine
    } elseif {$playertyp == "kaffeine" } {
      if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x0] {
        tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
      if [catch {exec kaffeine stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x1] {
	if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x2] {
	  tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
	exec sleep [ expr $wait1/double(1000) ]
	if [catch {exec kaffeine stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x3] {
          exec sleep 2
	  if [catch {exec kaffeine stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x4] {
	    tk_messageBox -type ok -message $81 ; return }
        } ;# end start kaffeine 2nd attempt
      } ;# end start $zap+kaffeine
#
#  player = totem
    } elseif {$playertyp == "totem" } {
      if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x0] {
        tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
      if [catch {exec totem stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x1] {
	if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x2] {
	  tk_messageBox -type ok -message "$ms78 $zap $ms79" ; return }
	if [catch {exec totem stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x3] {
          exec sleep 2
          if [catch {exec totem stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &} x4] {
	    tk_messageBox -type ok -message $ms82 ; return }
        } ;# end start totem 2nd attempt
      } ;# end $zap+totem
#

#  player = mplayer
    } elseif {$playertyp == "mplayer" } {
      if { $recmode == 0 } {

#######################################################################################
# Mplayer greift ohne szap direkt auf dvr0 zu (da problematisch vorers auskommentiert)#
# Soft-Link zur channels.conf setzen: zur direkten Senderwahl in MPlayer noetig       #
#         catch {exec ln -sf $liste /$home/.mplayer/channels.conf}                    #
# $zap blockiert dem mplayer und muss gekillt werden, wenn keine Aufnahme             #
#         catch {exec killall $zap}                                                   #
#         if [catch {exec mplayer -vo xv -ao arts dvb://$CHAN \                       #
#                       > $home/.mplayer/mplayer.log 2>&1 &} x2]                      #
#######################################################################################

        if [catch {exec $zap -a$ad -c /$liste -r $CHAN &} x1] {
          	tk_messageBox -type ok -message "$ms78 $zap $ms79"
          exit
        } ;# end if szap ok
        if [catch {exec cat /dev/dvb/adapter$ad/dvr0 | mplayer -vo $optvs -ao $optas \
	    -cache 2048 -  > $home/.mplayer/mplayer.log 2>&1 &} x2] {
	 	tk_messageBox -type ok -message $ms83 ; return }
      } ;# end mplayer starten
    } ;# end playertyp = xine, kaffeine, totem, mplayer
#
    setKey11off ; set playmode 1  ;#  playmode > 0: a player is active
  } ;# end proc. view-on
#
#*************************************************************************************************
#  Proc.view-off {}  terminates the active receiver+player program
#*************************************************************************************************
#
proc view-off {} {
    global cbut1 zap playertyp playmode
    set proglist [list $zap $playertyp]
    kill-progs $proglist                ;#  aktive Player & receiver killen
    setKey11on ; set playmode 0         ;#  playmode = 0: all players are idle
  } ;# end proc. view-off
#
#  proc setKey11off {} sets the 'view-on' key ($cbut1.b1) to 'view-off'
#
proc setKey11off {} {
    global xbut11 ms2 cbut1 offbut offcolor bgcolor
    if { $offbut } { $cbut1.b1 configure -bg $offcolor
    } else { $cbut1.b1 configure -bg $bgcolor } ; set xbut11 $ms2
  } ;# end proc.setKey11off
#
#  proc setKey11on {} sets the 'view-on' key ($cbut1.b1) to 'view-on'
#
proc setKey11on {} {
    global xbut11 ms1 cbut1 bgcolor
    $cbut1.b1 configure -bg $bgcolor ; set xbut11 $ms1
  } ;# end proc.setKey11off
#
#
#*************************************************************************************************
#  Proc. view-next {}  schaltet in der Favo/Radioliste einen Kanal weiter             *
#*************************************************************************************************
#
proc view-next {} {
    global  tan sel cnames CHAN playmode
    if { $tan >= 4 } { return } ;# titel list: ignore keystroke
    set selChan [lindex $cnames $sel($tan) ]
    if { $playmode } {
      if { $selChan == $CHAN } {
        while { $cursel > 0 } {
	  sel-down; if {[string range [lindex $cnames $cursel] 0 1] != "__" } {break}
        } ;# end while doing sel-down
      } ;# end if playing selected channel
    } ;# end if playmode
    view-on ;# turn view on
  } ;# end proc. view-next
#
#*************************************************************************************************
#  Proc. view-prev {}  schaltet in der Favo/Radioliste einen Kanal zurueck            *
#*************************************************************************************************
#
proc view-prev {} {
    global  tan sel cnames CHAN playmode
    if { $tan >= 4 } { return } ;# titel list: ignore keystroke
    set selChan [lindex $cnames $cursel ]
    if { $playmode } {
      if { $selChan == $CHAN } {
        while { $cursel > 0 } {
	  sel-up ; if {[string range [lindex $cnames $cursel] 0 1 ] != "__" } { break }
        } ;# end while doing sel-up
      } ;# end if playing selected channel
    } ;# end if playmode
    view-on ;# turn view on
  } ;# end proc. view-prev
#
#
#*************************************************************************************************
#  Proc. view-home {}  schaltet den Heimat-Kanal ein
#*************************************************************************************************
#     >>>   experimentell !!!  <<<
proc view-home {} {
  global tan homechnf homechnf
  if { $tan < 2  } { set tan 2 ; updateTable }
  if { $tan == 4 } { set tan 2 ; updateTable }
  if { $tan == 5 } { set tan 3 ; updateTable }
  } ;# end proc.view-home
#
#*************************************************************************************************
#  Proc. view-last {}  schaltet den vorigen Kanal ein
#*************************************************************************************************
#
proc view-last {} {
  } ;# end proc.view-last
#
#*************************************************************************************************
#  Proc. setHomeChannel {}  stores the home channel
#*************************************************************************************************
#
proc setHomeChannel {} {
  } ;# end proc.setHomeChannel
#
#*************************************************************************************************
#  Proc. prev-title {}  selects the previous title
#*************************************************************************************************
#
proc prev-title {} {
    global tan tab sel cnames
    if { $tan < 2 } { return } ; if { $tan > 3 } { return } ;# favo- or radio mode only
    set lin $sel($tan) ; set twotitles 0
    while { $lin >= 0 } {
      incr lin -1 ; set titlekey [string range [lindex $cnames $lin] 0 1 ]
      if { $titlekey == "__" } { if { $twotitles } { break } else { set twotitles 1 } }
    } ;# end while looking for titles
    if { $titlekey == "__" } {
      $tab selection clear 0 [$tab size] ;# clear all selections
      selChannel [lindex $cnames $lin] 1
    } ;# end if titlefound
  } ;# end proc.prev-title
#
#*************************************************************************************************
# Proc. next-title {}  switches to the next title (if any)                            *
#*************************************************************************************************
#
proc next-title {} {
    global tan tab sel cnames
    if { $tan < 2 } { return } ; if { $tan > 3 } { return } ;# favo- or radio mode only
    set lin $sel($tan)
    while { $lin < [llength $cnames ] } {
      incr lin ; set titlekey [string range [lindex $cnames $lin] 0 1 ]
      if { $titlekey == "__" } { break }
    } ;# end while looking for titles
    if { $titlekey == "__" } {
      $tab selection clear 0 [$tab size] ;# clear all selections
      selChannel [lindex $cnames $lin] 1
    } ;# end if titlefound
  } ;# end proc.next-title
#
#*************************************************************************************************
#     Prozedur checkRecmode {}  checks recmode:  recordin active or suspended ?       *
#*************************************************************************************************
#
proc checkRecmode {} {
    global recmode recchan playchan ms76 ms77 ms84 ms85
#
    if { $recmode == 2 } {
#   recmode = 2:  Aufnahme aktiv;
      tk_messageBox -type ok \
	-message "$ms84 $recchan; \n$ms85"
      return
    } elseif { $recmode == 1 } {
#   recmode = 1:  Aufnahme 'Pause'
      if { $recchan != $playchan } {
        set button [tk_messageBox -type okcancel -icon warning\
	  -message "$ms76 $recchan; \n$ms77 $playchan?"]
        if { $button == "cancel" } { return }
      } ;#  end if new channel
    } ;#  end if recmode = 1 or 2, i.e. recording active
  } ;# end proc. checkRecmode
#
#***********************************************************************************
#  Proc. kill-progs {proglist}  terminates the 'proglist' programs                 *
#***********************************************************************************

proc kill-progs {proglist} {
    global wait2 ms87
    foreach prg  $proglist { catch {exec killall -9 $prg } } ;# kill all progs
#
    exec sleep [expr $wait2/double(1000)] ;# wait 'wait2' msecs
#  pass 2: use kill -6 to kill all remaining progs
    foreach prg  $proglist {
      set pid [lindex [exec ps ax | sed -e "/$prg/!d" -e "/sed/d"] 0 ]
      if {[string length $pid]} then { catch {exec kill -6 $pid & } }
    } ;# foreach prg do kill -6 prg
#  pass 3: use lsof to check if any prog is using dvr0
    set cnt 0  ; while { 1 } { set ofil ""
      catch { set ofil [exec lsof 2> /dev/null | grep dvr0 ] } ofil1
      if { ![string length $ofil] } { return } ;# no more active processes
      set prg [lindex $ofil 0 ] ; catch { exec killall -9 $prg }
      incr cnt ; if { $cnt > 5 } { Err a13 "$prg $ms87" ; return }
      exec sleep [expr 1e-1] } ;# end while
  } ;# end proc. kill-progs
#
#***********************************************************************************
#     Prozedur record-on {}  startet die Aufnahme                                  *
#***********************************************************************************

proc record-on {} {
    global tan home receivertyp playertyp mrecfil recmode playmode recchan
    global tab cbut2 zap ad sel maunam autoname mrecfil recfila ms89 ms90
#
# angewaehlten Sendernamen einlesen
    $tab selection set $sel($tan)   ;# Sender wieder anwaehlen
    set CHAN  [ $tab get $sel($tan)  ]
    set liste [aLif]    ;#  aktuelle Senderliste anwaehlen
#
#  Aufzeichnungs-Datei festlegen
#  Sicherstellen, dass recdir existiert:
    set recdir [file dirname $mrecfil]
    if {![file isdirectory   $recdir ]} { catch [exec mkdir -p $recdir ] }
    if {![file isdirectory   $recdir ]} {
      set fil [tk_getSaveFile -initialdir $recdir \
                                   -title "$ms89\n$ms90" -defaultextension .ts]
      $tab selection set $sel($tan)   ;# Sender wieder anwaehlen
      if { $fil == ""} { return } else { set mrecfil fil }
      saveConfig ; set recdir [file dirname $mrecfil]
    } ;# end if no valid recdir
#
    if { !$maunam } { set ticks [clock seconds]
      make-autoname $mrecfil $CHAN $ticks $ticks ; set recfila [lindex $autoname 0]
    } else { set recfila $mrecfil  } ;# end if maunam
#
#  Aufnahme vorbereiten
    set recchan $CHAN               ;#  aktiver Sender fuer die Aufnahme
    set proglist [list xine mplayer kaffeine szap tzap czap tee cat]
    kill-progs $proglist            ;#  alle Player & receiver killen
    set recmode 2                   ;#  recmode aktiv
    if { $maunam == 2 } { catch { exec rm $recfila } } ;# delete old record file
    setKeys4rec-on ;# set keys: Stop + Pause
#
#  Aufnahme starten: nur in recfila speichern wenn playmode off
#
    if {$playmode == 0 } {
      exec $zap -a$ad -c /$liste -r $CHAN &
      exec cat /dev/dvb/adapter$ad/dvr0 > $recfila  &
    } else {
#
#  playmode on, Player = xine
      if {$playertyp == "xine"} {
        exec $zap -a$ad -c /$liste -r $CHAN &
        exec cat /dev/dvb/adapter$ad/dvr0 | tee $recfila | xine -g stdin://mpeg2 &
#
#  playmode on, Player = kaffeine
      } elseif {$playertyp == "kaffeine" } {
        exec $zap -a$ad -c /$liste -r $CHAN &
        exec cat /dev/dvb/adapter$ad/dvr0 | tee $recfila | kaffeine stdin://mpeg2 &
#
#  playmode on, Player = totem
      } elseif {$playertyp == "totem" } {
        exec $zap -a$ad -c /$liste -r $CHAN &
        exec cat /dev/dvb/adapter$ad/dvr0 | tee $recfila | totem stdin://mpeg2 &
#
#  Player = mplayer
      } elseif {$playertyp == "mplayer" } {
        exec $zap -a$ad -c /$liste -r $CHAN &
        exec cat /dev/dvb/adapter$ad/dvr0 | tee $recfila | mplayer -cache 2048 - &
      } ;# end playertyp = xine, kaffeine, totem, mplayer
    } ;# end if playmode off or on
  } ;# end proc. record
#
#***********************************************************************************
#     Prozedur record-pause {}  unterbricht die Aufnahme                           *
#***********************************************************************************
#
proc record-pause {} {
    global tan playertyp recfila recmode playmode recchan xbut22 ms8 tab cbut2 ad
#
    if {$playmode == 0 } { set proglist [list cat]
    } else {               set proglist [list tee cat $playertyp] }
    kill-progs $proglist
    set liste [aLif]    ;#  aktuelle Senderliste anwaehlen
#
#  if playmode active: re-start the player
#
    if { $playmode > 0 } {
      if {$playertyp == "xine"} {
        catch {exec xine -g stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "kaffeine" } {
        catch {exec kaffeine stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "totem" } {
        catch {exec totem stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "mplayer"  } {
    	set CHAN $recchan
	catch {exec cat /dev/dvb/adapter$ad/dvr0 | mplayer -cache 2048 - &}
      } ;# end playertyp
    } ;# end if playmode active
#
    set recmode 1 ; set xbut22 $ms8              ;#  recmode 'Pause'
  } ;# end proc. record-pause
#
#***********************************************************************************
#     Prozedur record-resume {}  setzt die Aufnahme nach der Pause fort            *
#***********************************************************************************
#
proc record-resume {} {
    global tan playertyp recfila recmode playmode recchan blist xbut22 ms7
    global tab cbut2 zap ad
#
    if {$playmode == 0 } { set proglist [list cat]
    } else {               set proglist [list tee cat $playertyp] }
    kill-progs $proglist
    set liste [aLif]    ;#  aktuelle Senderliste anwaehlen
#
#  Aufnahme starten: nur in recfila speichern wenn playmode off
    set xbut22 $ms7 ; set CHAN $recchan
    if {$playmode == 0} {
      exec $zap -a$ad -c /$liste -r $CHAN &
      exec cat /dev/dvb/adapter$ad/dvr0 >> $recfila  &
    } else {
#
#  playmode on, Player = xine
      if {$playertyp == "xine"} {
        exec cat /dev/dvb/adapter$ad/dvr0 | tee -a $recfila | xine -g stdin://mpeg2 &
#
#  playmode on, Player = kaffeine
      } elseif {$playertyp == "kaffeine" } {
        exec cat /dev/dvb/adapter$ad/dvr0 | tee -a $recfila | kaffeine stdin://mpeg2 &
#
#  playmode on, Player = totem
      } elseif {$playertyp == "totem" } {
        exec cat /dev/dvb/adapter$ad/dvr0 | tee -a $recfila | totem stdin://mpeg2 &
#
#  playmode on, Player = mplayer
      } elseif {$playertyp == "mplayer" } {
        set PID [exec ps ax | sed -e "/$zap/!d" -e "/sed/d"]
	if {[string length $PID] < 2} { exec $zap -a$ad -c /$liste -r $CHAN & }
        exec cat /dev/dvb/adapter$ad/dvr0 | tee -a $recfila | mplayer -cache 2048 - &
      } ;# end playertyp = xine, kaffeine, mplayer
    } ;# end if playmode active
  } ;# end proc. record-resume
#
#
#*************************************************************************************************
#     Prozedur record-off {}  terminates die Aufnahme                                    *
#*************************************************************************************************
#
proc record-off {} {
    global tan home playertyp recmode playmode recchan
    global tab cbut2 zap ad
#
    if {$playmode == 0 } { set proglist [list cat szap tzap czap]
    } else {               set proglist [list tee cat $playertyp] }
    kill-progs $proglist
    set liste [aLif]    ;#  aktuelle Senderliste anwaehlen
    setKeys4rec-off
#
#  if playmode active: re-start the player
#
    if { $playmode > 0 } {
      if {$playertyp == "xine"} {
        catch {exec xine -g stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "kaffeine" } {
        catch {exec kaffeine stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "totem" } {
        catch {exec totem stdin://mpeg2 </dev/dvb/adapter$ad/dvr0 &}
      } elseif {$playertyp == "mplayer"  } {
	catch {exec ln -sf /$liste /$home.mplayer/channels.conf}
	set CHAN $recchan
	kill-progs $zap
        catch {exec mplayer -vo xv -ao oss dvb://$CHAN \
                        > $home/.mplayer/mplayer.log 2>&1 &} x2
      } ;# end playertyp
    } ;# end if playmode active
  } ;# end proc. record-off
#
#*************************************************************************************************
# Utils for 'record': set the keys $cbut2.b1 + b2 to: on, off, pause, resume
#*************************************************************************************************
#
#  proc setKeys4rec-on {} sets the record keys after 'record-on'
#
proc setKeys4rec-on {} {
    global xbut21 xbut22 ms7 ms9 cbut2 offbut offcolor bgcolor
    set xbut21 $ms9 ; set xbut22 $ms7
    if { !$offbut } { $cbut1.b1 configure -bg $bgcolor
    } else { $cbut2.b1 configure -bg $offcolor ; $cbut2.b2 configure -bg $offcolor }
  } ;# end proc.setKeys4rec-on
#
#  proc setKeys4rec-off {} sets the record keys after 'record-off'
#
proc setKeys4rec-off {} {
    global xbut21 xbut22 ms4 ms6 cbut2 bgcolor
    set xbut21 $ms6 ; set xbut22 $ms4
    $cbut2.b1 configure -bg $bgcolor ; $cbut2.b2 configure -bg $bgcolor
  } ;# end proc.setKeys4rec-off
#
#*************************************************************************************************
# Proc.timerdef does the timer dialog
#*************************************************************************************************
#
proc timerdef { } {
    global xtid2 xtid6a xtid6c recser wtid timdir jobfile trecfil recfila taunam dohalt
    global tan tab ms13 ms70 ms71 ms91 ms92 ms93 ms94 ms95 ms96 ms97 ms98 ms99 ms101
    global ms102 ms103 ms107 ms108 ms109 ms123 ms127 ms267 ms424 ms460
    global ms326 ms327 ms328 ms329 ms330 ms332 ms333 ms334
#
    if {![file isdirectory $timdir]} { exec mkdir $timdir }
    set jobfile $timdir/joblist.dat; if {![file exists $jobfile]} {exec touch $jobfile}
    set wtid "" ; set liste [aLif] ;# list names: base,work,etc..
#
    set tid0 .rec ; if { [winfo exists $tid0] } { return }
    toplevel $tid0 ; wm title $tid0 $ms91 ;  wm geometry $tid0 -40-80
    set tid  $tid0.a ; frame $tid ; pack $tid -side right
#  Header
    set tid1 $tid.f1 ; frame $tid1
    label $tid1.m1 -text $ms92 ;  pack  $tid1.m1 -pady 5
#  recording date: single recording or series
    set tid2  $tid.f2 ; labelframe $tid2
    set tid2a $tid2.a ; frame $tid2a ;  set tid2b $tid2.b ; frame $tid2b
    label $tid2a.m1 -text $ms332 -width 12
    iwidgets::dateentry $tid2a.nad -labeltext "yyyy-mm-dd" -labelpos e -int 1
    label $tid2b.m1 -text $ms107 -width 14
    checkbutton $tid2b.b1 -textvariable xtid2 -width 18 -anchor w -variable recser \
      -command "timerSetseries"
    button $tid2b.b2 -text $ms108 -width 9 -command "timerserie"
    pack $tid2a.m1 $tid2a.nad -side left -padx 16
    pack $tid2b.m1 $tid2b.b1 $tid2b.b2 -side left -padx 6
    pack $tid2a $tid2b -anchor w
#  start time, stop time, halt
#  'Beginn': start time
    set tid3 $tid.f3 ; labelframe $tid3 ; set tid3t $tid3.times ; frame $tid3t
    set tid3a $tid3t.a ; frame $tid3a ;  set tid3b $tid3t.b ; frame $tid3b
    label $tid3a.m1 -text Beginn -width 8
    iwidgets::spintime  $tid3a.nat -secondon false \
	   -hourlabel $ms94 -minutelabel $ms95 -orient horizontal -labelpos n
    pack $tid3a.m1 $tid3a.nat -side left -padx 6 -pady 6
#  'Ende': stop time
    label $tid3b.m1 -text $ms333 -width 8
    iwidgets::spintime  $tid3b.net -secondon false \
	   -hourlabel $ms94 -minutelabel $ms95 -orient horizontal -labelpos n
    pack $tid3b.m1 $tid3b.net -side left -padx 6 -pady 6
    pack $tid3a $tid3b -anchor w
    $tid3b.net show [expr [$tid3a.nat get -clicks] + 3600 ]
#  halt option: halt computer at stop time
    set tid3h $tid3.halt ; frame $tid3h ; set dohalt 0
    label $tid3h.m1 -text $ms326
    label $tid3h.m2 -text $ms327
    checkbutton $tid3h.but -text $ms328 -variable dohalt
    pack  $tid3h.m1 $tid3h.m2 $tid3h.but
    pack $tid3t -side left -padx 6 ; pack  $tid3h -side left -padx 10 -anchor s
#  'Sender': channel
    set tid5 $tid.f5 ; labelframe $tid5
    label $tid5.m1 -text $ms334 -width 12
    iwidgets::optionmenu $tid5.chn
    set len [$tab index end] ; set cur [$tab curselection]
    if { ![string length $cur] } { set cur 0 } ;# nothing selected
    if { [string range [$tab get $cur] 0 1] == "__" } { incr cur }
    for {set x 0} {$x < $len} {incr x} {$tid5.chn insert end [$tab get $x] }
    if { $cur <= $len } { $tid5.chn select $cur }
    pack $tid5.m1 $tid5.chn -side left
#  'Datei': record file or auto-name flag
    set xtid6a [file tail $trecfil] ; set xtid6c [file dirname $trecfil]
    set tid6 $tid.f6 ; labelframe $tid6
    set tid6a $tid6.a ; frame $tid6a ;  set tid6b $tid6.b ; frame $tid6b
    label $tid6a.m1 -text $ms127 -width 18 -anchor e
    label $tid6a.m2 -textvariable xtid6a -width 35 -anchor w
    pack $tid6a.m1 $tid6a.m2 -side left
#
    label $tid6b.m1 -text $ms109 -width 20
    checkbutton $tid6b.b1 -width 10 -anchor w -variable taunam ;#-command "timerAutoname"
    button $tid6b.b2 -text $ms267 -width 9 -command "getTrecfil"
    pack $tid6b.m1 $tid6b.b1 $tid6b.b2  -side left
#
    set tid6c $tid6.c ; frame $tid6c
    label $tid6c.m1 -text $ms460 -width 18 -anchor e
    label $tid6c.m2 -textvariable xtid6c -width 35 -anchor w
    pack $tid6c.m1 $tid6c.m2  -side left
    pack $tid6a -anchor w ; pack $tid6b -anchor e ; pack $tid6c -anchor w
#
#  text field for job list; see proc.showJoblist for description
    set tid7 $tid.f7 ; set jol $tid7.t ; labelframe $tid7 -padx 4 -pady -4
    text $jol -width 65 -height 5 -wrap none \
              -xscrollcommand "$tid7.xsbar set" -yscrollcommand "$tid7.ysbar set"
    scrollbar $tid7.xsbar -orient horizontal -command "$tid7.t xview"
    scrollbar $tid7.ysbar -orient vertical   -command "$tid7.t yview"
    grid $jol $tid7.ysbar -sticky nsew
    grid $tid7.xsbar -sticky nsew
    grid columnconfigure $tid7 0 -weight 1
    grid rowconfigure    $tid7 0 -weight 1
    $jol configure -tabs {1.5i 2.15i 2.8i 3.25i 5i 6.5i 7.5i}
    set f1 {-*-Helvetica-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
    $jol configure -font $f1
#
#  system buttons: store, delete, home
    set tid8 $tid.f8 ; frame $tid8
    set tid8a $tid8.a ; labelframe $tid8a -text $ms71
    button $tid8a.b1 -text $ms70  -width 9 -command "destroy $tid0"
    pack $tid8a.b1 -side right -padx 4
    set tid8b $tid8.b ; labelframe $tid8b -text $ms329
    button $tid8b.b4 -text $ms13 -width 9 -command "manRecord"
    pack $tid8b.b4 -side right -padx 4
    set tid8c $tid8.c ; labelframe $tid8c -text $ms330
    button $tid8c.b2 -text $ms98  -width 9 -command "timerStore"
    button $tid8c.b3 -text $ms424 -width 9 -command "timerDel" ;# 424 , 103
    pack $tid8c.b2 $tid8c.b3 -side left -padx 4
    pack $tid8a $tid8b $tid8c -side right -pady 4 -padx 4
#
#  pack all items
    set wtid [list $tid0 $tid2a.nad $tid3a.nat $tid3b.net $tid5.chn $jol]
    pack $tid8 -side bottom -pady 8 -padx 8
    pack $tid7 -side bottom -expand 1 -fill x -pady 8 -padx 8
    pack $tid6 $tid5 $tid3 $tid2 -side bottom -pady 8 -padx 8
    pack $tid1 -side bottom
    showJoblist ;# timerAutoname ;# show list of stored timer jobs + file name
#
    bind $jol <ButtonRelease-1> "selJoblin $jol"
    $jol tag  configure "linsel"  -background red -foreground white
    bind .rec <Shift-KeyPress-Up>   {.rec.f3.nat show \
      [expr [.rec.f3.nat get -clicks] +50] ; .rec.f4.net show [.rec.f3.nat get]}
    bind .rec <Shift-KeyPress-Down> {.rec.f3.nat show \
      [expr [.rec.f3.nat get -clicks] -50] ; .rec.f4.net show [.rec.f3.nat get]}
    bind .rec <Control-KeyPress-Up>   \
                     {.rec.f4.net show [expr [.rec.f4.net get -clicks] +50]}
    bind .rec <Control-KeyPress-Down> \
                     {.rec.f4.net show [expr [.rec.f4.net get -clicks] -50]}
  } ;# end proc.timerdef
#
#  proc.selJoblin marks a complete joblist line as 'selected'
proc selJoblin { jol } {
    update ; catch { $jol tag remove "linsel" 1.0 end }
    $jol tag add "linsel" "insert linestart" "insert lineend" ;  update
  } ;# end proc selJoblin
#
#*************************************************************************************************
#  Proc.showJoblist { } shows the job list in the text field
#*************************************************************************************************
#  each joblist line contains 10 items, separated by tabs:
#  ***  day nat net chan file JOB jon nad ned trecfil  ***
#  day = date (yyyy-mm-dd) or weekday name(s), e.g. Mittwoch or Mo,Mi,Fr ;
#  trecfil = dir/tail of std.rec.file; file = tail or (auto)
#  JOB = at or crontab job; jon = job nbr for anf+end files
#  nad, ned = anf+end day, (yyyy-mm-dd) or weekday codes, e.g. 3 of 1,3,5
#
proc showJoblist { } {
    global wtid jobfile
    set jol [lindex $wtid 5] ; set pr "showJoblist"
    catch { $jol configure -state normal } ; $jol delete 1.0 end
    set e1 [ catch { open $jobfile r } fid ] ; if { $e1 } { Err b2 $fid ; return }
    while {![eof $fid]} { set e2 [ catch { gets $fid } curl ] ; if {$e2} {Err b3 $curl ; return}
      if {[string length $curl]} { regsub -all " " $curl "\t" culi ; $jol insert end "$culi\n" } }
    update ; catch { $jol see end } ; catch { $jol configure -state disabled }
  } ;# end proc.showJoblist-old
#
#*************************************************************************************************
#  Prozedur timerserie Serienaufnahme
#*************************************************************************************************
#
proc timerserie { } {
    global wtid retval xtid2
    global ms12 ms117 ms118 ms119 ms335 ms336 ms337 ms338 ms339 ms340 ms341 ms342
#
    set tid0 [lindex $wtid 0] ; set wser $tid0.b ;
    if { [winfo exists $wser] } { return } ; frame $wser
    label $wser.head -text $ms117 -width 30; pack $wser.head -pady 5
#
    proc selCmd { wser } {
      global xtid2 recser retval ms118 ms335 ms336 ms337 ms338 ms339 ms340 ms341 ms342
      set daylist [list $ms335 $ms336 $ms337 $ms338 $ms339 $ms340 $ms341 $ms342]
      set INDEX [$wser.slb getcurselection]
      if {[string match $ms118 $INDEX]} { $wser.slb selection clear 1 end; set SEL "*"
      } else { $wser.slb selection clear 0 ;  set SEL [$wser.slb curselection]
      } ;# end if string match; returns 1..7 for mon..sun, * for 'dayly'
      regsub -all " " $SEL "," retval   ;# replace spaces by commas
      if { $SEL == "*" } { set xtid2 $ms335
      } elseif { [ string length $SEL ] == 1 } { set xtid2 [lindex $daylist $SEL]
      } else { set xtid2 ""
        foreach id $SEL { append xtid2 "[string range [lindex $daylist $id] 0 1] "} }
      if { $xtid2 == "" } { set recser 0 } else { set recser 1 } ;# series recording on
    } ;# end proc. selCmd
#
    iwidgets::scrolledlistbox $wser.slb -selectmode multiple -vscrollmode static \
             -hscrollmode static -labeltext $ms119 -selectioncommand "selCmd $wser"
    button $wser.ok -text $ms12 -width 9 -height 1 -command "destroy $wser"
    pack $wser.slb -padx 10 -pady 10 -fill both -expand yes ;  pack $wser.ok
    $wser.slb insert end $ms335 $ms336 $ms337 $ms338 $ms339 $ms340 $ms341 $ms342
    pack $wser -side right
    $wser.slb selection set 0 ; set retval "*" ; set xtid2 $ms335
  }  ;# end proc. timerserie
#
#*************************************************************************************************
#  Proc.timerSetseries sets or clears the series flag
#*************************************************************************************************
#
proc timerSetseries { } {
    global recser xtid2
    update ; if { $recser } {timerserie} else { set xtid2 "" ; catch {destroy .serie}}
  } ;# end proc.timerSetseries

#*************************************************************************************************
#  Proc.getTrecfil { } gets the trecfil path + filename for timer recording
#*************************************************************************************************
#
proc getTrecfil { } {
    global trecfil xtid6a xtid6c ms104
    set dir0 [file dirname $trecfil] ;#  make sure that directory exists
    if {![file isdirectory $dir0 ]} { catch [exec mkdir -p $dir0 ] }
    set fil [tk_getSaveFile \
               -initialdir $dir0 -title $ms104 -defaultextension .ts -parent .rec]
    if { $fil == ""} { return }
    set trecfil $fil ; saveConfig ;#  save trecfil
    set xtid6a [file tail $trecfil] ; set xtid6c [file dirname $trecfil]
  } ;# end proc.getTrecfil

#*************************************************************************************************
#  Proc. timerAutoname generates an automatic file name for timer record file
#*************************************************************************************************
#
proc timerAutoname { } {
    global wtid autoname taunam xtid6a ms110 trecfil
#  read parameters from dialog window: date, start+stop time, channel
    update
    if { !$taunam } { set xtid6a [file tail $trecfil] } else { ;# auto-name enabled
     set nac [ [lindex $wtid 1] get -clicks] ; set ati [ [lindex $wtid 2] get -clicks]
     set chn [ [lindex $wtid 4] get ]        ; set fil $trecfil
     make-autoname $fil $chn $nac $ati ; set xtid6a "$ms110 '[lindex $autoname 2]'"}
  } ;# end proc.timerAutoname

#*************************************************************************************************
#  Proc. make-autoname {dir0 chan dat tim} generates an automatic record file name
#*************************************************************************************************
# chan = channel name; dat = clicks for date; tim = clicks for start time (time-of-day)
# chan is truncated and modified to form a legal file name (no Umlaut, no 1st digit)
proc make-autoname { fil chan dat tim } {
    global autoname trecfil
    set dir0 [ file dirname $fil ] ;# if no directory given: take it from trecfil
    if { $dir0 == "." } { set dir0 [ file dirname $trecfil ] }
#  clean the channel name, truncate to 10 chars
    set nam0 [string trim [string tolower $chan ] "\{\} _><|@#\[\]" ]
    set lnam0 [string length $nam0]
    if { $lnam0 > 10 } { set nam0  [string range $nam0 0 9] ; set lnam0 10 }
    set nam1 "" ; set ci 0 ; set char [string index $nam0 $ci] ; scan $char %c i
    if { ($i >= 48) && ($i <= 57) } { set nam1 "s" } ;# name starts with digit: add 's'
    if {  $i == 91 } { set nam1 "s" }  ;# name in []: add 's'
    while { $ci < $lnam0 } {
      set char [string index $nam0 $ci] ; scan $char %c i ; incr ci ;#remove Umlauts:
      switch  $i  { 91  { }        93  { }                  223 { append nam1 "ss" }
         32 { append nam1 "-"  }  228 { append nam1 "ae" }  246 { append nam1 "oe" }
	252 { append nam1 "ue" }  196 { append nam1 "ae" }  214 { append nam1 "oe" }
	220 { append nam1 "ue" }  default { append nam1 $char }  } ;# end switch
    } ;# end while : remove Umlauts
    set nam2 [clock format $dat -format "%y%m%d"]
    set nam3 [clock format $tim -format "%H%M%S"]
    set nam4 [clock format $tim -format "%H%M"]   ; set tinam "$nam1-$nam2-$nam4.ts"
    set autoname [ list $dir0/$nam1-$nam2-$nam3.ts $dir0/$tinam $tinam $nam1 ]
  } ;# end proc.make-autoname
#
#*************************************************************************************************
#  Proc.timerStore saves the record parameters in files anfX, endX, jobfile, count
#*************************************************************************************************
#
proc timerStore { } {
    global wtid recser retval timdir jobfile taunam autoname xtid2 trecfil dohalt
    global tan zap ad modflag ms73 ms111 ms112 ms113 ms114
    global ms336 ms337 ms338 ms339 ms340 ms341 ms342 ms335
    set pr "timerStore"
#  read parameters from dialog window: date, start+stop time, channel
#  conventiones: n = new entry; d = day (1..7 or yy-mm-dd), t = time (hh:mm)
#  a = begin of recording ('Anfang'), e = end of recording; e.g: nad = new begin date
    set nad   [ [lindex $wtid 1] get ]         ;# start date (yyyy-mm-dd)
    set nadic [ [lindex $wtid 1] get -clicks]  ;# start date (clicks)
    set natic [ [lindex $wtid 2] get -clicks ] ;# start time (clicks)
    set netic [ [lindex $wtid 3] get -clicks ] ;# end   time (clicks)
    set nat [clock format $natic -format %H:%M]
    set net [clock format $netic -format %H:%M]
    set chn [ [lindex $wtid 4] get ] ; set fil trecfil ;# chan + file
    set jol [lindex $wtid 5] ;# window of joblist
    make-autoname $fil $chn $nadic $natic ; set nam1 [lindex $autoname 3] ;#clean name
    set liste [aLif] ;# list names: base,work,favo1,favo2
#
# check if parameters ok: check if cron or at programs available
    if {$recser} {if {[catch {exec which crontab}]} {Err b8 $ms111 ; return }
    }     else   {if {[catch {exec which at}]     } {Err b9 $ms112 ; return } }
    if {[string length $chn] < 1} { Err b1 $ms73 ; return} ;# nothing selected
    set dir0 [ file dirname $fil ] ;# if no directory given: take it from trecfil
    if { $dir0 == "." } { set dir0 [ file dirname $trecfil ] }
#
#  define date for begin+end of recording:
    set nac0 [clock scan $nat -base $nadic] ; set nec0 [clock scan $net -base $nadic]
    if { $nac0 == $nec0 } { Err  b7 $ms114 ; return } ;# end time = begin time
    if { $recser } { set nad $retval } ;# serial rec: '*' or day codes for cron
#
    set ned $nad ;# end date = begin date
    if { $nac0  > $nec0 } { ;# end time before begin: assume next day
      if { !$recser } { ;# single recording with 'at':
        set ned [clock format [clock scan "1 day" -base $nac0 ] -format %Y-%m-%d]
      } else { ;# serial rec: end on 'next day'; e.g. "1,4,7" -> "2,5,1"
        if { $ned != "*" } { set ned0 [split $ned , ] ; set ned1 ""
	  foreach x $ned0 { if { $x < 7 } { lappend ned1 [expr $x + 1] } else {
	  lappend ned1 1 } } ; regsub -all " " $ned1 , ned } } ;# end if recser
    } ;# if begin > end time
#
#  check if new record times overlap with any record times stored in file 'jobfile'
    set ovlap [ checkOverlap $nad $ned $nat $net ] ; if { $ovlap } { return }
#
#  increment job counter in file $timdir/count, create the file if not yet existing:
    if {![file exists $timdir/count] } { exec echo "0" > $timdir/count } ;# init file
    set jon [gets [open $timdir/count]] ; set jon [expr $jon + 1]  ;# next job
    catch { set fid [open $timdir/count w+] ; puts $fid $jon ; close $fid }
#
#  prepare the batch file for at or crontab:  define start time of recording
    set OUT [open $timdir/anf.$jon w+]
#  load kernel modules (obsolete...)
    if { $modflag == 1 } {       puts $OUT {sudo /sbin/modprobe dvb-bt8xx}
                                 puts $OUT {sudo /sbin/modprobe cx24110}
    } elseif { $modflag == 2 } { puts $OUT {sudo /sbin/modprobe dvb-bt8xx}
                                 puts $OUT {sudo /sbin/modprobe dst } } ;# end if..
#  tune to channel
    puts $OUT "$zap -a$ad -c $liste -r \"$chn\" &"
    puts $OUT "echo $jon > $timdir/lock" ; puts $OUT "/bin/sleep 1"
#
#  initiate recording: trecfil or 'auto-name'
    if { !$taunam } { puts $OUT "exec cat /dev/dvb/adapter$ad/dvr0 >> $trecfil"
    } else {          puts $OUT "exec cat /dev/dvb/adapter$ad/dvr0 >> \
                        [file dirname $trecfil]/$nam1-\$(date \"+%y%m%d-%H%M\").ts" }
    close $OUT ;# start file ready
#
#  start 'at' oder 'cron' job for job file '$timdir/anf.$jon'
    if { !$recser } { catch { exec at -f $timdir/anf.$jon \
			             [clock format $natic -format %H:%M] $nad } ATOUT
      set JOB [exec echo $ATOUT | sed /job/!d | cut -d " " -f 1,2] ; set DATE $nad
    } else {  set CRONINP [open $timdir/crontab a]
      if { [catch {exec crontab -l}] } {  set JOB "job S1"
      } else { set CRONCOUNT [exec crontab -l | sed /^#/d | wc -l]
	                                    set JOB "job S[expr $CRONCOUNT + 1]"  }
#  delete leading zeroes
      set CRONANFM [string trimleft [clock format $natic -format %M] 0]
      set CRONANFH [string trimleft [clock format $natic -format %H] 0]
#  if string empty: set to zero
      if { ![string is digit -strict $CRONANFM]} { set CRONANFM "0" }
      if { ![string is digit -strict $CRONANFH]} { set CRONANFH "0" }
#  make cron input file
      puts $CRONINP "$CRONANFM $CRONANFH * * $nad /bin/sh $timdir/anf.$jon"
      close $CRONINP ;# catch [exec crontab $timdir/crontab] ;# add crontab entry
    } ;# if ('at' or 'cron')
    set jobs "(job[string range $JOB 4 end])" ;# convert 'job xy' -> '(jobxy)'
#
#  define end of recording: create job file '$timdir/end.$jon'
    set OUT1 [open $timdir/end.$jon w]
    puts $OUT1 "#terminates $jobs"
    puts $OUT1 {}
    puts $OUT1 "for prg in cat $zap; do"
    puts $OUT1 {    killall $prg}
    puts $OUT1 {    sleep 1}
    puts $OUT1 {    PID=`ps ax | sed -e '/$prg/!d' -e '/sed/d' | cut -d " " -f 1`}
    puts $OUT1 {    let COUNT=0}
    puts $OUT1 {    while [ -n "$PID" ]; do}
    puts $OUT1 {            killall -9 $PID}
    puts $OUT1 {            sleep 1}
    puts $OUT1 {            let COUNT++}
    puts $OUT1 {            if [ $COUNT > 10 ]; then}
    puts $OUT1 {                    exit 1;}
    puts $OUT1 {            fi;}
    puts $OUT1 {    done;}
    puts $OUT1 {done}
#
#  if single recording: delete job files $timdir/anf.xx + $timdir/end.xx
    if { !$recser } {
      puts $OUT1 "grep -v \"$jobs\" $jobfile > $timdir/joblist.tmp"
      puts $OUT1 "mv -f $timdir/joblist.tmp $jobfile"
      puts $OUT1 "rm $timdir/anf.$jon"
      puts $OUT1 "rm $timdir/end.$jon"
    }
    puts $OUT1 "rm $timdir/lock"
    if { $dohalt } { puts $OUT1 "sudo /sbin/shutdown -h +1 &" } ;  close $OUT1
#
#  start the 'at' or 'cron' job to terminate recording
    if { !$recser } { catch { exec at -f $timdir/end.$jon \
		[clock format $netic -format %H:%M] $ned } ATOUT1 ;# single recording
    } else { ;#  ...else serial recording: start the 'cron' job
      set CRONINP [open $timdir/crontab a]
      set CRONENDM [string trimleft [clock format $netic -format %M] 0]
      set CRONENDH [string trimleft [clock format $netic -format %H] 0]
      if { ![string is digit -strict $CRONENDM]} { set CRONENDM "0" }
      if { ![string is digit -strict $CRONENDH]} { set CRONENDH "0" }
      puts $CRONINP "$CRONENDM $CRONENDH * * $ned /bin/sh $timdir/end.$jon"
      close $CRONINP ; catch [exec crontab $timdir/crontab]
    } ;# if at or cron job
#
#  store job parameters in joblist; see proc.showJoblist for description
    if { $recser } { set dnam $xtid2 } else { set dnam $nad } ;# date name
    regsub -all " " $chn _ cnam  ;# channel name: replace spaces by '_'
    if { [string length $cnam ] > 16 } { set cnam [string range $cnam 0 15] }
    if { $taunam } { set fina "(auto)" } else { set fina [file tail $trecfil] }
    if { $dohalt } { set hasi "H" } else { set hasi "" }
    set jolin "$dnam $nat $net $hasi $cnam $fina $jobs $jon $nad $ned $trecfil"
    if { ![catch { open $jobfile a } fid ] } { puts $fid $jolin ; close $fid }
    showJoblist ;# show the list
  } ;# end proc. timerStore
#
#*************************************************************************************************
#  proc checkOverlap does the overlap check for new entries in the joblist
#*************************************************************************************************
#
proc checkOverlap { nad ned nat net } {
#  proc.checkOverlap checks for time overlaps between new entries and the joblist.
#  The begin and end dates (nad+ned) can be given as 'date' (2005-12-24) or as
#  'day numbers', 1,2,..,7 = Monday,..,Sunday. Day numbers can be a single nbr,
#  or a list of numbers separated by commas (1,3,7), or '*'=dayly.
#  The procedure forms a set of parameters for each combination; conventions:
#  1st char: n = new entry, s = stored value in joblist;
#  2nd char: a = Begin of recording ('Anfang'), e = end of recording;
#  3rd char: t=time (hh:mm); d=day (2005-12-24); c=ticks; n=dayNbr (1..7); q=queue (1,3)
#  e.g. san = stored begin day nbr (1..7); saq = "1,3,6" (queue with commas).
#  see proc.showJoblist for description of the joblist lines
    global recser jobfile ms114
    set alldays1 { 1 2 3 4 5 6 7 } ; set alldays2 { 2 3 4 5 6 7 8 }
    set bs [clock scan "2005-07-10"] ;# default base for calculations
    if { $recser } { ;# new serial recording
      regsub -all , $nad " " nal ; if {$nal == "*" } { set nal $alldays1 }
      regsub -all , $ned " " nel ; if {$nel == "*" } { set nel $alldays1 }
      set nac0 [clock scan $nat -base $bs] ; set nec0 [clock scan $net -base $bs]
      if { $nac0 > $nec0 } { ;# end time on next day: special for Monday
      if { $nel == "*" } { set nel $alldays2 } else { regsub -all "1" $nel 8 nel } }
    } else { ;# new single recording: convert to clicks, prepare the lists
      set nac [clock scan $nat -base [clock scan $nad]]  ;# new start time: clicks
      set nec [clock scan $net -base [clock scan $ned]]  ;# new end time: clicks
      set nal [clock format $nac -format %u] ;# convert the start date to weekday nbr.
      set nel [clock format $nec -format %u] ;# convert the start date to weekday nbr.
    } ;# if recser
#puts "§\n***checkOverlap*** recser = *$recser*"
#puts "§ov1018; nad,ned,nat,net = *$nad*$ned*$nat*$net*"
#puts "§ov1019; nal,nel = *$nal*$nel*"
#
    set e1 [catch { open $jobfile } fid] ; if { $e1 } {return 0} ;# no jobfile: ignore
    while { ![eof $fid] } { ;# for each line do ...
      catch { gets $fid } curl ; if { ![string length $curl] } {continue} ;# line empty
      regsub -all "  " $curl " x " culi ;# if haltflag blank: replace by 'x'
      set curm "[lindex $culi 0]  [lindex $culi 1]  [lindex $culi 2]"
      set sad [string trim [lindex $culi 8]] ;# day code (1,2,..7, or *)
      set sed [string trim [lindex $culi 9]]
#puts "§ov1002; sad,sed = §$sad§§$sed§"
      set sat [lindex $culi 1] ; set set [lindex $culi 2] ;# times: hh:mm
      set single [string match 20\[0-9\]\[0-9\]-\[0-9\]\[0-9\]-\[0-9\]\[0-9\] $sad ]
# if both items are single recordings: convert to clock ticks + compare
      if { !$recser && $single } { ;# old single + new single
        set sac [clock scan $sat -base [clock scan $sad]]  ;# stored start time: clicks
	set sec [clock scan $set -base [clock scan $sed]]  ;# stored end time: clicks
	set ovlap [expr ($nac <= $sec && $nec >= $sac)||($nec >= $sac && $nac <= $sec)]
	if { $ovlap } { Err  b13 "$ms114\n$curm" ; return 1 } ; continue ;# next line
      } else { ;#  at least one of them is serial
#  generate a 'day list' for both items: convert days to week-days (1..7)
        if { !$single } { ;#  old serial + new serial
#puts "§ov1041; old serial + new serial"
          regsub -all , $sad " " saq ; if {$saq == "*" } { set saq $alldays1 }
          regsub -all , $sed " " seq ;# regsub -all 1 $sed 8 seq
          if {$seq == "*" } {
            set sac0 [clock scan $sat -base $bs] ; set sec0 [clock scan $set -base $bs]
            if { $sac0 < $sec0 } { set seq $alldays1 } else { set seq $alldays2 } }
#puts "§ov1046; sad,sat,saq = *$sad*$sat*$saq*"
#puts "§ov1047; sed,set,seq = *$sed*$set*$seq*"
        } else { ;# old single + new serial: convert to clicks, prepare the lists
#puts "§ov1049; old serial + new single"
          set sac [clock scan $sat -base [clock scan $sad]]  ;# new start time: clicks
          set sec [clock scan $set -base [clock scan $sed]]  ;# new end time: clicks
          set saq [clock format $sac -format %u] ;# convert start date to weekday nbr.
          set seq [clock format $sec -format %u] ;# convert start date to weekday nbr.
#puts "§ov1054; sad,sat,sac,saq = *$sad*$sat*$sac*$saq*"
#puts "§ov1055; sed,set,sec,seq = *$sed*$set*$sec*$seq*"
	} ;# if single or serial
	set nj 0 ;# go to read the weekday in both lists
	foreach naday $nal { set neday [lindex $nel $nj] ; incr nj ; set sj 0
	  set na [clock scan  "$naday days $nat" -base $bs]
          set ne [clock scan  "$neday days $net" -base $bs]
	  foreach saday $saq { set seday [lindex $seq $sj] ; incr sj
#puts "§ov1062; naday,neday,saday,seday,nj,sj=*$naday*$neday*$saday*$seday**$nj*$sj*"
#puts "§ov1063; na,ne = *$na*$ne*"
#set nax [clock format $na -format "%y-%m-%d, %H:%M; %u"] ; puts "nax = *$nax*"
#set nex [clock format $ne -format "%y-%m-%d, %H:%M; %u"] ; puts "nex = *$nex*"
	    set sa [clock scan  "$saday days $sat" -base $bs]
            set se [clock scan  "$seday days $set" -base $bs]
#puts "§ov1068; sa,se = *$sa*$se*"
#set sax [clock format $sa -format "%y-%m-%d, %H:%M; %u"] ; puts "sax = *$sax*"
#set sex [clock format $sa -format "%y-%m-%d, %H:%M; %u"] ; puts "sex = *$sex*"
	    set ovlap [expr ($na <= $se && $ne >= $sa)||($ne >= $sa && $na <= $se)]
#set b1 [expr ($na <= $se && $ne >= $sa)] ; set b2 [expr ($ne >= $sa && $na <= $se)]
#puts "§ov1073; ovlap,b1,b2 = *$ovlap**$b1*$b2*"
	    if { $ovlap } { Err  b14 "$ms115\n$curm" ; return 1 }
          } ;# foreach saday
        } ;# foreach naday
      } ;# if serial or single recording
    } ;  catch {close $fid } ;# end while reading jobfile
  } ;# end proc.checkOverlap
#
#*************************************************************************************************
#  proc. timerDel { } deletes the selected entry in the timer list
#*************************************************************************************************
#
proc timerDel { } {
    global wtid jobfile timdir ms115 ms116 ms134
#
    set jol [lindex $wtid 5]
    set e1 [catch { $jol get "insert linestart" "insert lineend" } selin ]
    if { $e1 || ![string length $selin] } { Err  b1 $ms134 ; return } ;# no selection
    catch { $jol configure -state normal } ; $jol tag remove "linsel" 1.0 end
    $jol delete "insert linestart" "insert lineend + 1 char" ; update
    catch { $jol configure -state disabled }
#  write new jobfile: sected line removed, tabs replaced by spaces
    set e11 [catch {open $jobfile w } fid] ; if {$e11} { Err  b11 $fid ; return }
    regsub -all \t [$jol get 1.0 end] " " joli ;# replace tabs by spaces
    catch { puts -nonewline $fid $joli } ; catch { close $fid }
#
#  delete the stored jobs (at or crontab)
    set selis [ split $selin \t ] ; set date [string trim [lindex $selis 0]]
    set job [string trim [lindex $selis 6] job()] ; set jon [string trim [lindex $selis 7]]
    set single [string match 20\[0-9\]\[0-9\]-\[0-9\]\[0-9\]-\[0-9\]\[0-9\] $date]
    if { $single } {  ;# single rec: delete at job files
      catch { exec atrm $job } ; catch { exec atrm [expr $job + 1] }
    } else { ;# serial recording: delete cron lines with 'anf.$jon + end.$jon'
      set e3 [catch {exec cat $timdir/crontab | sed /$jon$/d } row ] ;# delete lines
      if { !$e3 } {  exec echo $row | sed /^$/d > $timdir/crontab
        set ccnt [exec wc -l $timdir/crontab | cut -d " " -f 1]
        if {$ccnt < 2} { catch { exec crontab -r }; catch { exec rm $timdir/crontab }
        }   else       { catch { exec crontab $timdir/crontab } } ;# save new crontab
      } ;# if crontab found
    } ;# end if single or serial recording
#  delete the anf/end files
    catch { exec rm $timdir/anf.$jon } ; catch { exec rm $timdir/end.$jon }
#  if no more at+cron jobs: reset job counter
    set ccnt 0 ; catch { set ccnt [exec wc -l $timdir/crontab | cut -d " " -f 1] }
    set jcnt 0 ; catch { set jcnt [string length [exec atq] ] }
    if { !$ccnt || !$jcnt } { catch { exec rm $timdir/count } } ;# delete counter file
  } ;# end proc. timerDel
#
#*************************************************************************************************
#  Proc.manRecord: enter parameters for manual recording
#*************************************************************************************************
#
proc manRecord { } {
    global mrecfil maunam xmar1 xmar2 ms70  ms127 ms267 ms460
    global ms128 ms129 ms130 ms131 ms132
#
    set wmar .wmar ; if { [winfo exists $wmar] } { return }   ; toplevel $wmar
    wm title $wmar $ms128 ;  wm geometry $wmar -20-300
#
#  'Datei': record file name
    set xmar1 [file tail $mrecfil] ; set xmar2 [file dirname $mrecfil]
    set wmar1 $wmar.a ; labelframe $wmar1
    set wmar1a $wmar1.a ; frame $wmar1a
    label $wmar1a.m1 -text $ms127 -width 18 -anchor e
    label $wmar1a.m2 -textvariable xmar1 -width 35 -anchor w
    pack $wmar1a.m1 $wmar1a.m2 -side left
#  directory
    set wmar1c $wmar1.c ; frame $wmar1c
    label $wmar1c.m1 -text $ms460 -width 18 -anchor e
    label $wmar1c.m2 -textvariable xmar2 -width 35 -anchor w
    pack $wmar1c.m1 $wmar1c.m2  -side left
    pack  $wmar1a $wmar1c
#  append or overwrite: maunam: 0=autoName, 1=anfuegen, 2=immer neu schreiben
    set wmar2 $wmar.b ; frame $wmar2
    set wmar2a $wmar2.a ; labelframe $wmar2a -text $ms129
    radiobutton $wmar2a.b1 -anchor w -variable maunam -value 2 -text $ms130
    radiobutton $wmar2a.b2 -anchor w -variable maunam -value 1 -text $ms131
    radiobutton $wmar2a.b3 -anchor w -variable maunam -value 0 -text $ms132
    pack $wmar2a.b1 $wmar2a.b2 $wmar2a.b3 -anchor w
    set wmar2b $wmar2.b ; labelframe $wmar2b
    button $wmar2b.b1 -text $ms267 -width 9 -command "getMrecfil"
    pack  $wmar2b.b1 -padx 2 -pady 2
    pack $wmar2b -side right -anchor e
    pack $wmar2a -side right -padx 60 -anchor w
#  System button: return
    set wmar3 $wmar.c ; labelframe $wmar3
    button $wmar3.b1 -text $ms70 -width 9 -command "destroy .wmar"
    pack $wmar3.b1 -padx 2 -pady 2
    pack $wmar3 -side bottom -anchor e -pady 8 -padx 4
    pack $wmar2 -side bottom -anchor e -expand 1 -fill x -pady 8 -padx 4
    pack $wmar1 -side bottom -pady 8 -padx 4
  }  ;# end proc. manRecord
#
#*************************************************************************************************
#  Proc. getMrecfil gets the record file path + name for manual recording
#*************************************************************************************************
proc getMrecfil {} {
    global mrecfil  xmar1 xmar2 ms104
    set dir0 [file dirname $mrecfil]
    if { ![file isdirectory $dir0 ] } { catch [exec mkdir -p $dir0 ] }
    set fil [tk_getSaveFile \
          -initialdir $dir0 -title $ms104 -defaultextension .ts  -parent .wmar ]
    if { $fil == "" } { return }
    set mrecfil $fil ; saveConfig  ;#  mrecfil abspeichern
    set xmar1 [file tail $mrecfil] ; set xmar2 [file dirname $mrecfil]
  } ;# end proc.getMrecfil
#
#*************************************************************************************************
#     Prozedur quit {}  schliesst das Fenster     (quit version thomas 14.12.04)
#*************************************************************************************************
#
proc quit {} {
    global receivertyp home dtec ms136
#
    if {[file exists $dtec/timer/lock]} {
      set CURREC [gets [open $dtec/timer/lock]]
      set INTR [tk_messageBox -type yesno -message $ms136 ]
      if {[string match "yes" $INTR]} {
	set selin [gets [open $dtec/timer/end.$CURREC]]
	set job [string range $selin [expr [string last job $selin] +4] end]
	catch {exec atrm $job} ; exec atrm [expr $job +1] ; exec sh $dtec/timer/end.$CURREC
      } ;# end if string match
    } else {  view-off  } ;# end if file exists
#  Soft-Link zur channels.conf loeschen: nur bei MPlayer evtl. noetig
    if {$receivertyp == "mplayer"} then { catch {exec rm $home/.mplayer/channels.conf} }
    saveConfig  ;  destroy .  ;#  destroy main window
  } ;# end proc. quit
#
#
#*************************************************************************************************
#     Prozedur vtext Startet den videotextbildschirm
#*************************************************************************************************

proc vtext {} {
    global tab tan zap dtec vtflag allVtext ispath ad ms73
    global offbut cbut1 offcolor bgcolor xbut13 ms5
#
    set liste [aLif]  ;#     aktuelle Senderliste anwaehlen
    if [catch {set chan [ $tab get [ $tab curselection ]]}] {
        tk_messageBox -type ok -message $ms73 ; return
    } ;# end if chan OK
#
    set vtprog  [lindex $allVtext $vtflag ]
    catch { exec which $vtprog } vtpath  ;# get full path for alevt or mtt4
    file delete $dtec/alevt.out
    #  start $zap, if not yet running
    if { ![catch { exec ps fax | grep $zap | sed /grep/d}]} {
      exec $zap -a$ad -c /$liste -r $chan -x &  ;# call $zap and exit after tuning
    } ;#  end if szap not yet running
#
#  call videotext program:  alevt or mtt4
#
    switch $vtflag {
      0 { set alout [ exec $vtpath -vbi /dev/dvb/adapter$ad/demux0 \
                         -outfile $dtec/alevt.out  -parent 100 & ]
	  set tc 0
	  while { 1 } {
            if { [file exists $dtec/alevt.out] }  {
              vtextsel $vtpath  ; break
	    } else {
	      incr tc ; if { $tc > 300000 } { break }
            } ;# end if
	  } ;# end while waiting for file alevt.out
          }
      1 { set er1 [ catch { exec $vtpath & } res1 ]  ;# end switch 1
          }
      2 { set er2 [ catch { exec $vtpath & } res2 ]  ;# end switch 2
          } ;# end switch vtflag
      }
    if { $offbut } { $cbut1.b3 configure -bg $offcolor
    } else { $cbut1.b3 configure -bg $bgcolor } ;  set xbut13 $ms5
  } ;# end proc. vtext
#
#*************************************************************************************************
#  proc vtextsel {} bietet die Auswahl unter den Sendern in einem Transponder
#*************************************************************************************************

proc vtextsel { vtpath } {
    global dtec ms139 ms140 ms141
#
    if { [winfo exists .alevt-dvb ] } { destroy .alevt-dvb }
    toplevel .alevt-dvb
#
    if {[catch {open $dtec/alevt.out} inf]} { return } ;# cannot open alevt.out
#
    set cnames "" ; set cpids "" ; set clines "" ; set lnbr 0
    while {1} {
      gets $inf curl0
      if { [eof $inf] != 0 } { break }
      set ci 0 ; set clen [string length $curl0] ; set curl  ""
      while { $ci < $clen } {
        set char [string index $curl0 $ci] ; scan $char %c i  ;# get next char
	if { $i >= 32 } {
	  if { $i != 134 } {
	    if { $i != 135 } { append curl $char }            ;# remove ctrl-char
        } } ;# end if valid char
        incr ci
      } ;# end while more chars in line
      set sep1   [expr [ string first "Sender:" $curl ] - 1]
      set sep3   [expr [ string first "PID:"    $curl ] - 1]
      set cprov  [string trim [string range $curl  0    $sep1]]
      set cname  [string trim [string range $curl [expr $sep1 + 8] [expr $sep3]]]
      set cpid   [string trim [string range $curl [expr $sep3 + 5]  end ]]
      lappend cnames $cname  ;# list of names
      lappend cpids  $cpid   ;# list of PIDs
     incr lnbr ;# incr line number
    } ;# end while
    close $inf
    if { $cnames == "" } { return } ;# file alevt.out is empty
#
    iwidgets::scrolledlistbox .alevt-dvb.slb -selectmode multiple -vscrollmode dynamic\
        -hscrollmode none -labeltext  "$cprov\n$ms139\n$ms140\n$ms141" \
        -selectioncommand "vtextselChan  {$cpids} $vtpath"
    pack .alevt-dvb.slb -padx 10 -pady 12 -fill both -expand yes
    foreach nam $cnames { .alevt-dvb.slb insert end $nam }
  } ;# end proc.vtextsel
#
#   Proc.vtextselChan ruft alevt auf mit der pid des angewaehlten Senders
#
proc vtextselChan { cpids vtpath } {
    global dtec ad
#
    set curlin [ .alevt-dvb.slb curselection ]
    .alevt-dvb.slb selection clear 0 [.alevt-dvb.slb size ]
    set curpid [ lindex $cpids $curlin ]
    exec $vtpath -vbi /dev/dvb/adapter$ad/demux0 -pid $curpid -parent 100 &
  } ;# end proc. vtextselChan
#
#   Proc.vtext-off schaltet Videotext aus
#
proc vtext-off { } {
    global allVtext cbut1 bgcolor xbut13 ms3
    $cbut1.b3 configure -bg $bgcolor  ;  set xbut13 $ms3
    if { [winfo exists .alevt-dvb ] } { destroy .alevt-dvb }
    foreach {prg}  $allVtext { catch {exec killall -9 $prg } }
  } ;# end proc. vtext-off
#
#*************************************************************************************************
#  proc epg-on starts the epg program dvbrowser
#*************************************************************************************************

proc epg-on {} {
    global xbut12 tab tan sel zap ad epgpath offbut cbut1 offcolor bgcolor ms186
#
    set liste [aLif]  ;#     aktuelle Senderliste anwaehlen
    if [catch { set chan [ $tab get [ $tab curselection ]] } ] {
        $tab selection set $sel($tan) } ;# make sure something is selected
    #  start $zap, if not yet running
    if { ![catch { exec ps fax | grep $zap | sed /grep/d} ] } {
      exec $zap -a$ad -c /$liste -r $chan -x & ;# call $zap and exit after tuning
      exec sleep 2
    } ;#  end if szap not yet running
    set er3 [ catch { exec $epgpath & } res3 ] ;# exec $epgpath & ;# start dvbrowse
#
    if { $offbut } { $cbut1.b2 configure -bg $offcolor
    } else { $cbut1.b2 configure -bg $bgcolor } ;  set xbut12 $ms186
  } ;# end proc epg-on
#
#   Proc epg-off turns the epg program dvbrowser off
#
proc epg-off { } {
    global cbut1 bgcolor xbut12 ms185
    $cbut1.b2 configure -bg $bgcolor  ;  set xbut12 $ms185
    catch { exec killall -9 dvbrowse }
  } ;# end proc egp-off
#
#*************************************************************************************************
#  Proc. sel-up {} scrols one line up in the table
#*************************************************************************************************
#
proc sel-up {} {
    global tab tan sel
    if { $sel($tan) == 0 } { return } ;# first line: ignore
    incr sel($tan) -1 ; updateTable
  } ;# end proc. sel-up
#
#*************************************************************************************************
#  Proc. sel-down {} scrols one line down in the table
#*************************************************************************************************
#
proc sel-down {} {
    global tab tan sel
    if { [expr $sel($tan) + 1] >= [$tab size]} { return } ;# end-of-table
    incr sel($tan) ; updateTable
  } ;# end proc. sel-down
#
#*************************************************************************************************
#  Proc. move-up {} moves a channel one line up in the list
#*************************************************************************************************
#
proc move-up {} {
    global tab tan sel
    if {$sel($tan) == 0} { return } ;# first line: ignore
    set dest [aLif]        ;# Senderliste: blist, wlist, favo1, favo2
    set CUR [exec sed -n [expr $sel($tan) +1]p $dest]
    set PRV [exec sed -n [expr $sel($tan)]p $dest]
    exec sed "[expr $sel($tan) +1]c $PRV" $dest | sed "[expr $sel($tan)]c $CUR" > $dest.tmp
    exec mv $dest.tmp $dest
    set sel($tan) [expr $sel($tan) - 1 ] ; updateTable ; getTitles $tan
  } ;# end proc. move-up
#
#*************************************************************************************************
#  Proc. move-down {} moves a channel one line down in the list
#*************************************************************************************************
#
proc move-down {} {
    global tab tan sel
#
    set curln [expr $sel($tan) +1] ; set nxtln [expr $sel($tan) +2] ; set dest [aLif]
    if { $curln >= [$tab size] } { return } ;# last line: ignore
    set CUR [exec sed -n ${curln}p $dest] ; set NXT [exec sed -n ${nxtln}p $dest]
    exec sed "${curln}c $NXT"  $dest | sed "${nxtln}c $CUR" > $dest.tmp
    if { [ catch { exec mv -f $dest.tmp $dest } rep ] } { Err 1321 $rep ; return }
    set sel($tan) $curln ; updateTable ; getTitles $tan
  } ;# end proc. move-down
#
#*************************************************************************************************
#  Proc. insFav { tan0 dest } adds the selected channel to the file $dest (favo1,2 or ftemp)
#*************************************************************************************************
#
proc insFav { tan0 dest } {
    global tab tan sel aconf fav5 offcolor ms133
#
    set chan [$tab get $sel($tan)] ;# selected chan.name
    set alif [aLif] ; if { [catch { open $alif } inf ] } { Err 1352 $inf ; return }
    while { ![eof $inf] } { if { [ catch { gets $inf } curl ] } { Err 1355 $inf ; return }
      if { ![string first $chan $curl] } {
        if { [catch { open $dest a } otf] } { Err 1320 $otf; return }
        catch { puts $otf $curl } ; catch { close $otf }
        if { $aconf } { tk_messageBox -message "$chan $ms133 [file tail $dest]." ; break } } }
    catch { close $inf } ; getTitles $tan0 ; $fav5.b8 configure -bg $offcolor
  } ;# end proc. insFav
#
#*************************************************************************************************
#  Proc. insTemp {} inserts the temp.file into the channel list: blist,wlist,favo1,favo2
#*************************************************************************************************
#
proc insTemp {} {
    global tan sel ftemp dtec
#
    set breakpt $sel($tan) ; set lc 0 ;# break point: location where to insert the scratchpad
    set alif [aLif] ; if { [catch { open $alif } inf ] } { Err 1338 $inf ; return }
    set tempfil $dtec/tempfil ; if { [catch { open $tempfil w } fot ] } { Err 1339 $fot ; return }
    if { [catch { open $ftemp } tmp ] } { Err 1340 $tmp ; return }
    while { $lc < $breakpt } { if { [ catch { gets $inf curl } er ] } { Err 1341 $er ; return }
      if { [string length $curl] } {
                     if { [ catch { puts $fot $curl } er ] } { Err 1342 $er ; return } ; incr lc } }
    while { ![eof $tmp] } { if { [ catch { gets $tmp curl } er ] } { Err 1343 $er ; return }
      if { [string length $curl] } {
                     if { [ catch { puts $fot $curl } er ] } { Err 1344 $er ; return } } }
    while { ![eof $inf] } { if { [ catch { gets $inf curl } er ] } { Err 1345 $er ; return }
      if { [string length $curl] } {
                     if { [ catch { puts $fot $curl } er ] } { Err 1346 $er ; return } } }
    catch { close $inf } ; catch { close $fot } ; catch { close $tmp }
    if { [catch { exec mv -f $tempfil $alif } res] } { Err 1350 $res } ;# store new clist
    updateTable ; getTitles $tan
  } ;# end proc. insTemp
#
#*************************************************************************************************
#  Proc. delChan {} deletes a channel item from the list: blist,wlist,favo1,favo2
#*************************************************************************************************
#
proc delChan {} {
    global tan tab sel dtec
#
    set clist [aLif] ;# channel file = blist, wlist, favo1, favo2
    if { [catch { open $clist } inf ]} { Err 1352 $inf ; return } ;# open clist, if possible
    set tempfil $dtec/tempfile.tmp ; set temp [ open $tempfil w ] ; set ln 0 ;# temp.outfile
    while { ![eof $inf] } { gets $inf curl; if { $ln != $sel($tan) } { puts $temp $curl } ; incr ln }
    catch { close $inf } ;  catch { close $temp }
    if { [catch { exec mv -f $tempfil $clist } res] } { Err 1372 $res } ;# store new clist
    updateTable ; getTitles $tan
} ;# end proc. delChan
#
#*************************************************************************************************
#  Proc. cutChan {} adds the selected channel to the file $ftemp and deletes ist on the act.file
#*************************************************************************************************
#
proc cutChan {} {
    global ftemp adel fav5 offcolor
    if { $adel } { delTemp } ; insFav 0 $ftemp ; delChan ; $fav5.b8 configure -bg $offcolor
  } ;# end proc. cutChan
#
#*************************************************************************************************
#  Proc. delTemp { } clears the file $ftemp
#*************************************************************************************************
#
proc delTemp { } {
    global ftemp tan fav5 bgcolor
    if { [ catch { exec rm -f $ftemp } res] } { Err 1386 $res } ; catch { exec touch $ftemp }
    $fav5.b8 configure -bg $bgcolor
  } ;# end proc. delTemp
#
#*************************************************************************************************
#  Proc. showBlink { wb per } blinks with a button; wb = button, per = msecs
#*************************************************************************************************
#
proc showBlink { wb per } {
    global ftemp tan offcolor bgcolor
    if { $per } { $wb configure -bg $offcolor ; after $per "showBlink $wb 0"
    }  else     { $wb configure -bg $bgcolor }
  } ;# end proc. showBlink
#
#*************************************************************************************************
#  Proc. updateTable {} updates the channel table for $tan: blist,wlist,favo1,2,titles($tan)
#*************************************************************************************************
#
proc updateTable {} {
    global tan tab sel titles mara mahot ms142
#
    set afil [aLif] ; $tab delete 0 [$tab size]
    if { ($tan != 4) && ($tan != 5) } { ;# standard channel tables: blist,wlist,favo1,favo2,ftemp
      if { [catch { open $afil } inf ] } { Err 1625 $inf ; return 0 }
      if { !$mara && !$mahot } { ;# simple list, no marks for radio or hotbird
        while { ![ eof $inf ] } { gets $inf curl ; set chap [split $curl : ]
          if { [string length $curl] } { $tab insert end [lindex $chap 0 ] } } ;# while
      } else { ;# channel list possibly with marks for radio or hotbird
        while { ![ eof $inf ] } { gets $inf curl ; set chap [split $curl : ]
          if { [string length $curl] } { $tab insert end [lindex $chap 0 ]
            if { [llength $chap] >= 5 } { ;# normal channel name: may be marked
              if { ![ string first "BANDWIDTH" [lindex $chap 3 ] ] } { continue } ;# dvb-t
              set ara [expr [lindex $chap 5] == 0 ] ; set ahot [expr [lindex $chap 3] > 0 ]
              if {  $ara&&$mara  } { $tab itemconfigure end -foreground "darkgreen" }
              if { $ahot&&$mahot } { $tab itemconfigure end -foreground "darkblue"  } }
      }   } } ; catch { close $inf } ;# tan = 0,1,2,3: channel list complete
    } else { foreach lin $titles([expr $tan-2]) { $tab insert end $lin } }
#
    set len [$tab size] ; if { !$len } { $tab insert end $ms142 } ;# empty
#
    set pos $sel($tan) ; if { $pos > $len } { set pos $len } ;# pos of visible item
    set pos0 $pos ; set item  [ $tab get $pos ] ;# selected item
#  special handling for 'titles' in a favo-list:
    if { ($tan == 2) || ($tan == 3) } { ;# favo-list
      if { [string length $item] >= 2 } { set key [string range $item 0 1] } else { set key "" }
      if { $key == "__" } { ;# title: select next line
        set pos [ expr $pos + 1 ] ; if { $pos > $len } { set pos $len } ;# select next line
        set seefirst $pos0  ; set rest [expr $len - $pos0] ;# get 1st + last visible line
        if { $rest > 12 } { set seelast [expr $pos0 + 11] } else { set seelast $len }
        $tab see $seelast ; $tab see $seefirst ;#  last + 1st element in window
      } else { $tab see $pos0 }
    } else { $tab see $pos0 }
# set selection:
    set sel($tan) $pos ; $tab selection set $pos
    showChanParms ; saveConfig
  } ;# end proc.updateTable
#
#*************************************************************************************************
# Proc. newTab {} switches to a new tan value and shows the new list in the table
#*************************************************************************************************
#
proc newTab { } {
    global tan oldtan sel titles titpos
    update ; if { (($tan == 2 ) || ($tan == 3)) && ($oldtan == [expr $tan + 2]) } {
      if { [llength $titles($tan)] } { set sel($tan) $titpos($tan,$sel($oldtan)) } }
    set oldtan $tan ; updateTable ; packAllKeys
  } ;# end proc. newTab
#
#*************************************************************************************************
#  Proc.showChanParms {} formats the channel parameeters and shows the list file dir+name
#*************************************************************************************************
#
proc showChanParms {} {
    global tan tab sel cdat xdat1 xdat2 ms15 ms73 ms143 ms144 ms148 ms315
#
    update ; set alif [aLif] ; set xdat2 "$ms315 $alif" ;# actual list-file name
    if { [catch {set chan [ $tab get $sel($tan) ] } ] } { Err 1468 $ms73 ; return }
    if { ![string first "__" $chan ] } { set xdat1 $ms144 ; set name $ms15 ;# title: no chan.data
    } elseif { [catch {exec sed -n [expr $sel($tan) + 1]p $alif } curl] } {
      set xdat1 $ms148 ; set name $chan ;# cannot identify chan in list
    } else {  ;# try to process data from list file
      set chap [split $curl : ] ;  set name "$ms15:   *[lindex $chap 0 ]*"
      if { [llength $chap] < 2 } { set xdat1 $ms148 } else {
        if { ![ string first "BANDWIDTH" [lindex $chap 3 ] ] } { ;#  dvb-t:
          set freq  [ expr [lindex $chap 1 ] / 1000000 ] ; set vpid  [lindex $chap 10 ]
          set apid [lindex $chap 11 ] ; set sid [lindex $chap 12 ]
          set xdat1 "${freq}MHz, vp=$vpid, ap=$apid, sid=$sid"
        } else { ;# dvb-s: 0=Name, 1=frequ, 2=v/h, 3=sat#, 4=Symb.Rate, 5=VPID, 6=APID, 7=Sid
          set frequ [lindex $chap 1 ] ; set pol [lindex $chap 2 ] ; set sat [lindex $chap 3 ]
          set satnam [lindex { astra hotbd } $sat ] ; set srate [lindex $chap 4 ]
          set vpid   [lindex $chap 5 ] ; set apid  [lindex $chap 6 ] ; set sid  [lindex $chap 7 ]
          set xdat1 "$frequ$pol, $satnam, $srate, vp=$vpid, ap=$apid, sid=$sid"
    } } } ;# if chan data ok
    $cdat configure -text $name ;# show name as labelframe text
  } ;# end proc. showChanParms
#
#*************************************************************************************************
#  proc. doMark {} updates mara + mahot and updates the channels table
#*************************************************************************************************
#
proc doMark { } {
    global tan
    update ; updateTable ; saveConfig
  } ;# end proc.doMark
#
#*************************************************************************************************
#  Proc. copyList {} copies the selected file into the listfile
#*************************************************************************************************
#
proc copyList { } {
    global tan home ms137 ms138
#
    set alit [aLit] ; set alif [aLif]
    set adir [file dirname $alif ] ; set atail [file tail $alif ]
    if {![file isdirectory $adir]} { #  make sure that an initial dir exists:
      set adir $home/pctv/channels ; catch { exec mkdir -p $adir } } ;# if no $adir
#
    set inp [tk_getOpenFile -initialdir $adir -initialfile $atail -parent . \
                                              -title $ms137$alit$ms138]
    if { $inp == "" } { return 0 } ;#  aborted, no entry
    set err [ catch { exec cp -f $inp $alif } res ]
    if { $err } { Err 1625 $res ; return 0 }
    updateTable ; return 1 ;# terminated successfully
  } ;# end proc. copyList
#
#*************************************************************************************************
#  Proc. linkList {} gets the listfile name (dir/tail) for $tan
#*************************************************************************************************
#  (was formerly proc importList)
proc linkList { } {
    global tan home blist wlist favo1 favo2 ms137 ms138
#
    set alit [aLit] ; set alif [aLif]
    set adir [file dirname $alif ] ; set atail [file tail $alif ]
    if {![file isdirectory $adir]} { #  make sure that an initial dir exists:
      set adir $home/pctv/channels ; catch { exec mkdir -p $adir } } ;# if no $adir
#
    set inp [tk_getOpenFile -initialdir $adir -initialfile $atail -parent . \
                                              -title $ms137$alit$ms138]
    if { $inp == "" } { return 0 } ;#  aborted, no entry
    switch $tan { 0 { set blist $inp }  1 { set wlist $inp } \
                  2 { set favo1 $inp }  3 { set favo2 $inp } } ;# save listfile name
    saveConfig ; updateTable ; return 1 ;# terminated successfully
  } ;# end proc. linkList

#*************************************************************************************************
#  Proc. storeList saves the channel list in an external file
#*************************************************************************************************
#  (was formerly proc exportList)
proc storeList {} {
    global home ms154
#
    set alit [aLit] ; set alif [aLif] ; set adir $home/pctv/channels
    if {![file isdirectory $adir]} { catch { exec mkdir -p $adir } } ;# if no $adir
#
    set dest [tk_getSaveFile -initialdir $adir -title $alit ]
    if { $dest == "" } { return }  ;#  aborted
    set err [catch { exec cp $alif $dest } info ]
    if { $err } { Err 1650 $info ; return 0
    } else { tk_messageBox -icon info -type ok -title $alit -message "$ms154 $dest" }
  } ;# end proc. storeList
#
#*************************************************************************************************
#  proc. doFilter { modus } filters the actual listfile
#*************************************************************************************************
#
proc doFilter { modus } {
    global tan tab sel blist wlist dtec ms73
#
    if { !$modus || ![file size $wlist] } { catch {exec cp -f $blist $wlist } } ;# load blist
    set alif [aLif] ; set tfil $dtec/fil.tmp ; if {[catch {open $tfil w} temp]} {Err 1568 $temp}
#
    set oct -1 ; set  nct 0 ; if { [catch {open $alif } inf] } { Err 1570 $inf ; return }
    while { ![eof $inf] } { gets $inf curl ; if { ![string length $curl] } { continue } ; incr oct
#       ChanParms: 0 = Name, 1 = frequ, 2 = v/h, 3 = astra/hotbd, 5 = Audio-PID
        set chap [split  $curl : ] ; if { [llength $chap] > 1 } {
          set cname  [lindex $chap 0] ; set satnb [lindex $chap 3] ; set apid [lindex $chap 5]
        switch $modus {  1 {if { !$apid } { continue } }  2 {if { $apid } { continue } }
          3 {if { $satnb } { continue } }   4 {if { !$satnb } { continue } }
          5 {if { ![string first \[ $curl] } { continue } }  } } ;# switch $modus, if curl
        puts $temp $curl ; if { $oct == $sel($tan) } { set sel($tan) $nct } ; incr nct } ;# while
    catch { close $inf } ; catch { close $temp } ; catch { exec mv -f $tfil $alif }
    updateTable
  } ;# end proc.doFilter
#
#*************************************************************************************************
#  Proc. doSort { modus } sorts the actual channel list
#*************************************************************************************************

proc doSort { modus } {
    global tan sel blist
#
#  Modus: 1 = abc-xyz, 2 = zyx-cba, 3 = Frequenz;  4 + 5: see proc.manSort {modus}
#  ChanParms: 0 = Name, 1 = Frequ, 2 = v/h, 3 = astra/hotbd, 5 = video-PID
    set alif [ aLif ] ; if { ![file size $alif] } { catch {exec cp -f $blist $alif } }
    if {[catch { exec sed -n [expr $sel($tan) + 1]p $alif } oldsel]} { set oldsel 0 }
    switch $modus {   1 { exec sort -f  -o $alif $alif }  2 { exec sort -fr -o $alif $alif }
                      3 { exec sort -f  -t: +1n -o $alif $alif } } ;# end switch $modus
    set  nct 0 ; if { [catch {open $alif } inf] } { Err 1591 $inf ; return }
    while { ![eof $inf] } { gets $inf curl ; if { ![string length $curl] } { continue }
        if { $curl == $oldsel } { set sel($tan) $nct ; break } else { incr nct } }
    updateTable  ;#  show filtered + sorted list
  } ;# end proc. doSort
#
#*************************************************************************************************
#  proc. manSort {modus}  sorts the actual channel list by Sat# + TV/Radio
#*************************************************************************************************
#
proc manSort { modus } {
    global tan sel blist dtec
#  Modus:  4 = SatID; 5 = TV/Radio
#
    set alif [ aLif ] ; if { ![file size $alif] } { catch {exec cp -f $blist $alif } }
    if {[catch { exec sed -n [expr $sel($tan) + 1]p $alif } oldsel]} { set oldsel 0 } ;# old sel.
    set tfil1 $dtec/fil1.tmp ; if {[catch {open $tfil1 w} temp1]} {Err 1597 $temp1 ; return}
    set tfil2 $dtec/fil2.tmp ; if {[catch {open $tfil2 w} temp2]} {Err 1598 $temp2 ; return}
#
    if { [catch {open $alif } inf] } { Err 1600 $inf ; return }
    while { ![eof $inf] } {
      gets $inf curl ; if { ![string length $curl] } { continue } ; set chap [split $curl : ]
      if { ([llength $chap] < 5) || (![ string first "BANDWIDTH" [lindex $chap 3 ] ]) } {
               set ara 0 ; set ahot 0 ;# ;# dvb-t or title or bad channel
      } else { set ara [expr [lindex $chap 5] == 0 ] ; set ahot [expr [lindex $chap 3] > 0 ] }
      switch $modus {  4 { if { !$ara } { puts $temp1 $curl } else { puts $temp2 $curl } }
                       5  {if { $ahot } { puts $temp1 $curl } else { puts $temp2 $curl } } }
    } ; catch { close $inf } ; catch { close $temp1 } ; catch { close $temp2 } ;# end while
    catch { exec mv -f $tfil1 $alif } ;# 1st part of sorted file
#  2nd step: append fil2.tmp to the result file
    if {[catch {open $alif a } res  ]} { Err 1611 $res   ; return}
    if {[catch {open $tfil2  } temp2]} { Err 1612 $temp2 ; return}
    catch { read -nonewline $temp2 tdat2 } ; catch { puts -nonewline $res $tdat2 }
    catch { close $res } ; catch { close $temp2 } ;# 2nd part of sorted file
#  set selection to old channel
    set  nct 0 ; if { [catch {open $alif } inf] } { Err 1616 $inf ; return }
    while { ![eof $inf] } { gets $inf curl ; if { ![string length $curl] } { continue }
        if { $curl == $oldsel } { set sel($tan) $nct ; break } else { incr nct } }
    updateTable  ;#  show filtered + sorted list
  } ;# end proc. manSort
#
#*************************************************************************************************
# Proc. getTitles {tan0} creates the lists titles($tan) + titpos($tan,$pos) from files favo1,2
#*************************************************************************************************
#  tan0=2: favo1, titles(2), titpos(2,sel($tan));  tan0=3: favo2, titles(3), titpos(3,sel($tan))
proc getTitles { tan0 } {
    global favo1 favo2 titles titpos
#
    if { ($tan0 != 2) && ($tan0 != 3) } { return } ;# no favo list: ignore
    eval "set infile \$favo[expr $tan0-1]" ; set titles($tan0) "" ; set ln 0 ; set tn 0
    if { [catch { open $infile } inf ] } { Err 1760 $inf ; return }
    while { ![eof $inf] } { if { [catch { gets $inf } curl ] } { Err 1772 $curl ; return }
      if { [string length $curl] > 1 } { if { [string range $curl 0 1] == "__" } {
      lappend titles($tan0) $curl ; set titpos($tan0,$tn) $ln ; incr tn } ; incr ln } }
    catch { close $inf }
  } ;# end proc. getTitles
#
#*************************************************************************************************
#  Pro. insTitle {} enters a new title into the favo1,2-list
#*************************************************************************************************
#
proc insTitle  {} {
    global w tan titreply sel ms156 ms157 ms158 ms159 ms160
#
    set wtit .intitle ; toplevel $wtit ; wm title $wtit $ms156 ; wm geometry $wtit 300x100-40-120
    set intit1 .intitle.but ; set intit2 .intitle.entry
#
    frame  $intit1 -width 30
    button $intit1.b1 -text $ms159 -width 9 -relief solid -borderwidth 3 -command "titEntry 1"
    button $intit1.b2 -text $ms160 -width 9 -command "titEntry 2"
    pack   $intit1.b1 $intit1.b2 -side left
#
    frame $intit2
    label $intit2.m1 -justify left -text $ms157 ; label $intit2.m2 -justify left -text $ms158
    entry $intit2.e1 -textvariable titreply
    pack  $intit2.m1 $intit2.m2 $intit2.e1 -side top
    pack  $intit2   $intit1 ; tkwait window $wtit
#
#  process new title:
    if { $titreply != "" } {
      set newTitle "____[string trim $titreply " _><|@#" ]____"
      set afil [ aLif ] ; exec sed "[expr $sel($tan) + 1]i\\$newTitle" $afil > ${afil}.tmp
      if { [catch { exec mv -f ${afil}.tmp $afil } rep ] } { Err 1696 $rep ; return }
      getTitles $tan ; updateTable
    } ;#  end if OK
  } ;#  end proc. insTitle
#
#*************************************************************************************************
#  Proc. titEntry { but } reads a new title from the dialog box
#*************************************************************************************************
#  but=1: OK; but=2: Abort
proc titEntry { but } {
    global titreply
    if { $but == 2 } { set titreply "" } ; destroy .intitle
  } ;# end proc. titEntry
#
#*************************************************************************************************
#   Prozedur compress {} schaltet die erweiterten Knoepfe aus
#*************************************************************************************************
#
proc compress {} {
    global allkeys rab2 xbut41 ms11 bgcolor
    $rab2.b1 configure -bg $bgcolor ; set xbut41 $ms11 ; set allkeys 0 ; packAllKeys
  } ;# end proc. compress
#
#*************************************************************************************************
#   Prozedur expand {} schaltet alle Knoepfe ein (soweit benoetigt)
#*************************************************************************************************
#
proc expand {} {
    global allkeys rab2 xbut41 ms12 offbut offcolor bgcolor
    if { $offbut } { $rab2.b1 configure -bg $offcolor } else { $rab2.b1 configure -bg $bgcolor }
    set xbut41 $ms12 ; set allkeys 1 ; packAllKeys
  } ;# end proc. expand
#
#*************************************************************************************************
#  Prozedur packAllKeys {} schaltet die variablen Knoepfe ein oder aus, soweit noetig
#*************************************************************************************************
#
proc packAllKeys {} {
    global tan allkeys wing wing6 fiso fav2 fav3 fav4 mabu2 fil ftemp fav5 offcolor bgcolor
#
    pack unpack $fiso ; pack unpack $wing6
    if { ($allkeys == 0) || ($tan == 4) || ($tan == 5) } { pack unpack $wing ; return ;# titles
    } elseif { $tan == 6 } {
      pack unpack $wing ; pack $wing6 -side left -padx 4 -pady 4 ; return ;# scratchpad
    } else { $fav4 configure -text [ aLit ] ; pack $wing -side left -padx 4 -pady 4 }
    if { ($tan == 2)||($tan == 3) } { pack unpack $fav2 ; pack $fav3 -side bottom -pady 6 -padx 2
    } else { pack unpack $fav3 ; pack $fav2 -side bottom -pady 6  -padx 2 }
    if { $tan <= 1 } { if { $tan == 1 } { pack $fil.b1 -side top } else { pack unpack $fil.b1 }
      pack $fiso -side left -expand 1 -fill y -padx 8 -pady 4
    } else { pack unpack $fiso }
    $mabu2.b3 configure -foreground "darkgreen" ; $mabu2.b4 configure -foreground "darkblue"
    if { [lindex [exec wc -l $ftemp] 0 ] } { $fav5.b8 configure -bg $offcolor
    } else { $fav5.b8 configure -bg $bgcolor }
  } ;# end proc. packAllKeys
#
#*************************************************************************************************
#  proc.aLif {} returns the listfile name (dir/tail) for $tan: $blist $wlist $favo1 $favo2
#*************************************************************************************************
#  note: in case of tan = 4 or 5 aLif returns $favo1 or $favo2
proc aLif { } {
    global tan blist wlist favo1 favo2 ftemp
    return [lindex [list $blist $wlist $favo1 $favo2 $favo1 $favo2 $ftemp] $tan]
  }  ;# end proc. aLif
#
#*************************************************************************************************
#  proc.aLit {} returns the actual list type for $tan: e.g. "Basisliste" etc.
#*************************************************************************************************
#
proc aLit { } {
    global tan ms149 ms147 ms151 ms152 ms153
    return [lindex [list $ms149 $ms147 $ms151 $ms152 $ms153] $tan]
  }  ;# end proc. aLit
#
#*************************************************************************************************
#   Prozedur welcomewindow1 {} startet das Welcome-Fenster  (old)
#*************************************************************************************************
#
proc welcomewindow1 {} {
    global myVersion0
#
    toplevel    .welwin
    wm geometry .welwin 375x410-0-0
    wm title    .welwin "Welcome"
    frame       .welwin.welframe -relief sunken -bd 5 -width 325 -height 400
    pack        .welwin.welframe
    label       .welwin.welframe.m1 -justify center -font {Helvetica 36 bold } \
                                 -text "\nW e l c o m e\n"
    label       .welwin.welframe.m2 -justify center -text "t o\n\n\n"
    label       .welwin.welframe.m3 -justify center -text "t h e  W o r l d  o f\n\n"
    label       .welwin.welframe.m4 -justify center -font {Helvetica 36 bold } \
                                  -text "T E C L A S A T\n"
    label       .welwin.welframe.m5 -justify right -text "Version: $myVersion0"
    pack        .welwin.welframe.m1 .welwin.welframe.m2 .welwin.welframe.m3
    pack        .welwin.welframe.m4 .welwin.welframe.m5
   } ;# end proc.welwin
#
#*************************************************************************************************
#  proc.blinker { $interval ..etc..}  modifies the color of the star widgets          *
#*************************************************************************************************
#
proc blinker { interval ww  wst wms ictr cctr } {
#
    if { ![ winfo exists $ww ] } { return }
#
    set msgnbr    12 ;# max.index of welcome messages ( 0 ... 12)
    set colors    [ list  red  gold  aquamarine bisque yellow pink snow3    \
                     orange red bisque yellow pink chartreuse gold magenta ]
    set indexlist [ list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ]
    set indexnbr  [ llength $indexlist ]
    set si        [ lindex $indexlist $ictr ]
#
    set parm1     [ lindex $colors  $cctr ]
    $wst$si  configure -fg $parm1
    incr ictr ; if { $ictr >=  $indexnbr } { set ictr 0 }
    incr cctr ; if { $cctr >= [ llength $colors ] } { set cctr 0 }
#
    set si2 [expr $si + 5 ]
    if { $si2 >= $indexnbr } { set si2 [expr $si2 - $indexnbr] }
    set parm1     [ lindex $colors  $cctr ]
    $wst$si2  configure -fg $parm1
    incr ictr ; if { $ictr >=   $indexnbr         } { set ictr 0 }
    incr cctr ; if { $cctr >= [ llength $colors ] } { set cctr 0 }
#
    incr si2 5  ; if { $si2 >= $indexnbr } { set si2 [expr $si2 - $indexnbr] }
    set parm1     [ lindex $colors  $cctr ]
    $wst$si2  configure -fg $parm1
    set msi $si ; if { $msi > $msgnbr } { set msi [expr $si - $msgnbr] }
    $wms$msi  configure -fg $parm1
    incr ictr ; if { $ictr >=   $indexnbr         } { set ictr 0 }
    incr cctr ; if { $cctr >= [ llength $colors ] } { set cctr 0 }
    after $interval [ list blinker $interval $ww $wst $wms $ictr $cctr ]
  } ;# end proc.blinker
#
#*************************************************************************************************
# Prozedur welcomewindow { lifetime } startet das Welcome-Fenster  lifetime / msecs)  *
#*************************************************************************************************
#
proc welcomewindow { lifetime } {
      global myVersion0 ficon
#
# Erzeugen der Titelseite
#
    if { [winfo exists .welwin ] } { return }
    if { $lifetime == 0          } { return }
#
    set ww .welwin ; set wframe $ww.welframe ;  set wms $ww.m ; set wst $ww.star
    toplevel $ww              ;    wm geometry $ww 420x450-40-80
    wm title $ww "Willkommen" ;    wm minsize  $ww 20 12
#
    label        $ww.b2 -width 420 -height 450 -bg blue3
    pack         $ww.b2
    frame        $ww.welframe -relief sunken -bd 5  -bg bisque
    place        $ww.welframe -relx 0.08 -rely 0.24 -relwidth 0.85 -relheight 0.64
#
#   Textlabels erzeugen fuer die welcome-Texte
#
    set      mi   0
    set welcometext [ list  Bienvenue Benvenuto  Bienvenido Bemvindo  Benvingut \
      {Boa Vinda} Velkommen Bainvegni Gruetzi {Dobro dosli} shalom Witamy Willkommen ]
    set welcolors   [ list  red       aquamarine bisque     yellow    pink      \
       orange     aquamarine bisque    yellow   pink     chartreuse orange magenta ]
    set ftList [ list { {Courier New} 15 bold roman } { Gothic  16 bold italic} \
                      { Lucida  14 bold roman } { Terminal      16 bold italic} \
                      { Roman   17 bold roman } { Times         16 bold italic} \
                      { Times   17 bold italic} { {Courier New} 16 bold roman } \
                      { Arial   16 bold italic} { {Courier New} 13 bold roman } \
                      { Courier 15 bold italic} { Terminal      22 bold italic} \
                      { Times   18 bold italic} { Times         16 bold italic} \
                      { Times   33 bold italic} { Courier       16 bold roman } \
                      { Arial   16 bold italic} ]
    set welx   [ list  1e-2 35e-2 70e-2 17e-2 55e-2  1e-2 35e-2 70e-2 \
                                                     1e-2 35e-2 70e-2 17e-2 55e-2 ]
    set wely   [ list  1e-2  1e-2  1e-2  8e-2  8e-2 16e-2 16e-2 16e-2 \
                                                    88e-2 88e-2 88e-2 94e-2 95e-2 ]
#
    set starsx [ list  32e-2 64e-2 11e-2 46e-2 89e-2 30e-2 65e-2 \
           2e-2  2e-2 95e-2 94e-2  30e-2 67e-2 11e-2 46e-2 89e-2 ]
    set starsy [ list   2e-2  3e-2  9e-2 10e-2  8e-2 17e-2 17e-2 \
          40e-2 68e-2 42e-2 66e-2  89e-2 89e-2 95e-2 94e-2 95e-2  ]
#
    foreach welmsg $welcometext {
      set fgcolor  [ lindex $welcolors $mi ] ;  set wft    [ lindex $ftList $mi ]
      set wmsx     [ lindex $welx $mi ]      ;  set wmsy   [ lindex $wely   $mi ]
      label    $wms$mi -bg blue3   -fg $fgcolor -text $welmsg
      place    $wms$mi -relx $wmsx -rely $wmsy  -relwidth 30e-2 -relheight 5e-2
      $wms$mi configure -font $wft
      incr mi
    } ;# end foreach welmsg
#
#   Teclasat - Msg erzeugen im inneren Rahmen
#
    set mi   0
    set ttt [ list { } {W E L C O M E} {t o  t h e  W o r l d  o f} {T E C L A S A T} ]
    lappend ttt  "Version: $myVersion0"
    set fttList [ list { Courier 8 bold italic } { Lucida 16 bold italic } \
       { Lucida 16 bold italic } { Lucida 26 bold italic } { Lucida 13 bold italic } ]
    foreach teclamsg $ttt {
      label    $wframe.m$mi -bg bisque -fg blue -text $teclamsg
      set ftt [ lindex $fttList $mi ]
      $wframe.m$mi configure -font $ftt
      incr mi
    } ;# end foreach teclamsg
#
    if { $ficon != "" } {
#     teclasat icoin found
      set   teclapict   [image create photo -file $ficon ]
      label $wframe.m10 -image $teclapict  ;#  teclasat icon
    } else {
#     teclasat icon not found
      frame $wframe.m10 -relief sunken -bd 5  -bg blue -height 150 -width 150
      label $wframe.m10.msg -text "teclasat" -font { Lucida 13 bold italic }
      pack  $wframe.m10.msg -ipady 15 -ipadx 15
      bind  $wframe.m10.msg <Button> {  destroy .welwin }
    } ;# end if teclasat icon found
    bind $wframe.m10 <Button> {  destroy .welwin }
    pack    $wframe.m0 $wframe.m1 $wframe.m2 $wframe.m10 $wframe.m3 -side top -pady 3
    pack    $wframe.m4 -side bottom
#
#   Sterne abbilden im aeusseren Rahmen
#
    set mi     0
    set stfont {Times 36  bold roman }
    foreach stx $starsx {
      set sty  [ lindex $starsy $mi ]
      label    $wst$mi -bg blue3 -fg gold -text "*"
      $wst$mi  configure -font $stfont
      place    $wst$mi -relx $stx -rely $sty -relwidth 6e-2 -relheight 7e-2
      incr mi
    } ;# end foreach star
#
#   Blinker-Prozedur im Background
    set ictr 0 ;  set cctr 0 ; set interval 100
    blinker $interval $ww $wst $wms $ictr $cctr
    if { $lifetime > 0 } { after $lifetime { destroy .welwin } }
  } ;# end proc. welcomewindow
#
#
#*************************************************************************************************
# Prozedur doConfig {} macht den Dialog fuer die Einstellungen (Player, V.Text, etc..)
#*************************************************************************************************
#
proc doConfig  {} {
    global isplayer isvtext allPlayers  myVersion0
    global playertyp playerflag vtflag showflag autoflag modflag
    global bgcolor fgcolor actcolor offcolor mara mahot adel aconf
    global ad siglist sigtyp zap offbut
    global ms30 ms31 ms52 ms53 ms54 ms55 ms56 ms57 ms58 ms59 ms60 ms61 ms62 ms63
    global ms64 ms65 ms68 ms69 ms70
    global ms153 ms161 ms162 ms163 ms164 ms165 ms166 ms167 ms168 ms169
    global ms170 ms171 ms172 ms173 ms174 ms176 ms177 ms178 ms179
    global ms180 ms181 ms182 ms183 ms184 ms185 ms186 ms187 ms188 ms189
    global ms190 ms191 ms192 ms193 ms604 ms607
    global wh  wbot wmsg wbut1 wbut2 wbut3 cbut3 f1
#
    if { [winfo exists .doConfig ] } { destroy .doConfig }
    set  wcf .doConfig         ; set wbottom  $wcf.bottom     ;# for proc. doConfig
    set  wmsg  $wbottom.messages
    set wbut1 $wbottom.but1 ; set wbut2 $wbottom.but2 ; set wbut3 $wbottom.but3
    toplevel $wcf ;    wm title $wcf $ms162 ;     wm geometry $wcf -40-80
#    wm geometry $wcf 459x100+824+216  ???
#
# first row: signal sources
    set wco1 $wcf.row1
    frame $wco1  -padx 2 -pady 2
#
#   Radio-Buttons for adapter selection
#
    set wada $wco1.selAdapter ; set wsig $wco1.selSig
    labelframe  $wada -text $ms163 -width 50m -padx 4 -pady 4
    radiobutton $wada.b0 -text "adapter0" -width 8 \
         -anchor w -relief flat -variable ad -value 0 -command "set-ada 0"
    radiobutton $wada.b1 -text "adapter1" -width 8 \
         -anchor w -relief flat -variable ad -value 1 -command "set-ada 1"
    radiobutton $wada.b2 -text "adapter2" -width 8 \
	 -anchor w -relief flat -variable ad -value 2 -command "set-ada 2"
    radiobutton $wada.b3 -text "adapter3" -width 8 \
	 -anchor w -relief flat -variable ad -value 3 -command "set-ada 3"
    pack $wada.b0 $wada.b1 $wada.b2 $wada.b3  -side top -pady 2 -anchor w
#
#  signal selection
    labelframe $wsig -text $ms164  -width 9 -padx 4 -pady 4
    radiobutton $wsig.b0 -text "dvb-s" -width 8 \
         -anchor w -relief flat -variable sigtyp -value "s" -command "set-sig s"
    radiobutton $wsig.b1 -text "dvb-t" -width 8 \
         -anchor w -relief flat -variable sigtyp -value "t" -command "set-sig t"
    radiobutton $wsig.b2 -text "dvb-c" -width 8 \
	 -anchor w -relief flat -variable sigtyp -value "c" -command "set-sig c"
    pack $wsig.b0 $wsig.b1 $wsig.b2  -side top -pady 2 -anchor w
#
# second row: output: players, videotext
    set wco2 $wcf.row2
    frame $wco2  -padx 2 -pady 2
#
#   Radio-Buttons for Player selection
#
    set wplay $wco2.selPlayer
    labelframe  $wplay -text $ms170 -width 50m -padx 4 -pady 4
    set playerflag [lsearch $allPlayers $playertyp ]
    radiobutton $wplay.b0 -text $ms171 -width 9 \
       -anchor w -relief flat -variable playerflag -value 0 -command "selectPlayer 0"
    radiobutton $wplay.b1 -text $ms172 -width 9 \
       -anchor w -relief flat -variable playerflag -value 1 -command "selectPlayer 1"
    radiobutton $wplay.b2 -text $ms173 -width 9 \
       -anchor w -relief flat -variable playerflag -value 2 -command "selectPlayer 2"
    radiobutton $wplay.b3 -text $ms174 -width 9 \
       -anchor w -relief flat -variable playerflag -value 3 -command "selectPlayer 3"
#
    if { $isplayer(xine)     } { pack $wplay.b0 -side top -pady 2 -anchor w }
    if { $isplayer(kaffeine) } { pack $wplay.b1 -side top -pady 2 -anchor w }
    if { $isplayer(mplayer)  } { pack $wplay.b2 -side top -pady 2 -anchor w }
    if { $isplayer(totem)    } { pack $wplay.b3 -side top -pady 2 -anchor w }
#
#   Radio-Buttons zur Auswahl des Videotext-Programms
#
    set wvtxt $wco2.selVText
    labelframe  $wvtxt -text $ms176  -width 9 -padx 4 -pady 4
    if { $isvtext(alevt) } {
      radiobutton $wvtxt.b0 -text $ms177  -width 9 -anchor w \
              -relief flat -variable vtflag -value 0 -command "selectVText 0"
    } ;# end if alevt
    if { $isvtext(mtt4) } {
      radiobutton $wvtxt.b1 -text $ms178    -width 9 -anchor w \
              -relief flat -variable vtflag -value 1 -command "selectVText 1"
    } ;# end if mtt4   <<<<<<<<<<<-command "selectVText 1"
    if { $isvtext(mtt) } {
      radiobutton $wvtxt.b2 -text $ms179    -width 9 -anchor w \
              -relief flat -variable vtflag -value 2 -command "selectVText 2"
    } ;# end if mtt4   <<<<<<<<<<<-command "selectVText 1"
    if { $isvtext(alevt) } { pack $wvtxt.b0 -side top -pady 2 -anchor w }
    if { $isvtext(mtt4)  } { pack $wvtxt.b1 -side top -pady 2 -anchor w }
    if { $isvtext(mtt)   } { pack $wvtxt.b2 -side top -pady 2 -anchor w }
#
#   Check-Buttons zum Anzeige-Modus
#
    set wshow  $wco2.show
    labelframe  $wshow  -text $ms181 -width 11 -padx 4 -pady 4
    checkbutton $wshow.b0 -text $ms182 \
                -variable showflag -width 11 -anchor w -relief flat -command packMain
    checkbutton $wshow.b2 -text $ms59 \
                -variable offbut -width 11 -anchor w -relief flat -command packMain
    checkbutton $wshow.b3 -text $ms30 \
                -variable mara -width 11 -anchor w -relief flat -command doMark
    checkbutton $wshow.b4 -text $ms31  \
                -variable mahot -width 11 -anchor w -relief flat -command doMark
    pack $wshow.b0 $wshow.b2 $wshow.b3 $wshow.b4 -side top -pady 2 -anchor w
#
#   Check-Buttons for scratchpad mode
#
    set wdel  $wco2.del
    labelframe  $wdel -text $ms153 -width 11 -padx 4 -pady 4
    checkbutton $wdel.b1 -text "auto-del" \
                -variable adel -width 11 -anchor w -relief flat -command ""
    checkbutton $wdel.b2 -text "Bestätigen" \
                -variable aconf -width 11 -anchor w -relief flat -command ""
    pack $wdel.b1 $wdel.b2 -side top -pady 2 -anchor w
#
    pack $wplay $wvtxt $wshow $wdel -side left -anchor n -pady 6 -padx 6
#
#  Bottom row: Info + return button (variables wbot, wbut1,2 are global!)
#
    set wco3 $wcf.row3      ; set wmsg  $wco3.messages
    set wbut $wco3.buttons  ; 
    set wbut1 $wbut.buttons1 ; set wbut2 $wbut.buttons2 ;  ; set wbut3 $wbut.buttons3
    frame  $wco3            ; frame  $wmsg  -padx 4 -pady 4
    label  $wmsg.msg0 -text "$ms188$myVersion0" -anchor w -pady 4
    label  $wmsg.msg1 -text $ms189 -anchor w -pady 4
    label  $wmsg.msg2 -text $ms190 -anchor w -pady 4
    pack   $wmsg.msg2 $wmsg.msg1 $wmsg.msg0  -pady 4 -padx 16 -side bottom
#
#  buttons: next-level windows + return
#
    labelframe  $wbut -text $ms191  -padx  4 -pady 4
    frame  $wbut1 -padx  4  -pady 4
    button $wbut1.b1 -text $ms52  -width 9 -command "doHelp"
    button $wbut1.b2 -text $ms68  -width 9 -command "kill-all-progs"
    button $wbut1.b3 -text $ms70  -width 9 -command "quitConfig"
    pack   $wbut1.b3 $wbut1.b2 $wbut1.b1 -side bottom
#
    frame  $wbut2 -padx  4  -pady 4
    button $wbut2.b1 -text $ms607 -width 9 -command "configScan"
    button $wbut2.b2 -text $ms604 -width 9 -command "doEdit"
    button $wbut2.b3 -text ""     -width 9 -command ""
    button $wbut2.b4 -text $ms69  -width 9 -command "mplayerConfig"
    if { $isplayer(mplayer) } { 
        pack $wbut2.b4 -side bottom } else  { pack $wbut2.b3 -side bottom }
    pack   $wbut2.b2 $wbut2.b1  -side bottom
#
    frame  $wbut3 -padx  4  -pady 4
    button $wbut3.b1 -text $ms192 -width 9 -command "doLang"
    button $wbut3.b2 -text $ms193 -width 9 -command "doTimes"
    button $wbut3.b3 -text $ms53  -width 9 -command "doColor"
    pack   $wbut3.b3 $wbut3.b2 $wbut3.b1  -side bottom
    pack  $wbut3 $wbut2 $wbut1 -pady 2 -padx 2 -side left
    pack  $wmsg  $wbut  -pady 2 -padx 2 -fill y -side left
#
#  pack 3 rows and configure the colors + fonts
#
    set wco4 $wcf.row4
    frame  $wco4 -height 2 -padx 4 -pady 4 -borderwidth 2 -relief sunken
    pack $wco1 $wco2 ; pack $wco4  -padx 6 -fill x  ; pack $wco3 -pady 6 -padx 6
#    pack  unpack $cbut3.conf           ;#
#    pack  $cbut3.coff -side top
#
    set ft00 "Courier 12 bold italic"
    $wmsg.msg0 configure -font $ft00
    $wmsg.msg1 configure -font $ft00
    $wmsg.msg2 configure -font $ft00
#
    setColor $wcf -background $bgcolor
    setColor $wcf -foreground $fgcolor
    $wshow.b3 configure -foreground "darkgreen" ; $wshow.b4 configure -foreground "darkblue"
    setColor $wcf -activebackground $actcolor
    tkwait window $wcf
  } ;#  end proc. doConfig
#
#
#*************************************************************************************************
#####################    Prozeduren  fuer  doConfig & co    ###########################
#*************************************************************************************************
#
#   Proc. quitConfig { } terminates die doConfig-Prozedur
#
proc quitConfig { } {
    catch {destroy .doConfig }               ;# Einstell-Fenster loeschen
  } ;# end proc.quitConfig
#
#   Proc.set-ada { ada} updates the zap-command for the new adapter
#
proc set-ada { ada } {
    global ad siglist sigtyp zap
    set sigtyp  [ string index $siglist $ada ]
    set zap "${sigtyp}zap"
    saveConfig
  } ;# end proc.set-ada
#
#   Proc.set-sig { newsigtyp} updates the zap-command + sigtyp + siglist
#
proc set-sig { newsigtyp } {
    global  ad siglist sigtyp zap
    set zap "${newsigtyp}zap"
    set siglist0 $siglist
    set siglist [string range $siglist0 0 [expr $ad - 1 ]]
    append siglist $newsigtyp
    append siglist [string range $siglist0 [expr $ad + 1 ] 4 ]
    saveConfig
  } ;# end proc.set-sig
#
#   Proc.set-modflag { } updates the modflag
#
proc set-modflag {  } {
    global modflag
    update ; saveConfig
  } ;# end proc.set-ada
#
#   Proc.selLang { lang } saves the language flag
#
proc selLang { lang } {
    global lang
    saveConfig
  } ;# end proc.selLang
#
#   Proc.reset macht einen soft-reset: kill-progs total
#
proc kill-all-progs {} {
#   soft-reset: laufende Programme abschalten ; evtl. fragen? Do you really want..?
    set proglist [list xine mplayer kaffeine totem szap tzap czap alevt mtt4 tee cat]
    kill-progs $proglist   ;#  kill all programs in list
  } ;# end proc.kill-all-progs
#
#   Proc. newColor value {} liest die Stellung der Regler + bildet den Farbcode
#
proc readColor { wcolors msg disp value } {
    global newColor
    set newColor [format "#%02x%02x%02x" \
                   [$wcolors.red get] [$wcolors.green get] [$wcolors.blue get] ]
    $disp configure -background $newColor
    $msg  configure -text $newColor
  } ;# end proc.newColor
#
#   Proc. defaultColor uebergibt die neue Farbe an proc.setColor
#
proc defaultColor { } {
    global  w bgcolor fgcolor actcolor bgcolor0 fgcolor0 actcolor0
    set bgcolor $bgcolor0   ; setColor $w "-background"       $bgcolor
    set fgcolor $fgcolor0   ; setColor $w "-foreground"       $fgcolor
    set actcolor $actcolor0 ; setColor $w "-activebackground" $actcolor
    saveConfig   ;# save in tecla.conf
  } ;# end proc. defaultColor
#
#   Proc. makeColor uebergibt die neue Farbe an proc.setColor
#
proc makeColor { ctr } {
    global newColor  w bgcolor fgcolor actcolor offcolor
    switch $ctr {
     0 { set options -background       ; set bgcolor  $newColor }
     1 { set options -foreground       ; set fgcolor  $newColor }
     2 { set options -activebackground ; set actcolor $newColor }
     3 { set offcolor $newColor ; saveConfig ; return }
    } ;# end switch ctr
    setColor $w $options $newColor
    saveConfig                          ;# save in tecla.conf
  } ;# end proc. makeColor
#
#   Proc. setColor faerbt alle Fenster einschliesslich aller Unterfenster
#   (ausgenommen: Welcome-Fenster .welwin)
proc setColor { w options newColor } {
    foreach option $options {catch { $w config $option $newColor } }
    foreach child [ winfo children $w] {
      if { $child != ".welwin" } { setColor $child $options $newColor }
    } ;# end foreach child
  } ;# end proc.newColor
#
#   proc.selectPlayer macht den Player #item aktiv und speichert die Conf-Datei ab
#
proc selectPlayer { item } {
    setPlayer $item
    saveConfig
  } ;# end proc.selectPlayer
#
#   proc.selectVText waehlt das VText-Programm an und speichert die Conf-Datei ab
#
proc selectVText { item } {
    global vtflag
    set vtflag $item ; saveConfig
  } ;# end proc.selectVText
#
#   proc. packData packs the cdat frame: show channel data if showflag set
#
proc packData { } {
    global showflag cbut smsg cdat ctop
    update ; if { $showflag } { pack $cdat -side top } else { pack unpack $cdat } ; saveConfig
  } ;# end proc.packData
#
#   proc. packMain packt das Hauptfenster einschl. Anzeige der Senderdaten
#
proc packMain { } {
    global showflag cbut smsg cdat ctop
#    pack unpack $cbut ; pack unpack $cdat ; pack unpack $ctop
    pack unpack $cdat
    if { $showflag } { pack $cbut -side bottom ; pack $ctop $smsg $cdat -side top
    }    else        { pack $cbut -side bottom ; pack $ctop $smsg       -side top}
    saveConfig ; showChanParms
  } ;# end proc.packMain
#
#             ****   Ende Prozeduren fuer doConfig   *****
#
#*************************************************************************************************
# Prozedur doTimes {} macht den Dialog fuer die 'Warte-Zeiten' (welcome etc..
#*************************************************************************************************
#
proc doTimes  {} {
    global bgcolor fgcolor actcolor offcolor weltime weltime0 wait1 wait2 zap
    global ms70 ms196 ms197 ms198 ms199 ms201 ms202 ms203 ms204 ms205 ms206 ms207
    global ms208 ms209 ms210
#
    if { [winfo exists .doTimes ] } {
                  tk_messageBox -type ok -icon info -message $ms161  ; return }
    set wtim .doTimes
    toplevel $wtim ;  wm title $wtim $ms196 ;     wm geometry $wtim -40-80
#
    set wtim1 $wtim.weltime ;   set wtim2  $wtim.intervals
    set wtscal1 $wtim1.scales ; set wtbut1 $wtim1.but
    set wtscal2 $wtim2.scales ; set wtbut2 $wtim2.but
    labelframe $wtim1 -text $ms197
    frame $wtscal1  ;    frame $wtbut1 -bd 4
#
    set wtx0 "$ms198 $weltime ms"
    scale $wtscal1.weltm -from 0 -to 10000 -length 10c -orient horizontal -label $wtx0
    pack  $wtscal1.weltm -side top
    $wtscal1.weltm set $weltime
#
    button  $wtbut1.b0 -text $ms199 -width 9 -command "welcomewindow -1"
    button  $wtbut1.b1 -text $ms209 -width 9 -command "testWelcome $wtscal1"
    button  $wtbut1.b2 -text $ms201 -width 9 -command "tsave $wtscal1 $wtscal2 0"
    button  $wtbut1.b5 -text $ms202 -width 9 -command "tsave $wtscal1 $wtscal2 3"
    pack    $wtbut1.b0 $wtbut1.b1 $wtbut1.b2 $wtbut1.b5 -side top -padx 12
    pack    $wtscal1 -side left -pady 6 ;   pack $wtbut1 -padx 8
#
    labelframe $wtim2 -text $ms203
    frame $wtscal2  ;   frame $wtbut2 -bd 4
#
    set wtx1 "$ms210 $zap$ms204$wait1 ms"
    set wtx2 "$ms205$wait2 ms"
    scale $wtscal2.wait1 -from 0 -to 10000 -length 10c -orient horizontal -label $wtx1
    scale $wtscal2.wait2 -from 0 -to  2000 -length 10c -orient horizontal -label $wtx2
    pack $wtscal2.wait1 $wtscal2.wait2  -side top
    $wtscal2.wait2 set $wait1 ; $wtscal2.wait2 set $wait2
    button  $wtbut2.b3 -text $ms206 -width 9 -command "tsave $wtscal1 $wtscal2 1"
    button  $wtbut2.b4 -text $ms207 -width 9 -command "tsave $wtscal1 $wtscal2 2"
    button  $wtbut2.b5 -text $ms208 -width 9 -command "tsave $wtscal1 $wtscal2 4"
    pack    $wtbut2.b3 $wtbut2.b4 $wtbut2.b5 -side top -padx 12
    pack    $wtscal2 -side left -pady 6 ;   pack $wtbut2 -padx 8
    pack    $wtim1 $wtim2 -side top -padx 4 -pady 10
#
    set wbot  $wtim.bottom ;     set  wmsg  $wbot.messages ; set wbut1 $wbot.buttons1
    frame  $wbot ;               frame  $wmsg  -padx 4 -pady 4
    label  $wmsg.msg0 -text "" -anchor w -pady 4 ;
    pack   $wmsg.msg0  -pady 4 -padx 16 -side bottom
#
#  buttons: next-level windows + return
#
    frame  $wbut1  -padx  4 -pady 4
    button $wbut1.b0 -text $ms70  -width 9 -command "quitTimes $wtim"
    pack   $wbut1.b0 -side right -padx 12
    pack   $wbut1 -pady 2 -padx 8 -side right -anchor e
    pack   $wbot  -pady 8 -padx 6 -side top   -anchor e
#
    setColor $wtim -background $bgcolor ;  setColor $wtim -fg $fgcolor
    setColor $wtim -activebackground $actcolor
    tkwait window $wtim
  } ;#  end proc. doTimes
#
#   Proc. quitTimes { } terminates die doTimes-Prozedur
#
proc quitTimes { wtim } {
    destroy $wtim                          ;# Einstell-Fenster loeschen
  } ;# end proc.quitTimes
#
#   proc.testWelcome { wtscal } tests the welcome window with actual time period
#
proc testWelcome { wtscal } {
    set tim [$wtscal.weltm get]
    welcomewindow $tim
  } ;# end proc.testWelcome
#
#   proc.tsave {wtscal wtbut item} saves the time periods + updates the display
#
proc tsave { wt1 wt2 item } {
    global zap weltime wait1 wait2 weltime0 wait10 wait20 ms198 ms204 ms205 ms210
    switch $item {
     0 { set weltime [$wt1.weltm get] }
     1 { set wait1   [$wt2.wait1 get] }
     2 { set wait2   [$wt2.wait2 get] }
     3 { set weltime $weltime0 }
     4 { set wait1   $wait10 ; set wait2 $wait20 }
    } ;# end switch item
     set wtx0 "$ms198 $weltime ms"         ; $wt1.weltm  configure -label $wtx0
     set wtx1 "$ms210 $zap$ms204$wait1 ms" ; $wt2.wait1  configure -label $wtx1
     set wtx2 "$ms205$wait2 ms"            ; $wt2.wait2  configure -label $wtx2
     saveConfig
  } ;# end proc. tsave
#
#
#*************************************************************************************************
# Proc. doLang {} does the dialog for the language files (help, buttons, messages)    *
#*************************************************************************************************
#
proc doLang  {} {
    global dutil lang thelp tmsg fhelp fmsg
    global myVersion0 bgcolor fgcolor actcolor offcolor ms70 ms161 ms212 ms218 ms219
#
    if { [winfo exists .doLang ] } {
              tk_messageBox -type ok -icon info -message $ms161  ; return }
    set wlang .doLang
    toplevel $wlang
    wm title $wlang $ms212 ;     wm geometry $wlang -40-80
    set wut3 $wlang.row3      ; set wmsg  $wut3.messages
#    wm geometry $wcf 459x100+824+216  ???

    set ft00 "helvetica 12 italic"
#
#   Radio-Buttons for language selection
    set wlangs $wlang.selLanguage
    labelframe  $wlangs -text "Dialog-Modus:" -padx 4 -pady 4
    radiobutton $wlangs.b0 -text "default" -anchor w -relief flat \
      -variable lang -value "-default" -command "checkLang -default $wmsg"
    radiobutton $wlangs.b1 -text "deutsch"   -anchor w -relief flat \
      -variable lang -value "-de" -command "checkLang -de $wmsg"
    radiobutton $wlangs.b2 -text english  -anchor w -relief flat \
      -variable lang -value "-en" -command "checkLang -en $wmsg"
    radiobutton $wlangs.b3 -text espanol -anchor w -relief flat \
      -variable lang -value "-es" -command "checkLang -es $wmsg"
    radiobutton $wlangs.b4 -text Test -anchor w -relief flat \
      -variable lang -value "-test" -command "checkLang -test $wmsg"
    pack $wlangs.b0  $wlangs.b1 $wlangs.b2 $wlangs.b3  $wlangs.b4 -pady 4 -anchor w
    checkBut $wlangs ;# set invalid buttons in italics
#
#  Bottom row: Info + return button (variables wbot, wbut1,2 are global!)
#
    frame  $wut3            ; frame  $wmsg  -padx 4 -pady 4
    label  $wmsg.msg0 -text "" -anchor w -pady 2
    label  $wmsg.msg1 -text "" -anchor w -pady 2
    label  $wmsg.msg2 -text "" -anchor w -pady 2
    pack   $wmsg.msg2 $wmsg.msg1 $wmsg.msg0  -pady 4 -padx 16 -side bottom
#
#  buttons: next-level windows + return
#
    set wbut $wut3.buttons
    labelframe  $wbut -text $ms218  -padx  4 -pady 4
    button $wbut.b0   -text $ms219  -width 9 -command "getUtildir $wlang"
    button $wbut.b1   -text $ms70  -width 9 -command "quitLang $wlang"
    pack   $wbut.b0  $wbut.b1 -side left
    pack  $wmsg  $wbut  -pady 2 -padx 4 -side left
#
#  pack 3 rows and configure the colours + fonts
#
    pack $wlangs $wut3 -pady 6 -padx 6
#
#
    setColor $wlang -background $bgcolor
    setColor $wlang -foreground $fgcolor
    setColor $wlang -activebackground $actcolor
#    if { $offbut } {
#      $wbut1.qhlp  configure -bg $offcolor ;  $wbut2.qscn configure -bg $offcolor
#    } ;# end if offbut
    tkwait window $wlang
  } ;#  end proc. doLang
#
#
#   Proc. quitTimes { } terminates die doTimes-Prozedur
#
proc quitLang { wlang } {
#    $tab selection set $sel($tan) ;# sicherstellen, dass Selection gesetzt ist
    destroy $wlang                         ;# Einstell-Fenster loeschen
  } ;# end proc.quitLang
#
#*************************************************************************************************
# Prozedur checkBut { wlangs } sets the font for language buttons
#*************************************************************************************************
#
proc checkBut  { wlangs } {
    global dutil lang tmsg f1
#
    update
    set ft00 "helvetica 12 italic"
    if { [file exists $dutil/$tmsg-de  ] } { $wlangs.b0 configure -font $f1
                                         } else { $wlangs.b0 configure -font $ft00 }
    if { [file exists $dutil/$tmsg-en  ] } { $wlangs.b1 configure -font $f1
                                         } else { $wlangs.b1 configure -font $ft00 }
    if { [file exists $dutil/$tmsg-es  ] } { $wlangs.b2 configure -font $f1
                                         } else { $wlangs.b2 configure -font $ft00 }
    if { [file exists $dutil/$tmsg-test ] } { $wlangs.b3 configure -font $f1
                                         } else { $wlangs.b3 configure -font $ft00 }
    saveConfig      ;#  fmsg abspeichern
  } ;#  end proc. checkBut
#
#*************************************************************************************************
# Prozedur checkLang { lang wmsg } creates the language info
#*************************************************************************************************
#
proc checkLang  { lang wmsg } {
    global dutil thelp tmsg fhelp fmsg f1
#
    update
    set ft00 "helvetica 12 bold normal"
    set fhelp $dutil/$thelp$lang ; set fmsg $dutil/$tmsg$lang
#
    if { $lang == ".de" } {
      if { [file exists $fmsg ] } {
        $wmsg.msg0 configure -font $f1 -text "Übergang zu $fmsg"
      } else {
        $wmsg.msg0 configure -font $f1 -text "Kann Datei $fmsg nicht finden!"
      }
      $wmsg.msg1 configure -font $f1 -text "Mehr Info in der Datei tecla-readme."
      $wmsg.msg2 configure -font $f1 -text "Bitte teclasat neu starten."
    } ;# end if lang = .de
#
    if { $lang == ".en" } {
      if { [file exists $fmsg ] } { $wmsg.msg0 configure -font $f1 -text "*leer!!*"
      } else {
        $wmsg.msg0 configure -font $f1 -text "Cannot find  $fmsg"
      }
      $wmsg.msg1 configure -font $f1 -text "For more info pls read file tecla-readme."
      $wmsg.msg2 configure -font $f1 -text "Pls restart program teclasat."
    } ;# end if lang = .de
#
    if { $lang == ".es" } {
      if { [file exists $fmsg ] } {
        $wmsg.msg0 configure -font $f1 -text "Pasando a $fmsg"
      } else {
        $wmsg.msg0 configure -font $f1 -text "No puedo abrir $fmsg"
      }
      $wmsg.msg1 configure -font $f1 \
                           -text "Mas informacion en el fichero tecla-readme."
      $wmsg.msg2 configure -font $f1 -text "Reinicie teclasat por favor."
    } ;# end if lang = .de
#
    if { $lang == ".txt" } {
      if { [file exists $fmsg ] } {
        $wmsg.msg0 configure -font $f1 -text "Going to use file $fmsg"
      } else {
        $wmsg.msg0 configure -font $f1 -text "Cannot find $fmsg"
      }
      $wmsg.msg1 configure -font $f1 -text "For more info pls read file tecla-readme."
      $wmsg.msg2 configure -font $f1 -text "Pls restart program teclasat."
    } ;# end if lang = .de
    saveConfig      ;#  fmsg abspeichern
  } ;#  end proc. checkLang
#
#*************************************************************************************************
# Prozedur getUtildir {} gets the name of the utility files (fhelp etc)
#*************************************************************************************************
#
proc getUtildir  { wlang } {
    global dutil dutil2 lang thelp tmsg fhelp fmsg ms241
#
    set dir0 $dutil
    if {![file isdirectory $dir0]} {set dir0 $dutil2 ; catch [exec mkdir -p $dir0 ]}
#  Auswahl der Ausgabedatei
    set fil [tk_chooseDirectory -initialdir $dir0 -title $ms241 -parent $wlang ]
    if { $fil == "" } { return } ;# aborted
    set dutil $fil
    set fhelp $dutil/$thelp$lang ; set fmsg $dutil/$tmsg$lang
    saveConfig      ;#  fmsg abspeichern
  } ;#  end proc. getUtildir
#
#*************************************************************************************************
# Prozedur doColor {} macht den Dialog fuer die Farbenwahl
#*************************************************************************************************
#
proc doColor  {} {
    global wcolors bgcolor fgcolor actcolor font
    global cbut1 cbut2 cbut3 cbut4 offbut offcolor
    global ms70 ms51 ms53 ms54 ms55 ms56 ms57 ms58 ms59 ms60 ms61 ms62 ms63 ms161
#
    set    wcol .doColor
    if { [winfo exists $wcol ] } {
      tk_messageBox -type ok -icon info -message $ms161  ; return }
    toplevel $wcol
    wm title $wcol "TeclaSat: $ms53"
#
    set    wcon $wcol.config
    frame $wcon  -padx 2 -pady 2
#
    set    wcos $wcol.colors
    labelframe $wcos -text "$ms53:"
    set wsel $wcos.select ; set wcolors $wsel.scales ; set wshow $wsel.show
    frame  $wsel
    frame  $wcolors
    frame  $wshow -bd 4
#  wshow = right frame: shows the selected colour
    label $wshow.msg1 -font $font -justify left -text "$ms55:" -width 12
    label $wshow.msg2 -font $font -justify left -text ""
    set    wdisp $wshow.disp
    frame  $wdisp -height 3c -width 1c ;#  frame to display the selected colour
    pack $wshow.msg1 $wshow.msg2 $wdisp
#  wcolors = left frame: scales to select the colour
    scale $wcolors.red   -label $ms60 -from 0 -to 255 -length 10c -orient horizontal \
                                   -command "readColor  $wcolors $wshow.msg2 $wdisp"
    scale $wcolors.green -label $ms61 -from 0 -to 255 -length 10c -orient horizontal \
                                   -command "readColor  $wcolors $wshow.msg2 $wdisp"
    scale $wcolors.blue  -label $ms62 -from 0 -to 255 -length 10c -orient horizontal \
                                   -command "readColor  $wcolors $wshow.msg2 $wdisp"
    pack $wcolors.red $wcolors.green $wcolors.blue  -side top
    scan $bgcolor "#%02x%02x%02x" col1 col2 col3
    $wcolors.red set $col1 ; $wcolors.green set $col2 ; $wcolors.blue set $col3

#  wcob = buttons to set the colour
    set      wcob  $wcos.colorbuttons
    frame   $wcob
    button  $wcob.b0 -text $ms56  -width 9 -command "makeColor 0"
    button  $wcob.b1 -text $ms57  -width 9 -command "makeColor 1"
    button  $wcob.b2 -text $ms58  -width 9 -command "makeColor 2"
    button  $wcob.b3 -text $ms59  -width 9 -command "makeColor 3"
    pack    $wcob.b0 $wcob.b1 $wcob.b2 $wcob.b3 -side left -padx 12
#  pack the colour selection
    pack $wcolors  -side left
    pack $wshow -side left -pady 6
    pack $wsel -padx 8
    pack $wcob -pady 8
    pack $wcos -padx 8 -pady 8 -side top
#
#  Bottom: Info + return button
#
    set    wbot  $wcol.bottom ; set   wmsg $wbot.messages ; set wbut $wbot.buttons
    frame  $wbot
    frame  $wmsg  -padx 4 -pady 4
    label  $wmsg.msg0 -text "" -anchor e -pady 4
    label  $wmsg.msg1 -text "" -anchor e -pady 4
    label  $wmsg.msg2 -text "" -anchor e -pady 4
    label  $wmsg.msg3 -text "" -anchor e -pady 4
#
    frame  $wbut  -padx 4 -pady 4
    button $wbut.b0   -text $ms70  -width 9 -command "quitColor $wcol"
    button $wbut.b1   -text $ms63  -width 9 -command "defaultColor"
    pack   $wmsg.msg3 $wmsg.msg2 $wmsg.msg1 $wmsg.msg0 -side bottom -anchor e
    pack   $wbut.b0 $wbut.b1  -pady 6 -padx 4 -side bottom -anchor se
    pack   $wmsg $wbut -pady 2 -padx 36 -fill y -side left
    pack   $wbot -pady 8 -padx 8 -side top
#
    set ft01 "Courier 12 bold"
    $wmsg.msg0 configure -font $ft01 -text "$ms55 $ms56  = $bgcolor"
    $wmsg.msg1 configure -font $ft01 -text "$ms57  = $fgcolor"
    $wmsg.msg2 configure -font $ft01 -text "$ms58 = $actcolor"
    $wmsg.msg3 configure -font $ft01 -text "$ms59  = $offcolor"
#
#   Einfaerben
#
    setColor $wcol -background $bgcolor
    setColor $wcol -foreground $fgcolor
    setColor $wcol -activebackground $actcolor
if {0} { ,#########################################################################
    if { $offbut } {
      $cbut1.off  configure -bg $offcolor ;     $cbut1.vtq  configure -bg $offcolor
      $cbut1.epq  configure -bg $offcolor ;     $cbut2.stop configure -bg $offcolor
      $cbut3.coff configure -bg $offcolor ;     $cbut3.comp configure -bg $offcolor
      $cbut4.qscn configure -bg $offcolor ;     $cbut4.qhlp configure -bg $offcolor
    } ;# end if offbut
} ;#################################################################################
    tkwait window $wcol
  } ;#  end proc. doColor
#
#   Proc. quitColor { } terminates die doColor-Prozedur
#
proc quitColor { wcol } {
#    $tab selection set $sel($tan) ;# sicherstellen, dass Selection gesetzt ist
    destroy $wcol                          ;# Einstell-Fenster loeschen
  } ;# end proc.quitColor
#
#
#*************************************************************************************************
proc dummyscan {} {
         tk_messageBox -type ok -parent .doScan -message "Leider noch nicht fertig." }
#*************************************************************************************************
#
#
#*************************************************************************************************
#  proc. configScan { } initializes the scan procedure 'Suchlauf einrichten'
#*************************************************************************************************
#
proc configScan { } {
    global tic1 tic2 tic3 tic4 xtsc xdsc xtsr xdsr xmsg
    global ms70  ms242 ms244 ms245 ms248 ms452 ms453 ms454 ms456 ms457 ms458 ms459
    global ms460 ms461 ms462 ms464 ms465 ms466 ms467 ms468 ms472 ms504 ms539 ms604
#
    set wscan .configScan ; if { [winfo exists $wscan ] } { catch { destroy $wscan } }
    toplevel $wscan ; wm geometry $wscan -40-80
    wm title $wscan $ms452 ; quitConfig
#
#  smode=1 (listmode), 2 (dvb-mode), 3 (manual)
    set wscan1 $wscan.t      ; frame $wscan1
    set wsmod $wscan1.f0     ; labelframe $wsmod -text $ms464
    radiobutton $wsmod.b0 -width 12 -text $ms248 -variable smode -value 2 \
                   -anchor w -relief flat -command "doScanmode"
    radiobutton $wsmod.b1 -text $ms245 -variable smode -value 1 \
                   -relief flat -command "doScanmode"
    radiobutton $wsmod.b2 -text $ms472 -variable smode -value 3 \
                   -relief flat -command "doScanmode"
    pack $wsmod.b0 $wsmod.b1 $wsmod.b2 -anchor w -padx 4
#
# "Kennwerte": display the main control values
    set winfoc $wscan1.f1     ; labelframe  $winfoc -text $ms453 ;# Kennwerte
    set winfoct $winfoc.left  ; frame $winfoct
    set winfocv $winfoc.right ; frame $winfocv
    label $winfoct.m1 -width 10 -anchor e -text $ms454
    label $winfoct.m3 -width 10 -anchor e -text $ms456
    label $winfoct.m4 -width 10 -anchor e -text $ms457
    label $winfocv.m1 -width 10 -anchor w -textvariable tic1
    label $winfocv.m3 -width 10 -anchor w -textvariable tic3
    label $winfocv.m4 -width 10 -anchor w -textvariable tic4
    pack $winfoct.m1 $winfoct.m3 $winfoct.m4 -anchor e
    pack $winfocv.m1 $winfocv.m3 $winfocv.m4 -anchor w
    pack $winfoct $winfocv -side left
    pack $winfoc $wsmod -side right -padx 6 -pady 4 -expand 1 -fill y
#
#  "Dateien": show the files + directories
    set winfof $wscan.f2 ; labelframe  $winfof -text $ms458
    set winfoft $winfof.left  ; frame $winfoft
    set winfofv $winfof.right ; frame $winfofv
    label $winfoft.m1 -text $ms459 ; label $winfofv.m1 -textvariable xtsc
    label $winfoft.m2 -text $ms460 ; label $winfofv.m2 -textvariable xdsc
    label $winfoft.m3 -text $ms461 ; label $winfofv.m3 -textvariable xtsr
    label $winfoft.m4 -text $ms460 ; label $winfofv.m4 -textvariable xdsr
    pack $winfoft.m1 $winfoft.m2 $winfoft.m3 $winfoft.m4 -anchor e
    pack $winfofv.m1 $winfofv.m2 $winfofv.m3 $winfofv.m4 -anchor w
    pack $winfoft $winfofv -side left -padx 4
#
#  Status messages
    set wsmes  $wscan.mesfield ; labelframe $wsmes
    set scames $wsmes.scames ; set xmsg "" ; label $scames -textvariable xmsg
    pack $scames
#
    set wsbut  $wscan.but   ; frame $wsbut
    set wsbut1 $wsbut.but1  ; labelframe $wsbut1 -text $ms462
#
    button $wsbut1.b0 -text $ms465 -width 9 -command "doScan"
    button $wsbut1.b1 -text $ms604 -width 9 -command "doEdit"
    button $wsbut1.b2 -text $ms70  -width 9 -command "quitScan"
    pack $wsbut1.b0 $wsbut1.b1 $wsbut1.b2
#
    set wsbut0 $wsbut.f0    ; labelframe $wsbut0 -text $ms539
    set wsbut2 $wsbut0.but2 ; frame $wsbut2
    set wsbut3 $wsbut0.but3 ; frame $wsbut3
    button $wsbut2.b0 -text $ms467 -width 9 -command "doHelp"
    button $wsbut2.b1 -text ""     -width 9 -command ""
    button $wsbut2.b2 -text $ms242 -width 9 -command "destroy $wscan ; consat"
    pack $wsbut2.b0 $wsbut2.b1 $wsbut2.b2
#
    button $wsbut3.b0 -text $ms244 -width 9 -command "scanParms"
    button $wsbut3.b1 -text $ms504 -width 9 -command "getScanresult $wscan"
    button $wsbut3.b2 -text $ms468 -width 9 -command "initScanParms"
    pack $wsbut3.b0 $wsbut3.b1 $wsbut3.b2
    pack $wsbut2 $wsbut3 -side right -padx 2 -pady 2
    pack $wsbut1 $wsbut0 -side right -padx 2 -pady 2
#
#  pack the main frames alltogether
    pack $wsbut -side bottom -padx 40 -pady 4
    pack $wsmes $winfof -side bottom -padx 8 -pady 4 -expand 1 -fill x
    pack $wscan1 -side bottom -expand 0
  } ;# end proc.configScan
#
#*************************************************************************************************
#  proc. quitScan terminates the scan windows                                         *
#**************************************************************************************
proc quitScan {} {
    catch {destroy .doScan} ; catch {destroy .doEdit} ; catch {destroy .configScan}
  } ;# end proc. quitScan
#
#*************************************************************************************************
#  proc. scanParms switches to the sub-procedures: set scan parameters                *
#*************************************************************************************************
proc scanParms {} {
    global smode
    update ; catch { destroy .configScan } ;# smode: 1=list, 2=dvb, 3=manual
    switch $smode { 1 confliscan 2 confdvbscan 3 confManscan } ; saveConfig
  } ;# end proc. scanParms
#
#*************************************************************************************************
#  proc. doScanmode supports the change of scan mode                                  *
#*************************************************************************************************
proc doScanmode {} {
    global smode flscan fdscan xtsc xdsc  tic2 scantrap ms470 ms471 ms472 ms479
    update ; switch $smode {
    1 { set xtsc [file tail $flscan]; set xdsc [file dirname $flscan]; set tic2 $ms470}
    2 { set xtsc [file tail $fdscan]; set xdsc [file dirname $fdscan]; set tic2 $ms471}
    3 { set xtsc $scantrap  ; set xdsc $ms479; set tic2 $ms472 }
    } ;# end switch
    saveConfig
  } ;# end proc. doScanmode
#
#*************************************************************************************************
# proc.initScanParms {} installs the default scan parameters                          *
#*************************************************************************************************
#
proc initScanParms { } {
#   smode:  1 = list; 2 = dvb; 3 = manual
    global fdvb1 fdvb2 fdscan flscan fscres
    global smode xsat1 xsat2 xdvb1 xdvb2 xtsr xdsr tic1 tic2 tic3 tic4 xtsc xdsc
    global scantrap xtsc xdsc clif fmylis ms220 ms221
#
    set tic1 dvb-s ;  set tic3 "fta"   ; set tic4 $ms220
    set scantrap "Trp.93:12266:h:0:27500"
    if { $smode == 3 } { set smode 1 }  ; doScanmode
    set xtsr [file tail $fscres]        ; set xdsr [file dirname $fscres]
    set xdvb1  [ file tail $fdvb1 ]     ; set pos [ string first "-" $xdvb1 ]
    set xsat1  [ string tolower [ string range $xdvb1 0 [ expr $pos -1 ]]]
    set xdvb2  [ file tail $fdvb2 ]     ; set pos [ string first "-" $xdvb2 ]
    set xsat2  [ string tolower [ string range $xdvb2 0 [ expr $pos -1 ]]]
  } ;# end proc.initScanParms
#
#*************************************************************************************************
#  proc. confliscan { } configures the list scan                                      *
#*************************************************************************************************
#
proc confliscan { } {
    global clif fdvb1 fdvb2 xdvb1 xdvb2 xsat1 xsat2 dlif
    global smode scansig scansat fta tra sigtyp xtsc xtsc xdsc
    global tic1 tic2 tic3 tic4 fdvb1 fdvb2 xdvb1 xdvb2 xsat1 xsat2 ms70
    global ms101 ms161 ms222 ms224 ms243 ms246 ms247 ms256 ms257 ms258 ms259 ms260
    global ms261 ms262 ms263 ms264 ms267 ms343 ms347 ms417 ms458 ms459 ms460 ms613
#
    set fex1 .confliscan ; if { [winfo exists $fex1 ]} {catch { destroy .confliscan }}
    toplevel $fex1 ; wm title $fex1 $ms224 ; wm geometry $fex1 -40-80
#   "Signalquelle": Radio-Buttons for selection of signal source
    set fex1u $fex1.upper ; frame $fex1u
    set wsig $fex1u.sig ;  labelframe $wsig -text $ms343 -padx 4
    radiobutton $wsig.b0 -width 10 -text "dvb-s" -variable scansig -value s \
                   -anchor w -relief flat -command "set tic1 \"dvb-s\""
    radiobutton $wsig.b1 -text "dvb-t" -variable scansig -value t \
      -anchor w -relief flat -command "set tic1 \"dvb-t\""
    radiobutton $wsig.b2 -text "dvb-c" -variable scansig -value c \
      -anchor w -relief flat -command "set tic1 \"dvb-c\""
    pack $wsig.b0 $wsig.b1 $wsig.b2 -pady 2 -anchor w
#
#  "Sat Nr.": sat nbr. for scan input
    set wsat   $fex1u.sat ; labelframe $wsat -width 40m -text $ms347 -padx 4
    radiobutton $wsat.b0 -width 10 -text $ms246 -variable scansat -value 0 \
                                                -anchor w -relief flat
    radiobutton $wsat.b1 -text $ms247 -variable scansat -value 1 \
                                                -anchor w -relief flat
    radiobutton $wsat.b2 -text $ms243 -variable scansat -value -1 \
                                                -anchor w -relief flat
    pack $wsat.b2 $wsat.b0 $wsat.b1 -pady 2 -anchor w
    pack $wsig $wsat -side left -padx 6
#
#  "Suchliste": radiobuttons to select the scanlist file (e.g.astra-list1) or other
    set lin $fex1.lin ; labelframe $lin -text $ms417 -padx 4
    set lin1 $lin.f1 ; frame $lin1
#
    set suflist { -list0 -list1 -list2 } ; set nbrlist "" ; set lili "" ; set clin 0
    foreach satn { 1 2 } {
      set dvbx [file tail [expr "\$fdvb$satn"]] ;# e.g. 'Astra-13.2E'
      if { [ catch { string first "-" $dvbx } pos ] } { continue } ;# find 1st '-' in name
      set satx [ string tolower [ string range $dvbx 0 [ expr $pos -1 ]]] ;# e.g. 'astra'
      if { ![ string length $satx ] } { continue } ;# empty name: ignore
#
      set lin1x "$lin1.f$satn" ;  frame $lin1x
      foreach sufnbr { 0 1 2 } { set fil "$dlif/$satx[lindex $suflist $sufnbr]"
        if { [ file exists $fil ] } { lappend nbrlist $sufnbr ; incr clin
          set lina "$satx[lindex $suflist $sufnbr]" ; lappend lili $lina ;# e.g. astra-list1
          radiobutton $lin1x.b$clin -text $lina -variable clif -value $clin \
                   -relief flat -command "setclif $lina"
          pack $lin1x.b$clin
        } ;# if listfile exists
      } ;# foreach sufnbr
    pack $lin1x -side left -padx 16
    } ;# foreach satx
#  "andere Datei"
    set lin2 $lin.f2 ; labelframe $lin2
    radiobutton $lin2.b1 -text $ms613 -variable clif -value 0 -width 13 -anchor w \
      -relief flat  -command "setclif dum"
    button $lin2.b2  -text $ms101 -width 9 -command "getScanctrl 0 $fex1"
    pack $lin2.b1 -side left  -anchor w
    pack $lin2.b2 -side right -anchor e
#
#  "Suchliste": show the list file + directories
    set lin3 $lin.f3 ; frame  $lin3 ;#-text $ms458
    set lin3a $lin3.fa  ; frame $lin3a ; set lin3b $lin3.fb  ; frame $lin3b
    label $lin3a.m1 -text $ms459 ; label $lin3b.m1 -textvariable xtsc
    label $lin3a.m2 -text $ms460 ; label $lin3b.m2 -textvariable xdsc
    pack $lin3a.m1 $lin3a.m2 -anchor e ; pack $lin3b.m1 $lin3b.m2 -anchor w
    pack $lin3a $lin3b -side left
    pack $lin1 $lin2 $lin3
#
#   "Auswahl": Radio-Buttons zur Auswahl der Selektion: -x0 = nur FTA, -x1 = alle
    set fex1b $fex1.bottom ; frame $fex1b
    set wfta  $fex1b.fta ; labelframe $wfta -text $ms256 -padx 4 ;  set fta "-x0"
    set wftac $wfta.c ; frame $wftac
    radiobutton $wftac.b0 -text $ms257 -variable fta  -value "-x0" \
      -width 10    -anchor w -relief flat -command "set tic3 \"fta\""
    radiobutton $wftac.b1 -text $ms258 -variable fta  -value "-x1" \
          -anchor w -relief flat -command "set tic3 \"alle\""
    pack $wftac.b0 $wftac.b1 -side top -pady 2 -anchor w
    pack $wftac -anchor c
#
#   "Dienste": Radio-Buttons zur Auswahl des Programm-Modus (Radio,TV,etc)
    set wtra $fex1b.tra ; labelframe $wtra -text $ms259 -width 18 -padx 4
    radiobutton $wtra.b0 -text $ms262 -variable tra  -value "-t3" \
      -anchor w -relief flat  -command "set tic4 \"TV+Radio\""
    radiobutton $wtra.b1 -text $ms260 -variable tra  -value "-t1" \
      -width 10 -anchor w -relief flat -command "set tic4 \"nur TV\""
    radiobutton $wtra.b2 -text $ms261 -variable tra  -value "-t2" \
      -anchor w -relief flat -command "set tic4 \"nur Radio\""
    radiobutton $wtra.b3 -text $ms263 -variable tra  -value "-t4" \
      -anchor w -relief flat -command "set tic4 \"sonst.\""
    radiobutton $wtra.b4 -text $ms264 -variable tra -value "-t7" \
       -anchor w -relief flat -command "set tic4 \"alle\""
    pack $wtra.b0 $wtra.b1 $wtra.b2 $wtra.b3 $wtra.b4 -side top -anchor w
    pack $wfta $wtra -side left -expand 1 -fill y -padx 6
#
    set but $fex1.but ; frame $but
    button $but.b0 -text $ms70 -width 9 -command "destroy $fex1 ; configScan"
    pack $but.b0
#
    pack $but $fex1b $lin $fex1u -side bottom -padx 16 -pady 4
  } ;# end proc. confliscan
#
#*************************************************************************************************
#  proc. setclif sets the list file for confliscan                                    *
#*************************************************************************************************
proc setclif { lina } {
    global clif dlif fmylis xtsc xdsc
    if { $clif } { set flscan $dlif/$lina } else { set flscan $fmylis }
    set xtsc [ file tail $flscan ] ; set xdsc [ file dirname $flscan ] ; saveConfig
  } ;# end proc. setclif
#
#*************************************************************************************************
#  proc. confdvbscan { } configures the dvb scan    'dvb-Suchlauf einrichten'         *
#*************************************************************************************************
#
proc confdvbscan { } {
    global smode scansig scansat fta tra sigtyp
    global tic1 tic2 tic3 tic4 fdvb1 fdvb2 xdvb1 xdvb2 xsat1 xsat2
    global ms70  ms101 ms161 ms243 ms246 ms247 ms252 ms253 ms256 ms257 ms258 ms259
    global ms260 ms261 ms262 ms263 ms264 ms267 ms343 ms347 ms459 ms460 ms613
#
    set wdvb .confdvbscan ; if { [winfo exists $wdvb ]} {catch { destroy $wdvb }}
    toplevel $wdvb ; wm title $wdvb $ms252 ; wm geometry $wdvb -40-80
# signal source: dvb-s, dvb-t, dvb-c
    set wdvbu $wdvb.upper ; frame $wdvbu
    set wsig $wdvbu.sig ;  labelframe $wsig -text $ms343 -padx 4
    radiobutton $wsig.b0 -width 10 -text "dvb-s" -variable scansig -value s \
      -anchor w -relief flat -command "set tic1 \"dvb-s\""
    radiobutton $wsig.b1 -text "dvb-t" -variable scansig -value t \
      -anchor w -relief flat -command "set tic1 \"dvb-t\""
    radiobutton $wsig.b2 -text "dvb-c" -variable scansig -value c \
      -anchor w -relief flat -command "set tic1 \"dvb-c\""
    pack $wsig.b0 $wsig.b1 $wsig.b2 -pady 2 -anchor w
#
#  "Sat Nr.": sat nbr. for scan input
    set wsat   $wdvbu.sat ; labelframe $wsat -text $ms347 -padx 4
    radiobutton $wsat.b0 -width 10 -text $ms246 -variable scansat -value 0 \
                                      -width 8 -anchor w -relief flat
    radiobutton $wsat.b1 -text $ms247 -variable scansat  -value 1 \
                                      -width 8 -anchor w -relief flat
    radiobutton $wsat.b2 -text $ms243 -variable scansat  -value -1 \
                                      -width 8 -anchor w -relief flat
    pack $wsat.b2 $wsat.b0 $wsat.b1 -pady 2 -anchor w
    pack $wsig $wsat -side left -padx 6
#
#  Suchmodus: Suchdatei; define name of scan ctrl-file for dvb-mode
    set dfi $wdvb.dfi ; labelframe $dfi -text $ms253 -padx 4  ;# $ms417 ???
    set dfi1 $dfi.f1 ; frame $dfi1
#: radiobuttons to select the dvb file (e.g.Astra-13.2E) or other
    radiobutton $dfi1.b0 -text $xdvb1 -variable cdvb -value 1 -width 13 -anchor w \
      -relief flat  -command "setcdvb $xdvb1" ;# sat #0
    radiobutton $dfi1.b1 -text $xdvb2 -variable cdvb -value 2 -width 13 -anchor w \
      -relief flat  -command "setcdvb $xdvb2" ;# sat #1
    pack $dfi1.b0 $dfi1.b1
#  "andere Datei"
    set dfi2 $dfi.f2 ; labelframe $dfi2
    radiobutton $dfi2.b2 -text $ms613 -variable cdvb -value 0 -width 13 -anchor w \
      -relief flat  -command "setcdvb dum"
    button $dfi2.but2  -text $ms101 -width 9 -command "getScanctrl 3 $wdvb"
    pack $dfi2.b2 -side left  -anchor w
    pack $dfi2.but2 -side right -anchor e
#  "Suchliste": show the active dvb-file (file + directory)
    set dfi3 $dfi.f3 ; frame  $dfi3 ;#-text $ms458
    set dfi3a $dfi3.fa  ; frame $dfi3a ; set dfi3b $dfi3.fb  ; frame $dfi3b
    label $dfi3a.m1 -text $ms459 ; label $dfi3b.m1 -textvariable xtsc
    label $dfi3a.m2 -text $ms460 ; label $dfi3b.m2 -textvariable xdsc
    pack $dfi3a.m1 $dfi3a.m2 -anchor e ; pack $dfi3b.m1 $dfi3b.m2 -anchor w
    pack $dfi3a $dfi3b -side left
    pack $dfi1 $dfi2 $dfi3
#
#   "Auswahl": Radio-Buttons zur Auswahl der Selektion: -x0 = nur FTA, -x1 = alle
    set wdvbb $wdvb.bottom ; frame $wdvbb
    set wfta  $wdvbb.fta ; labelframe $wfta -text $ms256 -padx 4 ;  set fta  "-x0"
    set wftac $wfta.c ; frame $wftac
    radiobutton $wftac.b0 -text $ms257 -variable fta  -value "-x0" \
      -width 10    -anchor w -relief flat -command "set tic3 \"fta\""
    radiobutton $wftac.b1 -text $ms258 -variable fta  -value "-x1" \
          -anchor w -relief flat -command "set tic3 \"alle\""
    pack $wftac.b0 $wftac.b1 -side top -pady 2 -anchor w
    pack $wftac -anchor c
#
#   "Dienste": Radio-Buttons zur Auswahl des Programm-Modus (Radio,TV,etc)
    set wtra $wdvbb.tra ; labelframe $wtra -text $ms259 -width 18 -padx 4
    radiobutton $wtra.b0 -text $ms262 -variable tra  -value "-t3" \
      -anchor w -relief flat  -command "set tic4 \"TV+Radio\""
    radiobutton $wtra.b1 -text $ms260 -variable tra  -value "-t1" \
      -width 10 -anchor w -relief flat -command "set tic4 \"nur TV\""
    radiobutton $wtra.b2 -text $ms261 -variable tra  -value "-t2" \
      -anchor w -relief flat -command "set tic4 \"nur Radio\""
    radiobutton $wtra.b3 -text $ms263 -variable tra  -value "-t4" \
      -anchor w -relief flat -command "set tic4 \"sonst.\""
    radiobutton $wtra.b4 -text $ms264 -variable tra -value "-t7" \
       -anchor w -relief flat -command "set tic4 \"alle\""
    pack $wtra.b0 $wtra.b1 $wtra.b2 $wtra.b3 $wtra.b4 -side top -anchor w
    pack $wfta $wtra -side left -expand 1 -fill y -padx 6
#
    set wdvbbut $wdvb.but ; labelframe $wdvbbut
    button $wdvbbut.b0 -text "OK" -width 9 -command "destroy $wdvb ; configScan"
    pack $wdvbbut.b0
    pack $wdvbu $dfi $wdvbb $wdvbbut -padx 4 -pady 4
  } ;# end proc.confdvbscan
#
#*************************************************************************************************
#  proc. setcdvb sets the dvb-scan file for confdvbscan                               *
#*************************************************************************************************
proc setcdvb { lina } {
    global fdscan cdvb dlif fmydvb xtsc xdsc
    update ; if { $cdvb } { set fdscan $dlif/$lina ; set xtsc $lina ; set xdsc $dlif
             }    else    { set fdscan $fmydvb ; set xtsc [file tail $fmydvb]
                            set xdsc [file dirname $fmydvb] } ;  saveConfig
  } ;# end proc. setcdvb
#
#*************************************************************************************************
#  proc. confManscan { } configures the manual scan (single transponder)              *
#*************************************************************************************************
#
proc confManscan { } {
    global smode scansig scansat scantrap fta tra sigtyp
    global tic1 tic2 tic3 tic4 xtsc xdsc
    global fdvb1 fdvb2 xdvb1 xdvb2 xsat1 xsat2
    global ms70  ms161 ms243 ms246 ms247 ms256 ms257 ms258 ms259
    global ms260 ms261 ms262 ms263 ms264 ms267 ms343 ms347 ms348
    global ms476 ms477 ms478 ms479 ms480 ms481 ms482 ms483 ms484
#
    set fex3 .confmanscan ; if { [winfo exists $fex3 ]} {catch { destroy $fex3 }}
    toplevel $fex3 ;  wm title $fex3 $ms478 ; wm geometry $fex3 -40-80
#
    set wsig $fex3.sig ;  labelframe $wsig -text $ms343 -padx 4
    radiobutton $wsig.b0 -text "dvb-s" -width 6 -anchor w -relief flat \
                                    -variable scansig -value s -command ""
    radiobutton $wsig.b1 -text "dvb-t" -width 6 -anchor w -relief flat \
                                    -variable scansig -value t -command "dummy"
    radiobutton $wsig.b2 -text "dvb-c" -width 6 -anchor w -relief flat \
                                    -variable scansig -value c -command "dummy"
    pack $wsig.b0 $wsig.b1 $wsig.b2 -pady 2 -anchor w
#
#  "Einzel-Transponder": manual entry: single transponder
    set wman $fex3.man ; labelframe $wman -text $ms348 -padx 4
    label $wman.msg0 -text $ms478 ;# "bitte eingeben:"
    label $wman.msg1 -text "name:frequ:v/h:sat#:rate"
    set scantrap "Trp.93:12266:h:0:27500"
    entry $wman.entry -relief sunken -bd 2 -textvariable scantrap -width 25
    pack $wman.msg0 $wman.msg1 $wman.entry -anchor w
#
#   "Auswahl": Radio-Buttons zur Auswahl der Selektion: -x0 = nur FTA, -x1 = alle
    set fex3b $fex3.bottom ; frame $fex3b
    set wfta  $fex3b.fta ; labelframe $wfta -text $ms256 -padx 4 ;  set fta  "-x0"
    set wftac $wfta.c ; frame $wftac
    radiobutton $wftac.b0 -text $ms257 -variable fta  -value "-x0" \
      -width 10    -anchor w -relief flat -command "set tic3 \"fta\""
    radiobutton $wftac.b1 -text $ms258 -variable fta  -value "-x1" \
          -anchor w -relief flat -command "set tic3 \"alle\""
    pack $wftac.b0 $wftac.b1 -side top -pady 2 -anchor w
    pack $wftac -anchor c
#
#   "Dienste": Radio-Buttons zur Auswahl des Programm-Modus (Radio,TV,etc)
    set wtra $fex3b.tra ; labelframe $wtra -text $ms259 -width 14 -padx 4
    radiobutton $wtra.b0 -text $ms262 -variable tra  -value "-t3" \
      -anchor w -relief flat  -command "set tic4 $ms480"
    radiobutton $wtra.b1 -text $ms260 -variable tra  -value "-t1" \
      -width 10 -anchor w -relief flat -command "set tic4 $ms481"
    radiobutton $wtra.b2 -text $ms261 -variable tra  -value "-t2" \
      -anchor w -relief flat -command "set tic4 $ms482"
    radiobutton $wtra.b3 -text $ms263 -variable tra  -value "-t4" \
      -anchor w -relief flat -command "set tic4 $ms483"
    radiobutton $wtra.b4 -text $ms264 -variable tra -value "-t7" \
      -anchor w -relief flat -command "set tic4 $ms484"
    pack $wtra.b0 $wtra.b1 $wtra.b2 $wtra.b3 $wtra.b4 -side top -anchor w
    pack $wfta $wtra -side left -expand 1 -fill y -padx 12
#
    set fex3but $fex3.but ; labelframe $fex3but
    button $fex3but.b0 -text "OK" -width 9 -command "quitManscan $fex3 ; configScan"
    pack $fex3but.b0
    pack $wsig $wman $fex3b -padx 16 -pady 4
    pack $fex3but -padx 2 -padx 2
    set xtsc $scantrap ; set xdsc $ms479
 } ;# end proc. confManscan
#
#*************************************************************************************************
#  proc quitManscan {}
#*************************************************************************************************
proc quitManscan { fram } {
    global xtsc xdsc scantrap
    destroy $fram ; set xtsc $scantrap
  } ;# end proc quitManscan
#
#*************************************************************************************************
#  proc. consat { } configures the files fdvb1+1  and defines the sat/area names
#*************************************************************************************************
#
proc consat { } {
    global ddvb1 ddvb2 dlif xsfit xsfid xtsr xdsr xdvb1 xdvb2 xsat1 xsat2
    global  ms16 ms70  ms101 ms161 ms265 ms266 ms268 ms269 ms270 ms272 ms331
    global ms460 ms486 ms487 ms488 ms489 ms490 ms491
    global ms492 ms493 ms494 ms495 ms496 ms499 ms501 ms502 ms503 ms504
#"Sat / Bereich einstellen" "andere Auswahl" "Sat / Bereich #0:" "Sat / Bereich #1:" "Name"
    set cos .consat ;  if { [winfo exists $cos ] } { destroy $cos }
    toplevel $cos ; wm title $cos $ms265 ; wm geometry $cos -40-240
#
    set wtab  $cos.tab ; labelframe $wtab -text $ms487
    set wtab1 $wtab.tab1 ; frame $wtab1
    set wcol1 $wtab1.c1 ; frame $wcol1 ;  set wcol2 $wtab1.c2 ; frame $wcol2
    set wcol3 $wtab1.c3 ; frame $wcol3
# column #1:  'Sat/Bereich'
    label $wcol1.m1 -text ""
    label $wcol1.m2 -text $ms268 ; label $wcol1.m3 -text $ms269
    pack  $wcol1.m1 $wcol1.m2 $wcol1.m3 -anchor w
# column #2:   sat-Name  (astra)
    label $wcol2.mh -text $ms16 -font {helvetica 10 underline bold}
    label $wcol2.m0 -textvariable xsat1 ;  label $wcol2.m1 -textvariable  xsat2
    pack $wcol2.mh $wcol2.m0 $wcol2.m1 -anchor w
# column #3:   dvb-file  (Astra-13.2E)
    label $wcol3.mh -text $ms489 -font {helvetica 10 underline bold}
    label $wcol3.m1 -textvariable xdvb1 ;  label $wcol3.m2 -textvariable xdvb2
    pack $wcol3.mh $wcol3.m1 $wcol3.m2 -anchor w
    pack  $wcol1 $wcol2 $wcol3 -side left -padx 20
#  show directories of dvb1+dvb2-files
    set wtab2 $wtab.tab2 ; frame $wtab2
    set wtab2a $wtab2.fa ; frame $wtab2a ; set wtab2b $wtab2.fb ; frame $wtab2b
    label $wtab2a.m1 -text "#0 $ms460 " ; label $wtab2a.m2 -textvariable ddvb1
    label $wtab2b.m1 -text "#1 $ms460 " ; label $wtab2b.m2 -textvariable ddvb2
    pack $wtab2a.m1 $wtab2a.m2 -side left ; pack  $wtab2b.m1 $wtab2b.m2 -side left
    pack $wtab2a $wtab2b -side top -anchor w
    pack $wtab1 -side top -pady 2
    pack $wtab2 -side top -pady 8 -anchor w

#  "Standard-Suchlisten": directory for std.list files
    set wlid $cos.lid ; labelframe $wlid -text $ms270
    label $wlid.m1 -text "$ms490 "
    label $wlid.m2 -textvariable dlif
    pack  $wlid.m2 $wlid.m1 -side right -anchor e
#   buttons: #0, #1, directory, return
    set wbut $cos.but ; labelframe $wbut -text $ms266
    set wbut1 $wbut.f1 ; frame $wbut1 ; set wbut2 $wbut.f2 ; frame $wbut2
    button $wbut1.b0 -text "#0" -width 9 -command "getScanctrl 1 $cos"
    button $wbut1.b1 -text "#1" -width 9 -command "getScanctrl 2 $cos"
    button $wbut2.b2 -text $ms272 -width 9 -command "getdList $cos"
    button $wbut2.b3 -text $ms70  -width 9 -command "destroy $cos; configScan"
    pack   $wbut1.b1 $wbut1.b0 -side bottom ; pack   $wbut2.b3 $wbut2.b2 -side bottom
    pack $wbut2 $wbut1 -side right -padx 2 -pady 2 ; pack   $wbut -side bottom
    pack $wlid  $wtab -side bottom -expand 1 -fill x -pady 8 -padx 4
  } ;# end proc consat
#
#*************************************************************************************************
# Proc.getdList {wp} gets the directory of the standard list files (astra-list0,..)   *
#*************************************************************************************************
#
proc getdList  { wp } {
    global dlif ddvb1  ms499
    set d0 $dlif ; if {![file isdirectory $d0]} { set d0 $ddvb1 }
    set rep [tk_chooseDirectory -initialdir $d0 -title $ms499 -parent $wp ]
    if { $rep == "" } { return } ;# aborted
    set dlif $rep ;  saveConfig      ;#  save directory
  } ;#  end proc.getdlif
#
#*************************************************************************************************
#  proc.getScanctrl gets the scan control file; typ = list, sat#0, sat#1, dvb
#*************************************************************************************************
#
proc getScanctrl { typ wp } {
    global fdvb1 fdvb2 flscan fdscan fmylis fmydvb cdvb clif xsat1 xsat2 xtsc xdsc
    global xdvb1 xdvb2 ddvb1 ddvb2 tstam ms505 ms506 ms507 ms508
#  flg = 0: sat #0; = 1: sat '1 ; = 2 : 'andere Datei'
    switch $typ {
      0 { set d0 [file dirname $flscan] ; set t0 [file tail $flscan] ; set h0 $ms506}
      1 { set d0 [file dirname $fdvb1 ] ; set t0 [file tail $fdvb1 ] ; set h0 $ms508}
      2 { set d0 [file dirname $fdvb2 ] ; set t0 [file tail $fdvb2 ] ; set h0 $ms508}
      3 { set d0 [file dirname $fdscan] ; set t0 [file tail $fdscan] ; set h0 $ms507}
      } ;# switch
    if { ![file isdirectory $d0] } { catch [exec mkdir -p $d0] }
    if { ![file isdirectory $d0] } { set d0 [file dirname $fdvb0  ] }
#
    set rep [tk_getOpenFile -initialdir $d0 -initialfile $t0 -parent $wp -title $h0 ]
    if { $rep == "" } { return }
#
    set d1 [file dirname $rep ] ; set t1 [file tail $rep ]
    switch $typ {
      0 { set flscan $rep ; set fmylis $rep ; set clif 0 }
      1 -
      2 { set err [ catch {string first "-" $t1} pos ]
          if { $err } { Err0 $ms505 1 "getScanctrl" ; return } ; set cdvb 0
          set xsat$typ  [ string tolower [ string range $t1 0 [ expr $pos -1 ]]]
          set xdvb$typ $t1 ; set ddvb$typ $d1 ; set fdscan $rep ; set fdvb$typ $rep }
      3 { set fdscan $rep  ; set fmydvb $rep ; set cdvb 0 }
      } ;# switch
    set xtsc $t1 ; set xdsc $d1 ; saveConfig
  } ;# end proc.getScanctrl
#
#*************************************************************************************************
#   proc. getScanresult gets the the file for the scan results
#*************************************************************************************************
#
proc getScanresult { wp } {
    global fscres xdsr xtsr home ms276 ms509
#
    set dir0 [file dirname $fscres ] ; set tail0 [file tail $fscres ]
    if {![string length $fscres ]} { set dir0 "$home/pctv/scan" }
    if {![file isdirectory $dir0]    } {
      set err [ catch { exec mkdir -p $dir0 } res ]
      if { $err } { Err0 "$ms509 \n$dir0" 1 "getScanresult" ; return }
    } ;# if dir0 not found
    set rep [tk_getSaveFile -initialdir $dir0 -initialfile $tail0 \
                                                    -parent $wp -title $ms276 ]
    if { $rep == "" } { return }
    set xtsr [file tail $rep] ; set xdsr [file dirname $rep]
    set fscres $rep ; saveConfig
  } ;# end proc. getScanresult
#
#*************************************************************************************************
#  proc.configShow controls the display mode for scan results                         *
#*************************************************************************************************
#
proc configShow {} {
    global shom0 shom1 shom2 shom3 shom4 shom5 shom6 shom7 shom8 shom9 shom10 shom11
    global shom12 shom13 shom14 shom15 sv1 sv2 sv3 sv4
    global ms70  ms161 ms364 ms370 ms371 ms372 ms373 ms374 ms376 ms377 ms414 ms416
    global ms417 ms510 ms511 ms512 ms513 ms514 ms515 ms516 ms517 ms518
#
    set fex5 .configshow
    if { [winfo exists $fex5 ] } {
                   tk_messageBox -type ok -icon info -message $ms161  ; return }
    toplevel $fex5 ; wm title $fex5 $ms364 ;   wm geometry $fex5 -400-80
    set wshow $fex5.cols ; labelframe $wshow
#
#  "Transponderdaten"
    set wcoll  $wshow.left
    labelframe $wcoll -text $ms510
    checkbutton $wcoll.b0 -width 18 -anchor w -text $ms511 -fg tan4\
                  -variable shom0  -command "doShom 0 old"
    checkbutton $wcoll.b12 -text $ms512 -fg brown\
                  -variable shom12 -command "doShom 12 ctl"
    checkbutton $wcoll.b14 -text $ms414 -fg darkblue -variable shom14 \
                                        -command "doShom 14 log"
    checkbutton $wcoll.b8  -text $ms513 -fg darkblue -variable shom8 \
                                        -command "doShom 8 fnd"
    pack $wcoll.b0 $wcoll.b12 $wcoll.b14 $wcoll.b8 -anchor w
#
#  "Suchergebnisse"
    set wcollb   $wcoll.b ;  labelframe  $wcollb -text $ms416
    checkbutton $wcollb.b1 -text $ms514 -fg darkgreen -variable shom1 \
                                        -command "doShom 1 conf"
    checkbutton $wcollb.b2 -text $ms515 -fg darkred   -variable shom2 \
                                        -command "doShom 2 new"
    checkbutton $wcollb.b3 -text $ms516 -fg darkcyan  -variable shom3 \
                                        -command "doShom 3 lost"
    checkbutton $wcollb.b4 -text $ms370 -fg black     -variable shom4 \
                                        -command "doShom 4 unt"
    pack $wcollb.b2 $wcollb.b1 $wcollb.b3 -anchor w
#
#  "Expertenmodus"
    set wcollc $wcoll.c ; labelframe  $wcollc -text $ms376
    checkbutton $wcollc.b9  -text $ms517 -fg violetRed1 -variable shom9 \
               -command "doShom 9 out1"
    checkbutton $wcollc.b10 -text $ms518 -fg magenta -variable shom10 \
               -command "doShom 10 out2"
    pack  $wcollc.b9 $wcollc.b10 -anchor w
    pack $wcollb $wcollc -expand 1 -fill x
#
# "ganze Listen"
    set wcolr $wshow.right ; frame $wcolr
    set wsho2 $wcolr.a ; labelframe $wsho2 -text $ms371
    checkbutton $wsho2.b7 -width 18 -anchor w -text $ms374 -fg black -variable shom7 \
               -command "doShom 7 untall"
    checkbutton $wsho2.b5 -text $ms372 -fg tan4    -variable shom5 \
               -command "doShom 5 oldall"
    checkbutton $wsho2.b13 -text $ms417 -fg brown -variable shom13 \
               -command "doShom 13 ctlall"
    checkbutton $wsho2.b15 -text $ms414 -fg darkblue -variable shom15 \
               -command "doShom 15 logall"
    checkbutton $wsho2.b6  -text $ms373 -fg darkblue -variable shom6 \
               -command "doShom 6 fndall"
    pack $wsho2.b7 $wsho2.b5 $wsho2.b13 $wsho2.b15 $wsho2.b6 -anchor w
    pack $wcoll $wcolr -side left -anchor n -expand 1 -fill y
    pack $wsho2 -anchor n -expand 1 -fill y
#
#  mark radio
    set wradio $fex5.radio ; labelframe $wradio
    checkbutton $wradio.b1 -text $ms377 -fg black -variable shom11 \
                                                       -command "markRadio"
    pack $wradio.b1
#
    set fex5but $fex5.but ; labelframe $fex5but
    button $fex5but.b0 -text $ms70 -width 9 -command "destroy $fex5"
    pack $fex5but.b0
#
    pack  $wshow $wradio $fex5but -side top
# pack  $wsho1 $wsho2 $wsho3 $wshow.b11 $fex5but ;#-anchor w -pady 2 -expand 1 -fill x
  } ;# end proc.configShow
#
#
#######################################################################################
#*************************************************************************************************
#  proc. doScan { } does the scan + displays the scan results                         *
#*************************************************************************************************
#
proc doScan { } {
    global smode stopflg
    global mod ms70 myVersion0 scantext f1 f3  fscres scantrap wblink skey
    global shom0 shom1 shom2 shom3 shom4 shom5 shom6 shom7 shom8 shom9 shom10 shom11
    global shom12 shom13 shom14 shom15 sv1 sv2 sv3 sv4
    global ms52  ms70  ms71  ms161 ms243 ms246 ms247 ms256 ms257 ms258 ms259
    global ms260 ms261 ms262 ms263 ms264 ms267 ms271 ms331 ms343 ms347 ms348
    global ms370 ms371 ms372 ms373 ms374 ms376 ms377 ms379 ms380 ms381 ms382
    global ms414 ms416 ms417 ms418 ms419 ms420 ms422 ms423 ms424 ms149 ms147
    global ms435 ms436 ms441 ms442 ms443 ms444 ms445 ms446 ms447 ms448 ms449
    global ms453 ms458 ms462 ms463 ms520 ms521 ms522 ms523 ms526 ms527
    global ms528 ms529 ms530 ms531 ms532 ms533 ms534 ms535 ms536 ms537 ms538
    global ms539 ms540 ms541 ms542 ms543 ms544 ms545 ms546 ms604
    global txtwd12 txtwd13 txtwd22 txtwd23 tic1 tic2 tic3 tic4
    global tstat1 tstat2 tstat3 tstat4 tstat5 xtsc xtsr tws1 tws2
    global confpath newpath lostpath untpath twsbut0 twsbut1 twsbut2 tstam
#
#"Suchlauf ausfuehren","Signal  = ","Modus   = ","Auswahl = ","Dienste = ",
#"Suchdatei = ","Ergebnis  = ","Anzeigen:","neue; ","bestätigte; ","entfallene;"
#"nicht-betroffene; ","alle gefundenen;","Suchbericht; ","Suchliste ; ","anderes"
#"Status","Einstellen","Vorauswahl","Anzeige","Auswerten","Ergebnis auswählen"
#"für Ergebnisdatei","Einstellbereich","einklappen"
    set stopflg 1 ;# stop on timeout + wait for keystroke
    if { $smode == 2 } { dvb-Scan ; return } ;# dvb-mode
    set wscan .doScan ; if { [winfo exists $wscan ] } { return } ;# ignore
    set ms811 $ms520
    toplevel $wscan ; wm title $wscan $ms811 ; wm geometry $wscan -40-80
#
#  text area
#
    set txt $wscan.text ;  set scantext $txt.t
    frame $txt
    text $scantext -width 65 -height 20 -wrap word \
            -xscrollcommand "$txt.xsbar set" -yscrollcommand "$txt.ysbar set"
    scrollbar $txt.xsbar -orient horizontal -command "$txt.t xview"
    scrollbar $txt.ysbar -orient vertical   -command "$txt.t yview"
    grid $scantext $txt.ysbar -sticky nsew
    grid $txt.xsbar -sticky nsew
    grid columnconfigure $txt 0 -weight 1
    grid rowconfigure    $txt 0 -weight 1
    $scantext configure -tabs 2.1i
#
#++++++++++++++++++++++++++++
    set wright $wscan.wright ; frame $wright
    set wsup  $wright.upper  ; frame $wsup
    set winfo $wsup.fram1    ; frame $winfo
#
# "Kenndaten": display the main control values
    set winfo1 $winfo.f1      ; labelframe $winfo1 -text $ms453
    set winfoct $winfo1.left  ; frame $winfoct
    set winfocv $winfo1.right ; frame $winfocv
    label $winfoct.m1 -text $ms521
    label $winfocv.m1 -width 10 -textvariable tic1 -anchor w
    label $winfoct.m2 -text $ms522 ; label $winfocv.m2 -textvariable tic2
    label $winfoct.m3 -text $ms523 ; label $winfocv.m3 -textvariable tic3
    label $winfoct.m4 -text $ms526 ; label $winfocv.m4 -textvariable tic4
    pack $winfoct.m1 $winfoct.m2 $winfoct.m3 $winfoct.m4 -anchor e
    pack $winfocv.m1 $winfocv.m2 $winfocv.m3 $winfocv.m4 -anchor w
    pack $winfoct $winfocv -side left -padx 2
#
#  "Dateien": show the files + directories
    set winfo2 $winfo.f2 ; labelframe  $winfo2 -text $ms458
    set winfofc $winfo2.c ; frame $winfofc
    set winfoft $winfofc.left  ; frame $winfoft
    set winfofv $winfofc.right ; frame $winfofv
    label $winfoft.m1 -text $ms527 ; label $winfofv.m1 -textvariable xtsc
#    label $winfoft.m2 -text "im Verzeichnis = " ; label $winfofv.m2 -textvariable xdsc
    label $winfoft.m3 -text $ms528 ; label $winfofv.m3 -textvariable xtsr
    pack $winfoft.m1 $winfoft.m3 -anchor e
    pack $winfofv.m1 $winfofv.m3 -anchor w
    pack $winfoft $winfofv -side left ; pack $winfofc -anchor c
#
#  show: "Anzeigen"
    set winfo3 $winfo.fra3 ; labelframe $winfo3 -text $ms529
    set wd1 $winfo3.f1 ; frame $wd1  ;# line 1
    label $wd1.m1 -text $ms530 ; label $wd1.m2 -text $ms531
    label $wd1.m3 -text  $ms532
    pack $wd1.m1 $wd1.m2 $wd1.m3 -side left
    set wd2 $winfo3.f2 ; frame $wd2  ;# line 2
    label $wd2.m1 -text $ms533 ; label $wd2.m2 -text $ms534
    pack $wd2.m1 $wd2.m2 -side left
    set wd3 $winfo3.f3 ; frame $wd3  ;# line 3
    label $wd3.m1 -text $ms535 ; label $wd3.m2 -text $ms536
    label $wd3.m3 -text $ms537
    pack $wd3.m1 $wd3.m2 $wd3.m3 -side left
    pack $wd1 $wd2 $wd3 -anchor w
    set wd  $winfo3.f  ;  colin $wd ;# set colors for the keywords
#
#  show: "Status"
    set winfo4 $winfo.fra4 ; labelframe  $winfo4 -text $ms538
    set ws1 $winfo4.f1 ; frame $ws1 ; set wblink $ws1.m2
    label $ws1.m1 -textvariable tstat1 ; label $ws1.m2 -textvariable tstat2
    label $ws1.m3 -textvariable tstat3 ; label $ws1.m4 -textvariable tstat4
    label $ws1.m5 -textvariable tstat5 ; label $ws1.m6 -textvariable tstat6
    pack $ws1.m1 $ws1.m2 $ws1.m3 $ws1.m4 $ws1.m5 -anchor w
    set ws2 $winfo4.f2 ; frame $ws2
    label $ws2.m1 -text "" ; label $ws2.m2 -textvariable ts2
    pack $ws2.m1 $ws2.m2
    pack $ws1 -anchor w
    pack $winfo1 $winfo2 -pady 4
    pack $winfo3 $winfo4 -pady 4 -expand 1 -fill x
#
#  fex: key for 'Speichermodus' (for test only)
#
    set fex0 $wsup.expert0 ; set fex $wsup.expert ; labelframe $fex0 -text $ms539
    button $fex0.b5 -text $ms540 -width 11 ;#-command "packFex 6 $fex $wlev"
    pack $fex0.b5
#
#  right frame: 'pegel' :  Pegel-Anzeige
#
    set wlev $wsup.level ; labelframe $wlev -text $ms271
    scale $wlev.scal   -label "" -length 6c -from 100000 -to 0 -orient vertical
    pack $wlev.scal -side left -anchor c
    showlevel $wlev.scal ;# show pegel
#
#*************************************************************************************************
#  Status messages
    set wsmes $wright.mesfield ; labelframe $wsmes
    set scames $wsmes.scames ; set tstam "" ; label $scames -textvariable tstam
    pack $scames
#
    set wsbut $wright.but    ; frame $wsbut
    set sabu   $wsbut.but
#
#  do scan: start/abort/continue/skip;
    set wsbut1 $wsbut.but1   ; labelframe $wsbut1 -text $ms462
    button $wsbut1.b0 -textvariable twsbut0 -width 9 -command "autoScan 2"
    button $wsbut1.b1 -textvariable twsbut1 -width 9 -command "reScan"
    button $wsbut1.b2 -textvariable twsbut2 -width 9 -command "skipScan"
    pack $wsbut1.b0 $wsbut1.b1 $wsbut1.b2
#
    set wsbut2 $wsbut.but2   ; labelframe $wsbut2 -text $ms463
    button $wsbut2.b0 -text ""     -width 9 -command ""
    button $wsbut2.b1 -text $ms541 -width 9 -command "configShow"
#    button $wsbut2.b2 -text "Vorauswahl" -width 9 -command "packFex 6 $fex $wlev"
    button $wsbut2.b2 -text "" -width 9 -command ""
    pack $wsbut2.b0 $wsbut2.b1 $wsbut2.b2
#
    set wsbut3 $wsbut.but3   ; labelframe $wsbut3 -text $ms71
    button $wsbut3.b0 -text $ms52  -width 9 -command "doHelp"
    button $wsbut3.b1 -text $ms604 -width 9 -command "doEdit"
    button $wsbut3.b2 -text $ms70  -width 9 -command "quitlistScan"
    pack $wsbut3.b0 $wsbut3.b1 $wsbut3.b2
    pack $wsbut3 $wsbut2 $wsbut1 -side right -padx 2 -pady 2
#
#  pack the main frames alltogether
#
    pack $winfo $wlev -side left -pady 4 -padx 4
    pack $wsup  -padx 2 -pady 8
    pack $wsbut -side bottom -padx 4 -pady 4
    pack $wsmes -side bottom -padx 4 -pady 4 -expand 1 -fill x
    pack $wright $txt -side right -expand 1 -fill y
#
#*************************************************************************************************
#   expert mode #6: "Speichermodus"
#   Radio-Buttons for selection of transponder types for the result file
#
    set fex6 $wsup.expert6 ; frame $fex6 ;# -text "expert6: Speichermodus"
    set wsave $fex6.bt ; frame $wsave
    set wsab $fex6.checkbut
#  select result classes to be saved: "Ergebnis auswaehlen"
    labelframe  $wsab -text $ms543
    label       $wsab.msg0 -text $ms544
    checkbutton $wsab.b1 -text $ms379 -fg darkgreen -variable sv1
    checkbutton $wsab.b2 -text $ms382 -fg black     -variable sv2
    checkbutton $wsab.b3 -text $ms380 -fg darkred   -variable sv3
    checkbutton $wsab.b4 -text $ms381 -fg darkcyan  -variable sv4
    pack $wsab.msg0 -anchor e -fill x -expand 1
    pack $wsab.b1 $wsab.b2 $wsab.b3 $wsab.b4 -anchor w
#
    set wdum $fex6.dum ; frame $wdum
    label $wdum.m1 ; label $wdum.m2 ; pack $wdum.m1 $wdum.m1 -pady 12
    set fex6but $fex6.but ; labelframe $fex6but -text $ms545
    button $fex6but.b0 -text $ms546 -width 9 -command "packFex 0 $fex $wlev"
    pack $fex6but.b0
#
    pack $wdum $wsab    -anchor w -pady 2
    pack $fex6but -padx 2 -padx 2 -side bottom -anchor s
#
#  end of "expert sections"
#*************************************************************************************************
#
#    $scantext configure -font $f1 -spacing1 5 -spacing2 5 -tabs 1.7i
#    set f1 {-*-"Courier New"-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
    set f5 {-*-"Courier New"-m-r-normal-*-10-100-*-*-*-*-iso8859-15}
    set f6 {Courier 12 bold italic}
#
    $scantext tag configure "old"    -foreground tan4         -elide 1 ;# b0
    $scantext tag configure "ctl"    -foreground brown        -elide 1 ;# b12
#
    $scantext tag configure "oldall" -foreground tan4         -elide 1 ;# b5
    $scantext tag configure "fndall" -foreground midnightblue -elide 1 ;# b6
    $scantext tag configure "untall" -foreground black        -elide 1 ;# b7
    $scantext tag configure "ctlall" -foreground brown        -elide 1 ;# b13
    $scantext tag configure "logall" -foreground darkblue     -elide 1 ;# b15

    $scantext tag configure "fnd"    -foreground darkblue     -elide 1 ;# b8
    $scantext tag configure "out1"   -foreground violetRed1   -elide 1 ;# b9
    $scantext tag configure "out2"   -foreground magenta      -elide 1 ;# b10
#
    $scantext tag configure "err"    -foreground darkblue     -elide 0 ;# b14
    $scantext tag configure "log"    -foreground darkblue     -elide 0 ;# b14
    $scantext tag configure "conf"   -foreground darkgreen    -elide 0 ;# b11
    $scantext tag configure "new"    -foreground darkred      -elide 0 ;# b2
    $scantext tag configure "lost"   -foreground darkcyan     -elide 0 ;# b3
    $scantext tag configure "unt"    -foreground black        -elide 0 ;# b4
#
    $scantext tag configure "tv"     -font $f1
    $scantext tag configure "radio"  -font $f1
    $scantext tag configure "out1"   -font $f6
    $scantext tag configure "out2"   -font $f5
    $scantext delete 1.0 end
  } ;# end proc.doScan
#
#*************************************************************************************************
# proc.packFex {nbr $fex $wlev} unpacks the right side + packs the expert field #nbr
#*************************************************************************************************
#
proc packFex { nbr fex wlev } {
    global tscam
    pack unpack $wlev ; set tscam ""
    catch { pack unpack ${fex}0 } ;# pack unpack ${fex}1
#    pack unpack ${fex}2 ; pack unpack ${fex}3 ; pack unpack ${fex}4
#    pack unpack ${fex}5
    catch { pack unpack ${fex}6 }
    if { $nbr == 0 } { ;# catch { pack $fex$nbr -side left }
    } else           { pack $fex$nbr -side left -expand 1 -fill y }
    pack $wlev  -side left -expand 1 -fill y
  } ;# end proc.packFex

#*************************************************************************************************
# proc.colin { wd } updates display field in "Anzeigen": colors for result types      *
#*************************************************************************************************
#
proc colin { wd } {
    global shom0 shom1 shom2 shom3 shom4 shom5 shom6 shom7 shom8 shom9 shom10 shom11
    global shom12 shom13 shom14 shom15 bgcolor smode
#    update
    set bc $bgcolor
    if { $smode == 2 } {
      ${wd}1.m1 configure -fg  $bc ; ${wd}1.m2 configure -fg  $bc  ;# new + conf
      ${wd}1.m3 configure -fg  $bc ; ${wd}2.m1 configure -fg  $bc  ;# lost + unt
      ${wd}2.m2 configure -fg  $bc ; ${wd}3.m1 configure -fg  $bc  ;# found + log
      ${wd}3.m2 configure -fg  $bc ; ${wd}3.m3 configure -fg  $bc  ;# ctl+ all others
    } else {
      set shoall [expr $shom5 || $shom9 || $shom10 || $shom11 ]
      set shofnd [expr $shom6  || $shom8  ] ;   set sholog  [expr $shom14 || $shom15 ]
      set shoctl [expr $shom12 || $shom13 ] ;   set shount  [expr $shom4 || $shom7 ]
#
      if { $shom2  } { ${wd}1.m1 configure -fg darkred
      } else         { ${wd}1.m1 configure -fg $bc      } ;# new
      if { $shom1  } { ${wd}1.m2 configure -fg  darkgreen
      } else         { ${wd}1.m2 configure -fg $bc      } ;# conf
      if { $shom3  } { ${wd}1.m3 configure -fg darkcyan
      } else         { ${wd}1.m3 configure -fg $bc      } ;# lost
      if { $shount } { ${wd}2.m1 configure -fg black
      } else         { ${wd}2.m1 configure -fg $bc      } ;# unt
      if { $shofnd } { ${wd}2.m2 configure -fg darkblue
      } else         { ${wd}2.m2 configure -fg $bc      } ;# found
      if { $sholog } { ${wd}3.m1 configure -fg darkblue
      } else         { ${wd}3.m1 configure -fg $bc      } ;# log
      if { $shoctl } { ${wd}3.m2 configure -fg brown
      } else         { ${wd}3.m2 configure -fg $bc      } ;# ctl: Suchliste
      if { $shoall } { ${wd}3.m3 configure -fg black
      } else         { ${wd}3.m3 configure -fg $bc      } ;# all others
    } ;# if dvb or not
  } ;# end proc.colin
#
#*************************************************************************************************
#  proc. quitlistScan terminates the doscan window + calls the configScan window      *
#*************************************************************************************************
proc quitlistScan {} {
    catch {destroy .doScan}      ; catch {destroy .configScan}
    catch {destroy .confliscan}  ; catch {destroy .confdvbscan}
    catch {destroy .confmanscan} ; catch {destroy .confiles}
    catch {destroy .configshow}  ; configScan
  } ;# end proc. quitlistScan
#
#*************************************************************************************************
#   proc. endScan {} terminates the scan program
#*************************************************************************************************
#
proc endScan {  } {
#   scanflg = -1 abort, 0 inactive, 1 list active, 2 dvb active, 3 manual active
#   smode = 1 listmode, 2 dvb-mode, 3 man-mode
    global scanflg smode tstat1 tstat2 tstam ms547 ms548
    if { $smode == 2 } { set tstam  $ms547 ; set tstat1 $ms547 ;# "dvb-Suchlauf beendet"
    } else { set tstam  $ms548 ; set tstat1 $ms548  } ;# if: "Suchlauf beendet"
    set tstat2 "" ; set scanflg 0 ; scankeys ; # reset the keys + flags
  } ;# end proc endScan
#
#*************************************************************************************************
#   proc. abortScan {} aborts the scan program
#   scanflg = -1 abort, 0 inactive, 1 list active, 2 dvb active, 3 manual active
#   smode = 1 listmode, 2 dvb-mode, 3 man-mode
#*************************************************************************************************
#
proc abortScan { } {
    global twsbut0 skey scanflg smode wblink onoff tstam tstat1 tstat2
    global ms226 ms227 ms228 ms422
# 226 "Suchlauf abgebrochen", 227 " - bitte warten.", 228 "dvb-Suchlauf abgebrochen"
#
    if { $smode != 2 } { ;# list-mode or manual mode
      set msg $ms226 ; set tstam  "$msg $ms227"
      set tstat1 $msg ; set tstat2 "" ; showScantext $msg "log"
      set scanflg -1 ; set skey 0  ;# reset the flag + skey
    } else {  ;# dvb-mode
      set msg $ms228  ; set tstam $msg
      set tstat1 $msg ; set tstat2 "" ; showScantext $msg "log"
      catch { exec killall -9 scan } ; catch { exec killall -9 dvbscan }
      set onoff -1  ; catch { $wblink configure  -bg $bgcolor }
      set scanflg 0 ; set twsbut0 $ms422 ;# reset the keys + flags
    } ;# if list-mode or dvb-mode
  } ;# end proc.
#
#*************************************************************************************************
#   proc. scankeys {} restore the key labels
#*************************************************************************************************
#
proc scankeys {  } {
#   ms418 auslassen, 419 abbrechen, 420 abfragen,
#   ms422 Starten, 423 Wiederholen, 424 loeschen
    global stopflg smode scanflg fscres twsbut0 twsbut1 twsbut2
    global ms419 ms422 ms423 ms424
    if { $scanflg > 0 } {
#  scan active
      set twsbut0 $ms419 ; set twsbut1 "" ; set twsbut2 ""
      if { $stopflg } { set twsbut2 "" } else { set twsbut2 "(nonstop)" }
    } elseif { $smode == 2 } {
#  scan inactive; dvb-mode
      set twsbut0 $ms422 ; set twsbut1 "" ; set twsbut2 ""
    } else {
#  scan inactive; list mode or manual mode
      if { [file exists "[file dirname $fscres ]/tmp1/out1-1"] } {
        set twsbut0 $ms422 ; set twsbut1 $ms423 ; set twsbut2 $ms424
      } else {
#       list or manual mode, no old data found:
	set twsbut0 $ms422 ; set twsbut1 "" ; set twsbut2 ""
      } ;# if old scan data
    } ;# if list/manual mode
  } ;# end proc.
#
#*************************************************************************************************
#   proc. reScan {} resumes the scan procedure
#*************************************************************************************************
#
proc reScan {  } {
    global twsbut1 ms423 skey
    if { $twsbut1 == $ms423 } { autoScan 1 } else { set skey 1 }
  } ;# end proc.
#
#*************************************************************************************************
#   proc. skipScan {} deletes the old scan data or skips a transponder
#*************************************************************************************************
#
proc skipScan {  } {
    global twsbut2 ms412 ms418 ms424 skey stopflg
    if { $twsbut2 == $ms424 } { autoScan 3
    } elseif { $twsbut2 == $ms418 } { set skey 2
    } elseif { $twsbut2 == $ms412 } { set stopflg 0 ; set skey 1 }
  } ;# end proc.
#
#######################################################################################
#*************************************************************************************************
#  proc. dvb-Scan { } does the dvb-scan + displays the dvb-scan report                *
#*************************************************************************************************
#
proc dvb-Scan { } {
    global mod ms70 myVersion0 scantext f1 f3  fscres scantrap wblink skey
    global shom0 shom1 shom2 shom3 shom4 shom5 shom6 shom7 shom8 shom9 shom10 shom11
    global shom12 shom13 shom14 shom15 sv1 sv2 sv3 sv4
    global ms52  ms161 ms230 ms231 ms232 ms233 ms234 ms235 ms236 ms237 ms238 ms239
    global ms240 ms243 ms246 ms247
    global ms256 ms257 ms258 ms259 ms260 ms261 ms262 ms263 ms264 ms267 ms271 ms331
    global ms343 ms347 ms348 ms370 ms371 ms372 ms373 ms374 ms376 ms377
    global ms379 ms380 ms381 ms382 ms414 ms416 ms417 ms418 ms419 ms420 ms422 ms423
    global ms424 ms149 ms147 ms435 ms436 ms441 ms442 ms443 ms444 ms445 ms446 ms447
    global ms448 ms449 ms458 ms466
    global txtwd12 txtwd13 txtwd22 txtwd23 tic1 tic2 tic3 tic4
    global tstat1 tstat2 tstat3 tstat4 tstat5 xtsc xtsr tws1 tws2
    global confpath newpath lostpath untpath twsbut0 twsbut1 twsbut2 tstam
#
#"dvb-Suchlauf", "Kenndaten","Signal  = ","Modus   = ","Auswahl = "
#"Dienste = ","Dateien","Suchdatei = ","Ergebnis  = ","Status","Pegel"
#
    set wscan .dvbscan
    if { [winfo exists $wscan ] } {
                   tk_messageBox -type ok -icon info -message $ms161  ; return }
    toplevel $wscan ; wm title $wscan $ms230  ; wm geometry $wscan -40-80
#
#   text area
    set txt $wscan.text ;  set scantext $txt.t
    frame $txt
    text $scantext -width 85 -height 20 -wrap word \
            -xscrollcommand "$txt.xsbar set" -yscrollcommand "$txt.ysbar set"
    scrollbar $txt.xsbar -orient horizontal -command "$txt.t xview"
    scrollbar $txt.ysbar -orient vertical   -command "$txt.t yview"
    grid $scantext $txt.ysbar -sticky nsew
    grid $txt.xsbar -sticky nsew
    grid columnconfigure $txt 0 -weight 1
    grid rowconfigure    $txt 0 -weight 1
    $scantext configure -tabs 2.1i
#
    set wright $wscan.wright ; frame $wright
    set wsup  $wright.upper  ; frame $wsup
    set winfo $wsup.fram1    ; frame $winfo
#
# "Kenndaten": display the main control values
    set winfo1 $winfo.f1      ; labelframe $winfo1 -text $ms231
    set winfoct $winfo1.left  ; frame $winfoct
    set winfocv $winfo1.right ; frame $winfocv
    label $winfoct.m1 -text $ms232
    label $winfocv.m1 -width 10 -textvariable tic1 -anchor w
    label $winfoct.m2 -text $ms233 ; label $winfocv.m2 -textvariable tic2
    label $winfoct.m3 -text $ms234 ; label $winfocv.m3 -textvariable tic3
    label $winfoct.m4 -text $ms235 ; label $winfocv.m4 -textvariable tic4
    pack $winfoct.m1 $winfoct.m2 $winfoct.m3 $winfoct.m4 -anchor e
    pack $winfocv.m1 $winfocv.m2 $winfocv.m3 $winfocv.m4 -anchor w
    pack $winfoct $winfocv -side left -padx 2
#
#  "Dateien": show the files + directories
    set winfo2 $winfo.f2 ; labelframe  $winfo2 -text $ms458
    set winfofc $winfo2.c ; frame $winfofc
    set winfoft $winfofc.left  ; frame $winfoft
    set winfofv $winfofc.right ; frame $winfofv
    label $winfoft.m1 -text $ms237 ; label $winfofv.m1 -textvariable xtsc
#    label $winfoft.m2 -text "im Verzeichnis = " ; label $winfofv.m2 -textvariable xdsc
    label $winfoft.m3 -text $ms238 ; label $winfofv.m3 -textvariable xtsr
    pack $winfoft.m1 $winfoft.m3 -anchor e
    pack $winfofv.m1 $winfofv.m3 -anchor w
    pack $winfoft $winfofv -side left ; pack $winfofc -anchor c
#
#  Status messages
    set wsmes  $winfo.mesfield ; labelframe $wsmes
    set scames $wsmes.scames ; set tstam "" ; label $scames -textvariable tstam
    pack $scames
#
#  show: "Status"
    set winfo4 $winfo.fra4 ; labelframe  $winfo4 -text $ms239
    set ws1 $winfo4.f1 ; frame $ws1 ; set wblink $ws1.m2
    label $ws1.m1 -textvariable tstat1 ; label $ws1.m2 -textvariable tstat2
    label $ws1.m3 -textvariable tstat3 ; label $ws1.m4 -textvariable tstat4
    label $ws1.m5 -textvariable tstat5 ; label $ws1.m6 -textvariable tstat6
#    pack $ws1.m1 $ws1.m2 $ws1.m3 $ws1.m4 $ws1.m5 -anchor w
    pack $ws1.m1 $ws1.m2 -anchor w
    set ws2 $winfo4.f2 ; frame $ws2
    label $ws2.m1 -text "" ; label $ws2.m2 -textvariable ts2
    pack $ws2.m1 $ws2.m2
    pack $ws1 -anchor w
    pack $winfo1 $winfo2 $winfo4 -pady 4 -expand 1 -fill x
#
#  right frame: 'pegel' :  Pegel-Anzeige
#
    set wlev $wsup.level ; labelframe $wlev -text $ms240
    scale $wlev.scal   -label "" -length 6c -from 100000 -to 0 -orient vertical
    pack $wlev.scal -side left -anchor c
    showlevel $wlev.scal ;# show pegel
#
#  Status messages
    set wsmes $wright.mesfield ; labelframe $wsmes
    set scames $wsmes.scames ; set tstam "" ; label $scames -textvariable tstam
    pack $scames
#
    set wsbut $wright.but    ; frame $wsbut
    set wsbut1 $wsbut.but1   ; labelframe $wsbut1 -text "Ergebnisse"
    set wsbut3 $wsbut.but3   ; labelframe $wsbut3 -text "Suchlauf"
#
    button $wsbut1.b0 -text $ms52  -width 9 -command "doHelp"
    button $wsbut1.b1 -text $ms466 -width 9 -command "doEdit"
    button $wsbut1.b2 -text $ms70  -width 9 -command "dvb-quit"
    pack $wsbut1.b0 $wsbut1.b1 $wsbut1.b2
#
    button $wsbut3.b0 -textvariable twsbut0 -width 9 -command "autoScan 2"
    button $wsbut3.b1 -text "" -width 9 -command ""
    button $wsbut3.b2 -text "" -width 9 -command ""
    pack $wsbut3.b0 $wsbut3.b1 $wsbut3.b2
    pack $wsbut1 $wsbut3 -side right -padx 2 -pady 2
#
#  pack the main frames alltogether
#
    pack $winfo $wlev -side left -pady 4 -padx 4
    pack $wsup  -padx 2 -pady 8
    pack $wsbut -side bottom -padx 4 -pady 4
    pack $wsmes -side bottom -padx 4 -pady 4 -expand 1 -fill x
    pack $wright $txt -side right -expand 1 -fill y
#
#    $scantext configure -font $f1 -spacing1 5 -spacing2 5 -tabs 1.7i
#    set f1 {-*-"Courier New"-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
    set f5 {-*-"Courier New"-m-r-normal-*-10-100-*-*-*-*-iso8859-15}
    set f6 {Courier 12 bold italic}
#
    $scantext tag configure "err" -foreground darkblue -elide 0 ;# b14
    $scantext tag configure "log" -foreground darkblue -elide 0 ;# b14
    $scantext delete 1.0 end
  } ;# end proc.dvb-Scan
#
#
#*************************************************************************************************
#  proc. dvb-quit terminates the dvb-scan window + returns to configScan              *
#*************************************************************************************************
proc dvb-quit {} {
    catch {destroy .doScan} ; catch {destroy .doEdit} ; catch {destroy .configScan}
    catch {destroy .confliscan}  ; catch {destroy .confdvbscan}
    catch {destroy .confmanscan} ; catch {destroy .confiles} ; catch {destroy .dvbscan}
    configScan
  } ;# end proc. dvb-quit

#*************************************************************************************************
#   proc. dvb-start starts a scan in dvb-mode                                         *
#*************************************************************************************************
#
proc dvb-start { } {
    global sot1 sot2 sout2 flen0 tell0 traplist
    global scanflg smode fdscan scansat fscres skey scantext scantrap stopflag
    global tstam tstat1 tstat2 tstat3 tstat4 tstat5 twsbut0 twsbut1 twsbut2
    global zap mod blist fta tra ad global confpath newpath lostpath untpath onoff
    global offcolor bgcolor myVersion0
    global ms8    ms70 ms213 ms214 ms215 ms216 ms283 ms284 ms290 ms293 ms361
    global ms401 ms402 ms403 ms404 ms405 ms407 ms408 ms409
    global ms418 ms419 ms420 ms422 ms423 ms424
#"Suchlauf gestartet.,ist keine dvb-Suchdatei.,dvb-Suchlauf aktiv.","- bitte warten -
#
#   automode = 0: display only; no reset, no scan; display results from previous scan
#   automode = 1: resume; no reset; complete the previously aborted scan
#   automode = 2: new scan; clear old data, perform new scan
#   automode = 3: clear only; clear old data, no action
#   smode = 1: list mode; 2 = dvb-mode; 3 = manual mode
#   scanflg  = 0 inactive; 1 = list mode active; 2 = dvb mode active; 3 = man.mode.act.
    set tstam $ms213
    set tstat1 "" ; set tstat2 "" ; set tstat3 "" ; set tstat4 "" ; set tstat5 ""
    set skey -1 ; scankeys ; set pr "dvb-start" ; set twsbut0 $ms419 ; set traplist ""

#  identify which scan program to be used: dvbscan (Suse) or scan (Kanotix)
    if { [catch { exec which dvbscan } scanpath ] != 0 } {
      if { [catch { exec which scan  } scanpath ] != 0 } {
        tk_messageBox -icon warning  -message $ms283 ; abortScan ; return }
    } ;# end if ok: program dvb-scan available
#
    set er1 [ catch { open $fdscan } inf ]
    if { $er1 } { Err d1 "$ms284\n$fdscan" ; abortScan ; return }
    set er2 [ catch { gets $inf } curl ] ;# read 1st line
    if { $er2 } { Err d2 "$ms401\n$fdscan" ; abortScan ; return }
    if { [string first "*teclasat frequency scan*" $curl ] > 0 } {
      Err d3 "$fdscan \n$ms214" ; abortScan ; return }
    catch { close $inf }
    if { $scansat >= 0 } { set sat $scansat } else { set sat 0 }
    showScantext "" "reset" ;# clear the display
#
    set dir0 [ file dirname $fscres ]
    set sout1 $dir0/tmp1/dvb-out1 ; set sout2 $dir0/tmp2/dvb-out2
    if { ![file isdirectory $dir0/tmp1] } { exec mkdir -p $dir0/tmp1 }
    if { ![file isdirectory $dir0/tmp2] } { exec mkdir -p $dir0/tmp2 }
    if { ![file isdirectory $dir0/tmp3] } { exec mkdir -p $dir0/tmp3 }
    set er1 [catch { open $sout1 w+ } sot1 ] ; set er2 [catch { open $sout2 w+ } sot2 ]
#*************************************************************************************************
    exec $scanpath $fta $tra -a$ad -s$sat $fdscan  >> $sout1 2>> $sout2 &
#   exec $scanpath -x0 -t3 -a0 -s0 $fdscan >> $sout1 2>> $sout2 &  ;# Kurzform f.Test
#*************************************************************************************************
    set tstat1 $ms215 ; set tstat2 " $ms216 "
    set flen0 0 ; set tell0 0 ; set onoff 0 ; dvb-blink [file tail $scanpath]
#
########vvvvvvvvvvvvv for test (instead of program 'dvb-blink': vvvvvv#################
    if { 0 } {
      set lmot 0 ; set mot 0 ; set ctr 0
      while { 1 } {
        set mot [file mtime $sout2] ; update
        if { $mot > $lmot } { set lmot $mot ; puts "scan3723; mot = *$mot*"
          while { 1 } { gets $sot2 curl ; if { [ eof $sot2 ] } { break }
            incr ctr ; puts "scan3727; ctr=*$ctr* *$curl*"  } ;# while 1
        } ;# if new data in file
      } ;# while out2 is open
    } ;# if 0 (test)
################################^^^^  end 'for test only' ^^^^^^^^#####################
  } ;# end proc.dvb-start
#
#*************************************************************************************************
#   proc. dvb-blink continues the dvb-scan ant terminates it when finished
#*************************************************************************************************
#
proc dvb-blink { prog } {
    global sot1 sot2 sout2 flen0 tell0 fscres ms551 ms552
    global bgcolor offcolor onoff wblink ms422 tstam tstat1 tstat2 twsbut0 traplist
#"dvb-Suchlauf beendet.", "Ergebnis abgespeichert."
#
    if { ![winfo exists .dvbscan ] } { return }
    set flen [file size $sout2] ; if { $flen > $flen0 } { ;# new text in $sout2
      while { 1 } { gets $sot2 curl ; if { [ eof $sot2 ] } { break }
        showScantext $curl "log"
	if { ![string first ">>> tune to:" $curl ] } {
	  set trap [string range [string trimright $curl " (tuning failed)"] 13 end ]
          if { [string first $trap $traplist] < 0 } { ;#new transponder: append to list
            set nbr [expr [llength $traplist] + 1] ; set traplin "nbr.$nbr:${trap}:::"
	    set traplist [lappend traplist $traplin] }  }
      set flen0 [file size $sout2] ; set tell0 [ tell $sot2 ] } } ;# new data in sout2
#
    set isrunning 0 ; set err1 0 ; set proginfo ""
    set err1 [ catch { exec ps fax | grep $prog | sed /grep/d } proginfo ]
    if { $proginfo == "" } {
# dvb-scan terminated: clean up, save + show results
      set onoff -1 ; catch { $wblink configure -bg $bgcolor -fg black }
      catch { close $sot1 } ; catch { close $sot2 }
#  save the dvb-scan results
      set dir0 [file dirname $fscres] ; set sout1 $dir0/tmp1/dvb-out1
      if {[ catch { exec cp -p $sout1 $fscres } res]} {Err d22 $res ; return}
#
      set trapf $dir0/tmp3/dvb-transponders
      if { [ catch { open $trapf w } fot ] } { Err d23 $fot; return }
      foreach trp $traplist { set e0 [ catch { puts $fot $trp } erms ]
        if { $e0 } { Err d24 $erms; return } } ; catch { close $fot } ;# end foreach
#  show status
      set tstat1 $ms551 ; set tstat2  $ms552
      set tstam  $ms551 ; set twsbut0 $ms422  ; return
# else: dvb-scan in progress; blink with indicator
    } elseif { $onoff == 1 } { set onoff 0
      catch { $wblink configure -bg red }       ; catch { $wblink configure -fg blue  }
    } elseif { $onoff == 0 } { set onoff 1
      catch { $wblink configure -bg $offcolor } ; catch { $wblink configure -fg black }
    }
    update ; after 2000 [ list dvb-blink $prog ]
  } ;# end proc.dvb-blink
#
#
#######################################################################################
#*************************************************************************************************
#   proc. autoScan does an automatic scan based upon the preceeding parameters        *
#*************************************************************************************************
#
proc autoScan { automode } {
    global scanflg smode flscan scansat fscres skey scantext scantrap stopflg
    global tstam tstat1 tstat2 tstat3 tstat4 tstat5 twsbut0 twsbut1 twsbut2
    global zap mod blist fta tra ad onoff
    global confpath newpath lostpath untpath foundpath offcolor bgcolor myVersion0
    global ms8    ms70 ms283 ms284 ms290 ms293 ms361
    global ms401 ms402 ms403 ms404 ms405 ms407 ms408 ms409 ms412 ms418 ms419
    global ms420 ms422 ms423 ms424 ms553 ms554 ms555 ms556 ms557 ms558 ms559
    global ms560 ms561 ms562 ms563 ms564 ms565 ms566 ms567 ms568 ms569
    global ms570 ms571 ms572 ms573 ms574 ms575 ms576 ms577 ms578 ms579
    global ms580 ms581 ms582 ms583 ms584 ms585 ms586 ms587 ms588 ms589
    global ms590 ms591 ms592 ms593
#
#"Listensuchlauf wird wiederholt."
#"Suchlauf gestartet."
#"Alte Daten werden gelöscht."
#"Manuell/Einzeltransponder: "
#"Keine gueltige Suchliste!"
#"Suchliste wird geprüft: "
#"Suchliste: "
#"Alte Suchlauf-Daten geloescht."
#"Alte Suchlauf-Daten geloescht."
#"Suchlauf mit "
#"timeout-Störung bei Trp.#$it $ms407 $nt:" "log"
#"timeout-Störung, bitte Suchbericht beachten."
#"Treibermodul dvb-bt8xx ist blockiert, Details s.Hilfetext."
#"Bitte eine Konsole öffnen, eingeben:"
#"> su (root-Passwort)"
#"# modprobe -r dvb-bt8xx" "log"
#"# modprobe dvb-bt8xx" "log"
#"# exit" "log"
#"timeout-Störung bei Trp.#$it $ms407 $nt:"
#"Treibermodul dvb-bt8xx ist blockiert,"
#"bitte Suchbericht beachten."
#"Dann: Knopf 'Weiter' anklicken."
#"Ende der Liste: Suchlauf abgebrochen."
#"Suchlauf abgebrochen."
#"Suchlauf wird mit Trp.#$nxt fortgesetzt."
#"Bitte ggf. Suchlauf wiederholen, um Trp.#$it abzufragen."
#"Suchlauf wird mit Trp.#$nxt fortgesetzt."
#"Sender gefunden; $ntnew neue Sender"
#"$ntconf bestätigt, $ntlost entfallen,"
#"$ntunt nicht betroffen (andere Transpdr)"
#"Suchlauf mit
#" beendet"
#"Suchlauf beendet; Ergebnisse werden abspeichert."
##############################################################################
#
#   automode = 0: display only; no reset, no scan; display results from previous scan
#   automode = 1: resume; no reset; complete the previously aborted scan
#   automode = 2: new scan; clear old data, perform new scan
#   automode = 3: clear only; clear old data, no action
#   smode = 1: list mode; 2 = dvb-mode; 3 = manual mode
#   scanflg  = 0 inactive; 1 = list mode active; 2 = dvb mode active; 3 = man.mode.act.
    if { $twsbut0 == $ms419 } { abortScan ; return } ;# abort scan
    if { $smode == 2 } { dvb-start ; return } ;# start dvb-scan
    if { $automode != 3 } { set scanflg $smode }
    if { $automode == 1 } { set tstam $ms553 }
    if { $automode == 2 } { set tstam $ms554 }
    if { $automode == 3 } { set tstam $ms555 }
    set tstat1 "" ; set tstat2 "" ; set tstat3 "" ; set tstat4 "" ; set tstat5 ""
    set skey -1 ; scankeys ; set pr "autoScan"
#  identify which scan program to be used: dvbscan (Suse) or scan (Kanotix)
    if { [catch { exec which dvbscan } scanpath ] != 0 } {
      if { [catch { exec which scan  } scanpath ] != 0 } {
        tk_messageBox -icon warning  -message $ms283 ; abortScan ; return }
    } ;# end if ok: dvb-scan available
#   make sure that directory for $fscres exists:  ??????????????????????
              set dir0 [file dirname $fscres ] ; set prog [file tail $scanpath ]
              if { ![file isdirectory $dir0]} { exec mkdir -p $dir0 }
              if { $scansat >= 0 } { set sat $scansat } else { set sat 0 }

#
#*************************************************************************************************
#  manual mode: one transponder only; build tralist + chalist from scantrap
#*************************************************************************************************
#
    if { $smode == 3 } {
      set chanparms [split $scantrap : ] ;# for the message
      if {![ string first "BANDWIDTH" [lindex $chanparms 3 ] ] } {
# dvb-t:
        set freq [expr [lindex $chanparms 1 ] / 1000000 ]
	set msg1 "${freq}MHz" ;# dvb-t
	set transpdr "$freq"  ;# preliminary
      } else {
# dvb-s:
	set tnam [ lindex $chanparms 0 ]
	set freq [ lindex $chanparms 1 ] ;  set pol   [ lindex $chanparms 2 ]
        set msat [ lindex $chanparms 3 ] ;  set srate [ lindex $chanparms 4 ]
	set msg1 "$tnam: $freq$pol" ;# dvb-s
	set transpdr "$tnam:$freq:$pol:$msat:${srate}:::" ;# transponder info
      } ;# end if dvb-t or dvb-s
      set tralist  "" ;  lappend tralist $transpdr ;# save in a list
      set chanlist "" ;  lappend chanlist $msg1
      set cm1 "$ms556 " ; set ctrlmsg "$cm1$transpdr"
      set tstat1 $cm1 ; set tstat2 $transpdr
#   end manual section: single transponder
#
    } else {
#*************************************************************************************************
#  'list' mode: build tralist + chanlist from file  $flscan
#*************************************************************************************************
#
      set tralist "" ; set chanlist "" ; set lnbr 0  ;# init the lists
      if { [catch { open $flscan } inf ] } {
        tk_messageBox -message "$ms284\n$flscan" ; return
      } ;# end open $flscan
#
      while { ![eof $inf] } {
        set err [ catch { gets $inf } curl ] ; incr lnbr ;# read a line
	if { $err } { tk_messageBox -message "$ms401\n$flscan" ; abortScan ; return }
        if { ![string length $curl] } { continue } ;# empty line: exit
	if { ![string first "#" $curl] } {
	  if { $lnbr == 1 } {
            if { [string first "*teclasat frequency scan*" $curl] < 0 } {
	        Err c11 $ms560 ; abortScan; return
	    } ;# end test for dvb-scan
	  } ;# end 1st line
	  continue ;# ignore comment line, proceed to next line
	} ;# if comment lines
        set chanparms [split $curl : ] ;# for the message
        if { ![ string first "BANDWIDTH" [lindex $chanparms 3 ] ] } {
# dvb-t:
	  set freq [expr [lindex $chanparms 1 ] / 1000000 ]
          set msg1 "${freq}MHz"
          set transpdr "$freq"  ;# preliminary
        } else {
# dvb-s:
	  set tnam   [lindex $chanparms 0 ]  ;  set freq  [lindex $chanparms 1 ]
	  set pol    [lindex $chanparms 2 ]  ;  set srate [lindex $chanparms 4 ]
	  if { $scansat >= 0 } { set fsat $scansat ;# as selected in doScan
	                } else { set fsat [lindex $chanparms 3 ] } ;# value from list
	  set transpdr "$tnam:$freq:$pol:$fsat:${srate}:::" ;# transponder info
          set msg1 "$tnam: $freq$pol"
        } ;# end if dvb-t or dvb-s
        lappend tralist $transpdr ;  lappend chanlist $msg1 ;# save in a list
      } ;# end while reading the file $flscan
      set cm1 "$ms561 " ; set ctrlmsg "$ms562 $flscan"
      set tstat1 $cm1 ; set tstat2 [file tail $flscan]
    } ;# if 'man' or 'list mode': tralist + chalist ready
#
#*************************************************************************************************
#  initialize the directories + data files for frequency scan
#*************************************************************************************************
    set dir0 [file dirname $fscres ]
    if {![file isdirectory $dir0 ] }    { exec mkdir -p $dir0 }
    if {![file isdirectory $dir0/tmp1]} { exec mkdir -p $dir0/tmp1 }
    if {![file isdirectory $dir0/tmp2]} { exec mkdir -p $dir0/tmp2 }
    if {![file isdirectory $dir0/tmp3]} { exec mkdir -p $dir0/tmp3 }
#
    set logpath   $dir0/tmp3/log          ; catch { exec rm $logpath }
    set oldpath   $dir0/tmp3/old          ; catch { eval exec rm [glob $oldpath* ] }
    set foundpath $dir0/tmp3/found        ; catch { eval exec rm [glob $foundpath*]}
    set confpath  $dir0/tmp3/confirmed    ; catch { eval exec rm [glob $confpath*] }
    set newpath   $dir0/tmp3/new          ; catch { eval exec rm [glob $newpath* ] }
    set lostpath  $dir0/tmp3/lost         ; catch { eval exec rm [glob $lostpath*] }
    set untpath   $dir0/tmp3/untouched    ; catch { eval exec rm [glob $untpath* ] }
#
    set logpath   $dir0/tmp3/scanlog
    set trapath   $dir0/tmp3/transponders ; set chapath   $dir0/tmp3/channels
    set out1path  $dir0/tmp1/out1         ; set out2path  $dir0/tmp2/out2
#
#  read scanlog
    set err1 [catch { open $logpath } inf ] ;    set err2 [catch { gets $inf log1 } ]
    set err3 [catch { gets $inf log2 } ]    ;    set err4 [catch { gets $inf log3 } ]
#
# automode = 0: display old data (if any), do not perform a scan for now
    if { $automode == 0 } { set err1 [catch { open $trapath } inf ]
      if { $err1 } { set automode 3 } else { set lnbr 0
	while { ![eof $inf] } { gets $inf lin
	  if { $lin != [ lindex $tralist $lnbr ] } { set automode 3 ; break }
	  incr lnbr } ; close $inf ;# end while checking trapath
      } ;# end checking tralist
    } ;# end automode 0
#
# automode = 1: resume previous scan; check if data is consistent with control file
    if { $automode == 1 } {
      set lnbr 0 ; set err1 [catch { open $trapath } inf ] ;# try to read trapath
      if { $err1 } { tk_messageBox -message "$ms402 $trapath $ms403\n$ms404"
                                                             abortScan ; return }
      while { ![eof $inf] } {  gets $inf lin
        if { $lin != [ lindex $tralist $lnbr ] } {
          tk_messageBox -message "$ms405\n$ms404" ; abortScan ; return } ;#
	incr lnbr } ; close $inf
    } ;# end automode = 1
#
#  automode = 2: new scan, or automode = 3: clear display: delete old data
    if { $automode >= 2 } {
      catch { eval exec rm [glob $chapath* ] }
      catch { eval exec rm [glob $trapath* ] }
      catch { eval exec rm [glob $out1path*] }
      catch { eval exec rm [glob $out2path*] }
      showScantext "" "reset"
    } ;# end automode = 2 or 3
#
#  automode = 3:  clear status display + exit
    if { $automode == 3 } { scankeys ; set tstat1 $ms563 ; set tstam $ms563
                   set tstat2 "" ;     return } ;# end automode 3: old data deleted
#  store transponders in file
    if {![catch {open $trapath w } fil ] } {
	              foreach trp $tralist { puts $fil $trp } ; close $fil }
#
#  initialization done; go to perform or simulate the scan
#
#*************************************************************************************************
#  initiate the loop for the "frequency scan"
#*************************************************************************************************
#
    set it 0 ; set nt [llength $tralist ]  ; set scanresstring "" ; set totchans 0
    set ntconf 0 ; set ntnew   0 ; set ntlost 0 ;#  counter for found+lost channels
    set ntunt  0 ; set ntfound 0 ; set ntold  0
    catch [exec cp -f $blist $oldpath-all ] ;# force copying, overwrite w/o warning
    set fndall "" ; set logall "" ; set ctlall ""
#  init 'untall': reference list = old channels list
    set oldall "" ; set eo1 [catch { open $oldpath-all } inf ]
    if { $eo1 } { Err c14 $inf ; abortScan ; return }
    while { ![eof $inf] } {
      set eo2 [catch { gets $inf } curl ]
      if { $eo2 } { Err c15 $curl ; abortScan ; return }
      if { ![string length $curl]    } { continue } ;# empty line: ignore
      if { ![string first "#" $curl] } { continue } ;# comment line: ignore
      showScantext $curl "oldall" ; lappend oldall $curl
    } ; catch { close $inf } ;# end file
#
    set untall $oldall ;# 'untouched-all': channels that have not been updated
    showScantext $ctrlmsg "log"
#  display flscan = actual control list
    if { $smode == 2 } {
      showScantext $ctrlmsg "ctlall" ;# manual mode
    } else {
      set ctlall "" ; set ec1 [catch { open $flscan } inf ]
      if { $ec1 } { Err c16 $inf ; abortScan ; return }
      while { ![eof $inf] } {
        set ec2 [catch { gets $inf } curl ]
        if { $ec2 } { Err c17 $curl ; abortScan ; return }
	if { ![string length $curl]   } { continue } ;# empty line: ignore
	if { [string first "#" $curl] } { continue } ;# comment line: ignore
        showScantext $curl "ctlall" ; lappend ctlall $curl
      } ; catch { close $inf } ;# end file flscan -> scantext
    } ;# if man or list mode
#
#*************************************************************************************************
#  loop: do a real or virtual scan for each transponder
#*************************************************************************************************
    foreach trap $tralist  {
#
      if { $scanflg < 0 }  { break } ;# scan aborted
      if { $stopflg } { set twsbut2 "" } else { set twsbut2 "(nonstop)" }
      showScantext $trap "ctl" ; lappend ctlall $trap ;# show the control data
      set chap [split $trap : ] ;# get transponder parameters
      if {![ string first "BANDWIDTH" [lindex $chap 3 ] ] } {
# dvb-t:
	set freq [expr [lindex $chanparms 1 ] / 1000000 ]
        set msg1 "${freq}MHz"  ;          set transpdr "$freq"  ;# preliminary
      } else {
# dvb-s:
	set freq  [lindex $chap 1 ]      ;  set pol   [ lindex $chap 2 ]
        set fsat  [lindex $chap 3 ]      ;  set srate [ lindex $chap 4 ]
	set trad "$freq:$pol:$fsat:$srate" ;# transponder info
      } ;# end if dvb-t or dvb-s
      set msg [ lindex $chanlist $it ]  ; incr it ;# now it = 1 for 1st transponder
      set tstat1 "$ms565 [file tail $flscan]"
      set tstat2 "#$it $ms290 $nt: $msg"
      set logln1 "Trp.$it of $nt: $trap*" ;  lappend logall $logln1
      showScantext $logln1 "log" ;# show transponder data in the doScan2 window
      set found ""         ; list of found channels in actual transponder
      set out1 $out1path-$it ;  set out2 $out2path-$it ;# actual output files
#*************************************************************************************************
#  ***  do scan for one transponder:
      if { $automode == 1 } { set lout2 "" ; set curl "" ; set timeout -1 ; set key0 0
	if { [ file exists $out2 ] } {
	  if { ![catch { open $out2 } inf2 ] } {
          while { ![eof $inf2] } { catch { gets $inf2 } curl ; lappend lout2 $curl }
	  catch { close $inf2 } ; set timeout [lsearch $lout2 "*filter timeout*"] }
	  if { $timeout >= 0 } {
# timeout msg found in out2-file for this transponder
            showScantext "Trp#$it $ms407 $nt: *$trap*" "log"
            showScantext $ms408 "log" ;# war irueherem Suchlauf wg.time-out gestoert
	    showScantext $ms409 "log" ;# erneut abfragen, überspringen, abbrechen?
# ask: evaluate this transponder again, or skip it?
#*************************************************************************************************
#  wait for keystroke:  'abfragen', 'auslassen'
	    set skey -1 ; set twsbut1 $ms420 ; set twsbut2 $ms418
            tkwait var skey ; update; set skey0 $skey ;# wait for key
#*************************************************************************************************
	    set twsbut1 "" ; set twsbut2 "" ; set skey -1
            if { $skey0 == 0 } { abortScan ; break }
	    if { $skey0 == 1 } { catch { exec mv -f $out2 $out2-old } } ;# remove out2
	    if { $skey0 == 2 } { continue } ;# skip this transpdr; next item
          } ;# end if old timeout
	} ;# end if file out2 exists
      } ;# end if real scan
#
#*************************************************************************************************
#  do the scan for one transponder:
      if { ![ file exists $out2 ] } {
#  ***  tune to actual transponder using '$zap ... -x' :
	catch { exec $zap -a$ad -c $trapath -n $it -x }
#  ***  perform the scan for this transponder using 'dvbscan ... -c' :
	catch { exec $scanpath $fta $tra -a$ad -s$fsat -c > $out1 2> $out2 }
      } ;# end if file $out2 does not exist
#*************************************************************************************************
#
#  process output files for actual transponder
#
#  process out2:
      if { [catch { open $out2 } inf2 ] } {
        tk_messageBox -message "$ms293\n$out2" ;  return
      } ;# end open $out1
      set outlist2 "" ; set lnbr2 0
      while { ![eof $inf2] } {
        gets $inf2 curl
	if { [string length $curl ] } { incr lnbr2 ; lappend outlist2 $curl }
      } ;# end while reading file out2
      close $inf2
#  check for 'time-out error:
      set timeout [lsearch $outlist2 "*filter timeout*"]
      if { $timeout >= 0 } { set log1 "Trp.$it $ms407 $nt:filter_timeout; *$trap*"
        if {![catch {open $logpath a } fil ] } { puts $fil $log1 ; close $fil }
        lappend logall $log1
	showScantext $log1 "log" ;# show time-out msg in the doScan2 window
	showScantext "$ms566$it $ms407 $nt:" "log"
	showScantext "$trap" "log"
	set tstam "$ms567"
        if { $stopflg } {
          showScantext $ms568 "log"
          showScantext $ms570 "log"
          showScantext $ms571 "log"
          showScantext $ms572 "log"
          showScantext $ms573 "log"
          showScantext $ms574 "log"
          set tstat3 "$ms576$it $ms407 $nt:"
          set tstat4 $ms577
          set tstat5 $ms578
# is this the last item in the transponder list?
          if { $it < $nt } {
# yes: ask for keystroke & continue if desired
            showScantext $ms579 "log"
            set twsbut1 $ms8 ; set twsbut2 $ms412 ;# 'Weiter' bzw. 'Weiter nonstop'
            tkwait var skey
            update; set skey0 $skey ; set skey -1 ; set twsbut1 "" ; set twsbut2 ""
            set tstat3 "" ; set tstat4 "" ; set tstat5 ""
            if { $skey0 == 0 } { abortScan ; break } ;# abort + terminate
	  } else {
#  this is the last transponder in list: abort
	    showScantext $ms580 "log"
            set tstam  $ms581
            abortScan ; break
	  } ;# if last transponder
	} ;# if $stopflg
#  skip this transpdr, continue with next item
        set nxt [expr $it + 1]
        set tstam "$ms582$nxt."
        showScantext "$ms583$it $ms584" "log"
        showScantext "$ms582$nxt." "log"
        continue ;# proceed to next transponder
      } ;# end if timeout
#
#  process out1
#
      if { [catch { open $out1 } inf1 ] } {
        tk_messageBox -message "$ms293\n$out1" ;  return
      } ;# end open $out1
      set outlist1 "" ; set lnbr1 0
      while { ![eof $inf1] } {
        gets $inf1 curl
	if { [string length $curl ] } { incr lnbr1 ; lappend outlist1 $curl }
      } ;# end while reading file out1
      close $inf1
#
#  analyze out2: number of services in this transponder
      set ln [expr $lnbr2 - 2] ; set lline [lindex $outlist2 [expr $lnbr2 - 2]]
      set pos1  [expr [string first "lists ("   $lline] + 7]
      set pos2  [expr [string first "services)" $lline] - 2]
      set erf [ lsearch $outlist2 "*FATAL: failed to open*" ]
      if { $erf >= 0 } { showScantext "FATAL error: no dvb-module loaded." "log"
	  set tstam "FATAL error: no dvb-module loaded." ; return }
      if { $pos2 >= $pos1 } { set nserv [expr [string range $lline $pos1 $pos2]]
                     } else { set nserv 0 }
      set nchans [llength $outlist1 ]
      set totchans [expr $totchans + $nchans ]
#
#  process out1:  read channel parameters
#
      set ic 0
      while { $ic < $nchans } {
        set line1 "" ; set line2 ""
	set cname "???"; set sid ""; set vpid0 ""; set apid ""
	set e1 [catch {set line1 [lindex $outlist1 $ic] } em1 ]
	set e2 [catch {set line2 [lindex $outlist2 [expr $ic + 1]] } em2 ]
	set e3 [catch {set cname [string trim [string range $line1 0 24 ] ] } em3 ]
        set e4 [catch {set sid   [expr [string range $line1 26 31 ] ] } em4 ]
        set e5 [catch {set vpid0 [string trim [string range $line1 51 56 ]] } em5 ]
        if { $vpid0 == "" } { set vpid 0 } else { set vpid [expr $vpid0 ] }
        set e6 [catch {set apid  [expr [string range $line1 60 65 ] ] } em6 ]
#
	set chanparms "$cname:$trad:$vpid:$apid:$sid"
        lappend found         $chanparms    ;# add this channel to 'found'-list
	append  scanresstring $chanparms\n
        incr ic
	if { $e1||$e2||$e3||$e4||$e5||$e6 } {
          set ert "fmterr = *$e1$e2$e3$e4$e5$e6* in trp#$it of $nt, chan#$ic: *$cname*"
	  showScantext "$ert"             "err"
	  showScantext "line1=*$line1*"   "err"
	  showScantext "line2=*$line2*"   "err"
	  if { $e1 } { showScantext  "e1: $em1" "err" }
	  if { $e2 } { showScantext  "e2: $em2" "err" }
	  if { $e3 } { showScantext  "e3: $em3" "err" }
	  if { $e4 } { showScantext  "e4: $em4" "err" }
	  if { $e5 } { showScantext  "e5: $em5" "err" }
	  if { $e6 } { showScantext  "e6: $em6" "err" }
	} else {
#	    puts $scanres $chanparms ; incr ichans ;# OK: store results in scan file
	} ;# end if bad channel
      } ;# end while processing out1 + out2 for actual transponder
#######################################################################################
#
#   results from transponder #it ready in 'found' list
#   evaluate + classify the resulting channels, update the lists of the results
#
#  build 'old'-list: all chans for this transponder in 'untouched'-list
      set tp [split $trap : ]
      set pattern "[lindex $tp 1]:[lindex $tp 2]:[lindex $tp 3]:[lindex $tp 4]"
      set old "" ; set ptrlist [lsearch -all $untall "*$pattern*"]
      foreach ptr $ptrlist {  set item [lindex $untall $ptr]
                              lappend old [lindex $untall $ptr] };# old chans,act.trpr
#  delete 'old' from 'untouched'-list:
      set invptrlist [ lsort -integer -decreasing $ptrlist ]  ;# higher indices first
      foreach ptr $invptrlist { set untall [lreplace $untall $ptr $ptr] }
#  process found chans: if in 'old': add to 'confirmed'; if not in 'old': add to 'new'
      set conf "" ; set new "" ; set lost ""
      foreach chan  $found {  set ptr [lsearch $old $chan]
        	if {$ptr >= 0 } { lappend conf $chan } else { lappend new  $chan  } }
# if in 'old', but not 'found': add to 'lost'
      foreach chan  $old { if { [lsearch $found $chan] < 0 } { lappend lost $chan } }
      foreach chan  $found { lappend fndall $chan }
#
#  count the resulting channels + update the counters for each transponder + for all
#
      set nconf  [llength $conf]   ; set ntconf  [expr $nconf +$ntconf]  ;# confirmed
      set nnew   [llength $new]    ; set ntnew   [expr $nnew  +$ntnew]   ;# new
      set nlost  [llength $lost]   ; set ntlost  [expr $nlost +$ntlost]  ;# lost
      set nunt   [llength $untall] ; set ntunt   [llength $untall]       ;# untouched
      set nfound [llength $found]  ; set ntfound [expr $nfound+$ntfound] ;# found
      set nold   [llength $old]    ; set ntold   [expr $nold  +$ntold]   ;# old
      set logln0 "Trp.$it of $nt; found= $nfound; conf= $nconf; new= $nnew; "
      set logln2 "${logln0}lost= $nlost; old= $nold*"
      lappend logall $logln2
      showScantext $logln2 "log" ;# show transponder data in the doScan2 window
#  status report for new version
      set tstat3 "$ntfound $ms585 $ntnew $ms586"
      set tstat4 "$ntconf $ms587 $ntlost $ms588" ; set tstat5 "$ntunt $ms589"
#
#  add this transponder to the result files
#
      if {![catch {open $logpath a } fil ] } {
	            puts $fil $logln1 ; puts $fil $logln2 ; close $fil }
      set fndfil $foundpath-$it
      if {![catch {open $fndfil a } fil ] } {
	              foreach item $found { puts $fil $item } ; close $fil }
      set oldfil $oldpath-$it
      if {![catch {open $oldfil a } fil ] } {
	              foreach item $old   { puts $fil $item } ; close $fil }
      set confil $confpath-$it
      if {![catch {open $confil a } fil ] } {
	              foreach item $conf  { puts $fil $item } ; close $fil }
      set newfil $newpath-$it
      if {![catch {open $newfil a } fil ] } {
	              foreach item $new   { puts $fil $item } ; close $fil }
      set lostfil $lostpath-$it
      if {![catch {open $lostfil a } fil ] } {
	              foreach item $lost  { puts $fil $item } ; close $fil }
#  add this transponder to the 'all' files
      exec cat $fndfil  >> $foundpath-all
      exec cat $oldfil  >> $oldpath-all
      exec cat $confil  >> $confpath-all
      exec cat $newfil  >> $newpath-all
      exec cat $lostfil >> $lostpath-all
      exec cat $out1    >> $out1path-all
      exec cat $out2    >> $out2path-all
#
#  add this transponder to the doScan2 window
#
      foreach item $old      { showScantext $item "old"  }
      foreach item $conf     { showScantext $item "conf" }
      foreach item $new      { showScantext $item "new"  }
      foreach item $lost     { showScantext $item "lost" }
      foreach item $found    { showScantext $item "fnd"  }
      foreach item $outlist1 { showScantext $item "out1" }
      foreach item $outlist2 { showScantext $item "out2" }
      $scantext see end
#
#   this transponder done: proceed to next line of transponder list
    } ;# end foreach trap: next transponder, if any
#
#*************************************************************************************************
#  ***  end of transponder list: scan terminated  ***
#*************************************************************************************************
#
    set untctr 0
    if {![catch {open "$untpath-all" w } fil ] } {
	              foreach item $untall { puts $fil $item } ; close $fil }
    foreach item $logall  { showScantext $item "logall" }
    foreach item $ctlall  { showScantext $item "ctlall" }
    foreach item $untall  { showScantext $item "untall" }
    foreach item $fndall  { showScantext $item "fndall" }
#
    if { $smode == 3 } {
      set tstat1 $ms593 ; set tstat2 $scantrap ;# manual
    } else {
      set tstat1 "$ms590 [file tail $flscan] $ms591"; set tstat2 "$nt $ms361"
    }
    set tstam  $ms592
    endScan ;# set the key labels
#  save all found channels as 'fscres':
    set e13 [ catch { exec cp -f "$foundpath-all" $fscres } res ]
    if { $e13 } { Err c13 $res ; return }
  } ;# end proc. autoScan
#
#*************************************************************************************************
#   proc. showlevel displays the signal level
#*************************************************************************************************
proc showlevel { w } {
    if { [catch { set wind [winfo exists $w ]}] } { return } ; if { !$wind } { return }
    if { ![catch {exec which pegel} pegelpath ] } {
      set err1 [ catch { exec pegel } siglevel]
      if { $err1 } { set siglevel 0 } ;  $w set $siglevel ; after 2000 showlevel $w
    } ;# end if pegel is installed
  } ;# end proc. showlevel
#
#*************************************************************************************************
#   Proc. showScantext { chantext typ } updates the scan text                         *
#*************************************************************************************************
#
proc showScantext { chantext chantag } {
    global scantext f1 f3
#
    catch { $scantext configure -state normal }
    if { $chantag == "reset" } { catch { $scantext delete 1.0 end } ; return } ;# wipe
#
    if { ($chantag == "log") || ($chantag == "logall") } {
      $scantext insert end $chantext\n $chantag
    } elseif { $chantag == "err" } {
      $scantext insert end $chantext\n {log logall err}
    } elseif { ($chantag == "ctl") || ($chantag == "ctlall") } {
      $scantext insert end $chantext\n $chantag
    } else {
      set chanparms [split  $chantext : ]
      set satnbr 0 ; catch { set satnbr [lindex $chanparms 3 ] }
      set vpid   0 ; catch { set vpid   [lindex $chanparms 5 ] }
      if { $satnbr == 0 } { set sattag sat0 } else { set sattag sat1 }
      if { $vpid   == 0 } { set tvtag radio } else { set tvtag tv    }
      regsub : $chantext \t item  ;# replace firstst ':' by tab
      $scantext insert end $item\n "$chantag $sattag $tvtag"
    } ;# end update scantext
    update ;
    catch { $scantext see end } ; catch { $scantext configure -state disabled }
#    set f1 {-*-"Courier New"-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
#    $scantext configure -state disabled -spacing1 5 -spacing2 5
  } ;# end proc. showScantext
#
#
#*************************************************************************************************
#  proc.doShow shows or elides a tagged part of scantext
#
proc doShom { shownbr showtag } {
    global shom0  shom1  shom2  shom3  shom4  shom5  shom6 shom7 shom8 shom9 shom10
    global shom11 shom12 shom13 shom14 shom15 sv1 sv2 sv3 sv4  scantext
    update ;
#    set mod {$shom}$shownbr
    set cmd1 {set mode [expr !$shom} ; set cmd "$cmd1$shownbr]" ; eval $cmd
    $scantext tag configure $showtag -elide $mode
  } ;# end proc.doShom
#
#  proc.doShow shows or elides a tagged part of scantext
#
proc markRadio {  } {
    global scantext shom11 f1 f3
    update ;  set mode $shom11 ; set ft00 "Courier 12 bold italic"
    if { $mode } { $scantext tag configure "radio" -font $ft00
          } else { $scantext tag configure "radio" -font $f1 }
  } ;# end proc.markRadio
#
#*************************************************************************************************
# proc.saveScan {  } saves the selected scan results                                  *
#*************************************************************************************************
#  <<<<<<<<<<<<<<<<<<<    obsolete ???????????????????????????????????????
proc saveScan { } {
    global smode blist fscres presel confpath newpath lostpath untpath foundpath
    global sv1 sv2 sv3 sv4 tstat1 tstat2 tstat3 tstat4 tstat5 tstam
    global ms301 ms302 ms303 ms304 ms305 ms306 ms307 ms308 ms309
#"Keine Daten von Listen-Suchlauf gefunden;","kann dvb-Daten nicht speichern."
#"Ergebnisse abgespeichert:","bestätigte,","nicht-betroffene,"
#"neue,","entfallene.","Ergebnis abgespeichert,","Sender."
    update ;  set pg "saveScan" ; set dir0 [file dirname $fscres]
    if { $smode == 2 } {
# dvb-mode: copy result file into fscres + preselection
      set sout1 $dir0/tmp1/dvb-out1
      set e21 [ catch { exec cp -p $sout1 $presel } res ]
      if { $e21 } { Err1 21 $pg $res ; return }
      set e22 [ catch { exec cp -p $sout1 $fscres } res ]
      if { $e22 } { Err1 22 $pg $res ; return }
    } else {
# list mode
      set otbuf "" ; set nc 0 ; set nu 0 ; set nn 0 ; set nl 0
      set m1 $ms301
      set m2 "\nProc.$pg $ms302"
#
      if { $sv1 } { set e3 [ catch { open "$confpath-all" } fin ]
        if { $e3 }   { Err1 3 $pg "$m1$m2"  ; return }
        while { ![ eof $fin ] } { set e4 [ catch { gets $fin } curl ]
          if { $e4 } { Err1 4 $pg $curl  ; return }
          if { [ string length $curl ] } { lappend otbuf $curl ; incr nc }
        } ; catch { close $fin }
      } ;# if sv1
#
      if { $sv2 } { set e5 [ catch { open "$untpath-all" } fin ]
        if { $e5 } { Err1 5 $pg $fin ; return }
        while { ![ eof $fin ] } { set e6 [ catch { gets $fin } curl ]
          if { $e6 } { Err1 6 $pg $curl; return }
          if { [ string length $curl ] } { lappend otbuf $curl ; incr nu }
        } ; catch { close $fin }
      } ;# if sv2
#
      if { $sv3 } { set e7 [ catch { open "$newpath-all" } fin ]
        if { $e7 } { Err1 7 $pg $fin; return }
        while { ![ eof $fin ] } { set e8 [ catch { gets $fin } curl ]
          if { $e8 } { Err1 8 $pg $curl; return }
          if { [ string length $curl ] } { lappend otbuf $curl ; incr nn }
        } ; catch { close $fin }
      } ;# if sv3
#
      if { $sv4 } { set e9 [ catch { open "$lostpath-all" } fin ]
        if { $e9 } { Err1 9 $pg $fin; return }
        while { ![ eof $fin ] } { set e10 [ catch { gets $fin } curl ]
	  if { $e10 } { Err1 10 $pg $curl; return }
          if { [ string length $curl ] } { lappend otbuf $curl ; incr nl }
        } ; catch { close $fin }
      } ;# if sv4
#
      set e11 [ catch { open $presel w } fot ]
      if { $e11 } { Err1 11 $pg $fot; return }
      foreach curl $otbuf { set e12 [ catch { puts $fot $curl } erms ]
        if { $e12 } { Err1 12 $pg $erms; return }
      } ; catch { close $fot } ; set otbuf "" ;# end foreach: close file
#  save all found channels as 'fscres':
      set e13 [ catch { exec cp -f "$foundpath-all" $fscres } res ]
      if { $e13 } { Err1 13 $pg $res ; return }
#
      set nt [expr $nc + $nu + $nn + $nl ] ; set tstat1 $ms303
      set tstat2 "$nc $ms304" ; set tstat3 "$nu $ms305"
      set tstat4 "$nn $ms306" ; set tstat5 "$nl $ms307"
      set res [file tail $fscres] ;   set tstam  "$ms308 $nt $ms309"
    } ;# end if list mode
  } ;# end proc.saveScan
#
#######################################################################################
#*************************************************************************************************
#  proc. doEdit { } allows to edit the scan results or other channel files            *
#*************************************************************************************************
#
proc doEdit { } {
    global lmod lnew ltab smod snew omod fmod expert limod
    global scam1 scam2 scam3 scam4 scam5
    global ted0a ted0b ted0c ted1a ted1b ted1c ted3a ted3b ted3c
    global etx edi mod myVersion0 scantext f1 f3
    global shom0 shom1 shom2 shom3 shom4 shom5 shom6 shom7 shom8 shom9 shom10 shom11
    global shom12 shom13 shom14 shom15 sv1 sv2 sv3 sv4
    global ms11  ms70 ms161 ms370 ms371 ms372 ms373 ms374 ms376 ms377 ms379
    global ms380 ms381 ms382 ms149 ms147 ms435 ms436 ms441 ms442 ms443 ms444 ms445
    global ms446 ms447 ms448 ms449 ms451
    global ms601 ms602 ms603 ms604 ms605 ms606 ms607 ms608 ms609
    global ms610 ms611 ms612 ms613 ms614 ms615 ms616 ms617 ms618 ms619
    global ms620 ms621 ms622 ms623 ms624 ms626 ms627 ms628 ms629
    global ms630 ms631 ms632 ms633 ms634 ms635 ms636 ms637 ms638 ms639
    global ms640 ms641 ms642 ms643 ms644 ms645 ms646 ms647 ms648 ms649
    global ms651 ms652 ms653 ms654 ms655 ms656 ms657
#
#"Teclasat: Editor","Expertenmodus","Laden","Editor","Speichern","Hilfe","Suchlauf"
#"OK","Ausklappen","abbrechen","Hauptliste laden","Ergebnisdatei","andere Datei"
#"Dateiwahl","Suchlaufergebnis","Hauptliste einstufen","neue Sender anfügen"
#"entfallene Sender löschen","\[xyz\]-Sender löschen","Radios markieren","Im Editor"
#"neu laden","Text anfügen","2-spaltig","Zeilenmodus","Ausschneiden","Kopieren"
#"Einfügen","^ auf",#"v ab","Anzeige","Einstufen","Filtern","Sortieren" ,"Hilfe",
#"Sendertest","Speichern als:""Suchlaufergebnis","Hilfsdatei","Dateiwahl",
#"neu speichern","anfügen","Speichern als:","Einstufen","Leider noch nicht fertig"
#"Filtern: Auswahl","Filtern: löschen","\[xyz\] ","Duplikate","Sender löschen"
#"entfallene","nichtbetroffene","bestätigte","neue",
    set wed .doEdit
    if { [winfo exists $wed ] } {  return }
#                     tk_messageBox -type ok -icon info -message $ms161  ;
    toplevel $wed ; wm title $wed $ms601 ; wm geometry $wed -40-80
#
#   main frame of 'list processor'
#
    set etx $wed.text   ; frame $etx
    set editext $etx.t
    text $editext -width 80 -height 20 -wrap word \
            -xscrollcommand "$etx.xsbar set" -yscrollcommand "$etx.ysbar set"
    scrollbar $etx.xsbar -orient horizontal -command "$etx.t xview"
    scrollbar $etx.ysbar -orient vertical   -command "$etx.t yview"
    grid $editext $etx.ysbar -sticky nsew
    grid $etx.xsbar -sticky nsew
    grid columnconfigure $etx 0 -weight 1
    grid rowconfigure    $etx 0 -weight 1
#
    $editext tag configure "conf"   -foreground darkgreen    -elide 0 ;# b11
    $editext tag configure "new"    -foreground darkred      -elide 0 ;# b2
    $editext tag configure "lost"   -foreground magenta      -elide 0 ;# b3 darkcyan
    $editext tag configure "unt"    -foreground black        -elide 0 ;# b4
#
#    $editext tag configure "tv"     -font $f1
#    $editext tag configure "radio"  -font $f1
#
#  'ed0' field: main status info, main control keys
#  col.#1
    set edi $wed.but ; set ed0 ${edi}0 ; frame $ed0
    set ed0a $ed0.a ; labelframe $ed0a ;# "Laden, Bearbeiten, Speichern"
    checkbutton $ed0a.ex -text $ms602 -variable expert
    button $ed0a.b0 -text $ms603 -width 9 -command "packLoad"
    button $ed0a.b1 -text $ms11  -width 9 -command "packEd 2"
    button $ed0a.b2 -text $ms605 -width 9 -command "packSave"
    pack   $ed0a.ex -anchor w
    pack   $ed0a.b0 $ed0a.b1 $ed0a.b2
#  col.#2 (right): system
    set ed0b $ed0.b ; labelframe  $ed0b
    button $ed0b.b0 -text $ms606 -width 9 -command "doHelp"
    button $ed0b.b1 -text $ms607 -width 9 -command "configScan"
    button $ed0b.b2 -text $ms70  -width 9 -command "catch {destroy .doEdit}"
    pack  $ed0b.b0 $ed0b.b1 $ed0b.b2
#
#  left frame: info field
    set ted0a "" ; set ted0b "" ; set ted0c ""
    set ed0c $ed0.c ; labelframe $ed0c ;# getLoadtext ????????????????????
    label  $ed0c.t1 -width 35 -anchor w -textvariable ted0a
    label  $ed0c.t2 -width 35 -anchor w -textvariable ted0b
    label  $ed0c.t3 -width 35 -anchor w -textvariable ted0c
    pack  $ed0c.t1 $ed0c.t2 $ed0c.t3
    pack  $ed0b $ed0a -side right -pady 2 -padx 16
    pack  $ed0c -side right -pady 2 -padx 16
    pack  $ed0 $etx -side bottom -pady 2 -padx 2
#
#*************************************************************************************************
#  button fields for edit mode #1=load, #2=modify/editor, #3=save
#*************************************************************************************************
#
#  ed1: load data files, short version
#
    set ed1 ${edi}1 ; frame  $ed1
#   status info
    set ed1a $ed1.a ; labelframe $ed1a ; getLoadtext
    label  $ed1a.t1 -width 35 -anchor w -textvariable ted1a
    label  $ed1a.t2 -width 35 -anchor w -textvariable ted1b
    label  $ed1a.t3 -width 35 -anchor w -textvariable ted1c
    pack  $ed1a.t1 $ed1a.t2 $ed1a.t3
#
#   doit: buttons
    set ed1b $ed1.b ; labelframe $ed1b
    button $ed1b.b0 -text $ms608 -width 9 -command "loadList ; packEd 0"
    button $ed1b.b1 -text $ms609 -width 7 -command "packEd 11"
    button $ed1b.b2 -text $ms610 -width 7 -command "packEd 0"
    pack  $ed1b.b0 -padx 2 -pady 2 ; pack $ed1b.b2
    pack  $ed1a $ed1b -side left -pady 2 -padx 16
#
#*************************************************************************************************
#  ed11: load data files, long version:  "Laden von ... Basisliste etc
#
    set ed11 ${edi}11 ; frame  $ed11
#  left frame
    set ed11f1  $ed11.left  ; frame $ed11f1
    set ed11fa $ed11f1.fa   ; frame $ed11fa
# upper frame, column #1: load the main list
    set ed11a $ed11fa.a  ; labelframe $ed11a -text $ms611
    set ed11a1 $ed11a.f1 ; frame $ed11a1
    radiobutton $ed11a1.lb1 -text $ms149 -variable lmod -value 1 \
                           -relief flat -width 12 -anchor w -command "getLoadtext"
    radiobutton $ed11a1.lb2 -text $ms147 -variable lmod -value 2 \
                           -relief flat -width 12 -anchor w -command "getLoadtext"
    radiobutton $ed11a1.lb3 -text $ms435 -variable lmod -value 3 \
                           -relief flat -width 12 -anchor w -command "getLoadtext"
    radiobutton $ed11a1.lb4 -text $ms436 -variable lmod -value 4 \
                           -relief flat -width 12 -anchor w -command "getLoadtext"
    pack $ed11a1.lb1 $ed11a1.lb2 $ed11a1.lb3 $ed11a1.lb4 -anchor w
#
    set ed11a2 $ed11a.f2 ; frame $ed11a2
    radiobutton $ed11a2.lb5 -text $ms612 -variable lmod -value 5 \
                           -relief flat -width 12 -anchor w -command "getLoadtext"
    set ed11a6 $ed11a2.f6 ; labelframe $ed11a6
    radiobutton $ed11a6.lb6 -text $ms613  -variable lmod -value 6 \
                                                -relief flat -command "getLoadtext"
    button $ed11a6.b6 -text $ms614  -width 9 -command "getMyscan1 $wed"
    pack $ed11a6.lb6 -anchor w ; pack $ed11a6.b6 -anchor e
    pack $ed11a2.lb5 $ed11a6 -anchor w
    pack $ed11a1 $ed11a2 -side left
#
# upper frame, column #2: scan result
    set scam1 1 ; set scam2 1 ; set scam3 1 ; set scam4 1 ; set scam5 0
    set ed11b  $ed11fa.b ; labelframe $ed11b -text $ms615
    checkbutton $ed11b.cb1 -text $ms616 -variable scam1 -relief flat -command ""
    checkbutton $ed11b.cb2 -text $ms617 -variable scam2 -relief flat -command ""
    checkbutton $ed11b.cb3 -text $ms618 -variable scam3 -relief flat -command ""
    checkbutton $ed11b.cb4 -text $ms619 -variable scam4 -relief flat -command ""
    checkbutton $ed11b.cb5 -text $ms620 -variable scam5 -relief flat -command ""
    pack $ed11b.cb1 $ed11b.cb2 $ed11b.cb3 $ed11b.cb4 $ed11b.cb5 -anchor w
    pack $ed11a $ed11b -side left -padx 8
#
#  left frame, lower frame: info field
    set ed11c $ed11f1.fc ; labelframe $ed11c ; getLoadtext
    label  $ed11c.t1 -width 35 -anchor w -textvariable ted1a
    label  $ed11c.t2 -width 35 -anchor w -textvariable ted1b
    label  $ed11c.t3 -width 35 -anchor w -textvariable ted1c
    pack  $ed11c.t1 $ed11c.t2 $ed11c.t3
    pack  $ed11fa ; pack $ed11c -pady 8
#
# right, upper frame
    set ed11f2 $ed11.f2 ; frame $ed11f2
    set ed11d $ed11f2.d ; labelframe $ed11d -text $ms621
    radiobutton $ed11d.lb8 -text $ms622 -variable lnew -value 1 \
                                                -relief flat -command "getLoadtext"
    radiobutton $ed11d.lb9 -text $ms623 -variable lnew -value 0 \
                                                -relief flat -command "getLoadtext"
    checkbutton $ed11d.lb10 -text $ms624 -variable ltab \
                                                -relief flat -command "getLoadtext"
    pack $ed11d.lb8 $ed11d.lb9 $ed11d.lb10 -anchor w
#  right, lower frame: ctrl buttons
    set ed11e $ed11f2.e ; labelframe $ed11e
    button $ed11e.b0 -text $ms608 -width 9 -command "loadList ; packEd 0"
    button $ed11e.b1 -text $ms609 -width 7 -command "packEd 1"
    button $ed11e.b2 -text $ms610 -width 7 -command "packEd 0"
    pack  $ed11e.b0 -padx 2 -pady 2; pack $ed11e.b2
    pack $ed11e $ed11d -side bottom -pady 16
#
    pack  $ed11f2 $ed11f1 -side right -pady 2 -padx 8
#
#*************************************************************************************************
#  ed2: "Teclasat Editor"
#
    set ed2 ${edi}2 ; frame  $ed2
#   status info
    set eb2ed $ed2.ed ; labelframe $eb2ed
    checkbutton $eb2ed.mod -text $ms626 -variable limod \
                                      -command "$etx.t tag remove linsel 1.0 end"
    set eb2a $eb2ed.a ; frame $eb2a
    set eb2aa $eb2a.a ; labelframe $eb2aa
    button $eb2aa.b1 -text $ms627 -width 9 -command "doCut"
    button $eb2aa.b2 -text $ms628 -width 9 -command "doCopy"
    button $eb2aa.b3 -text $ms629 -width 9 -command "doPaste"
    pack  $eb2aa.b1 $eb2aa.b2 $eb2aa.b3
#    bind . <Control-KeyPress-x> "doCut   $etx"
#    bind . <Control-KeyPress-c> "doCopy  $etx"
#    bind . <Control-KeyPress-v> "doPaste $etx" ;# funzt nicht!
    $etx.t tag  configure "linsel"  -background red
    bind $etx.t <ButtonRelease-1> "doSelin"
#
    set eb2ab $eb2a.b ; frame $eb2ab
    button $eb2ab.b1 -text $ms630 -width 9 -command "doLineup"
    button $eb2ab.b2 -text $ms631 -width 9 -command "doLinedown"
    button $eb2ab.b3 -text $ms632 -width 9 -command "packEd 25"
    pack  $eb2ab.b1 $eb2ab.b2 $eb2ab.b3
    pack  $eb2aa $eb2ab -side left -padx 4
    pack $eb2ed.mod $eb2a -anchor w
#
    set eb2c  $ed2.b ; labelframe $eb2c
    button $eb2c.b1 -text $ms633 -width 9 -command "doClassify 1 0"
    button $eb2c.b2 -text $ms634 -width 9 -command "packEd 26"
    button $eb2c.b3 -text $ms635 -width 9 -command "packEd 27"
    pack  $eb2c.b1 $eb2c.b2 $eb2c.b3
#
    set eb2d  $ed2.d ; labelframe $eb2d
    button $eb2d.b1 -text $ms636 -width 9 -command "doHelp"
    button $eb2d.b2 -text $ms637 -width 9 -command "packEd 24"
    button $eb2d.b3 -text $ms70  -width 9 -command "packEd 0"
    pack  $eb2d.b1 $eb2d.b2 $eb2d.b3
    pack  $eb2ed $eb2c $eb2d -side left -padx 8 -pady 4 -anchor s
#
#*************************************************************************************************
#  ed3: store data, short version
#  sub-table: ed31
    set ed3 ${edi}3 ; frame $ed3
#   status info
    set ed3a $ed3.a ; labelframe $ed3a ; getSavetext
    label  $ed3a.t1 -width 35 -anchor w -textvariable ted3a
    label  $ed3a.t2 -width 35 -anchor w -textvariable ted3b
    label  $ed3a.t3 -width 35 -anchor w -textvariable ted3c
    pack  $ed3a.t1 $ed3a.t2 $ed3a.t3
#  right frame: ctrl buttons
    set ed3b $ed3.f2 ; labelframe $ed3b
    button $ed3b.b0 -text $ms608 -width 9 -command "saveList; packEd 0"
    button $ed3b.b1 -text $ms609 -width 7 -command "packEd 31"
    button $ed3b.b2 -text $ms610 -width 7 -command "packEd 0"
    pack  $ed3b.b0 -padx 2 -pady 2 ; pack $ed3b.b2
    pack  $ed3a $ed3b -side left -pady 2 -padx 16
#
#*************************************************************************************************
#  ed31: store data, extended version
    set ed31 ${edi}31 ; frame  $ed31
#  left frame
    set ed31a  $ed31.f1  ; frame $ed31a
    set ebu31a $ed31a.fa   ; labelframe $ebu31a -text $ms638
# upper frame, column #1
    set ec31a $ebu31a.a  ; frame $ec31a
    radiobutton $ec31a.rb1 -text $ms149 -variable smod -value 1 \
                           -width 14 -relief flat -anchor w -command "getSavetext"
    radiobutton $ec31a.rb2 -text $ms147 -variable smod -value 2 \
                                               -relief flat -command "getSavetext"
    radiobutton $ec31a.rb3 -text $ms435 -variable smod -value 3 \
                                               -relief flat -command "getSavetext"
    radiobutton $ec31a.rb4 -text $ms436 -variable smod -value 4 \
                                               -relief flat -command "getSavetext"
    pack $ec31a.rb1 $ec31a.rb2  $ec31a.rb3 $ec31a.rb4 -anchor w
# upper frame, column #2
    set ec31b   $ebu31a.b ; frame $ec31b
    set ec31b1  $ec31b.a  ; labelframe $ec31b1
    radiobutton $ec31b1.rb5 -text $ms639 -variable smod -value 5 \
                            -width 14 -relief flat -anchor w -command "getSavetext"
    pack $ec31b1.rb5 -anchor w
    set ec31b2 $ec31b.b ; labelframe $ec31b2
    radiobutton $ec31b2.rb6 -text $ms640 -variable smod -value 6 \
                                                -relief flat -command "getSavetext"
    button $ec31b2.b1 -text $ms641 -width 9 -command "getMyscan2"
    pack $ec31b2.rb6 -anchor w ; pack $ec31b2.b1 -anchor e
    pack $ec31b1 $ec31b2 -expand 1 -fill x
# upper frame, column #3
    set ec31c $ebu31a.c ; labelframe $ec31c
    radiobutton $ec31c.lb8 -text $ms642 -variable snew -value 1 \
                                                -relief flat -command "getSavetext"
    radiobutton $ec31c.lb9 -text $ms643 -variable snew -value 0 \
                                                -relief flat -command "getSavetext"
    pack $ec31c.lb8 $ec31c.lb9 -anchor w
    pack $ec31a $ec31b $ec31c -side left
#
#  lower frame: info field
    set ebu31b $ed31a.fb ; labelframe $ebu31b ; getSavetext
    label  $ebu31b.t1 -width 35 -anchor w -textvariable ted3a
    label  $ebu31b.t2 -width 35 -anchor w -textvariable ted3b
    label  $ebu31b.t3 -width 35 -anchor w -textvariable ted3c
    pack  $ebu31b.t1 $ebu31b.t2 $ebu31b.t3
    pack  $ebu31a $ebu31b -pady 8
#
#  right frame: ctrl buttons
    set ed31b $ed31.f2 ; labelframe $ed31b
    button $ed31b.b0 -text $ms608 -width 9 -command "saveList ; packEd 0"
    button $ed31b.b1 -text $ms609 -width 7 -command "packEd 3"
    button $ed31b.b2 -text $ms610 -width 7 -command "packEd 0"
    pack  $ed31b.b0 -padx 2 -pady 2; pack $ed31b.b2
    pack  $ed31a $ed31b -side left -pady 2 -padx 16
#
#*************************************************************************************************
#  ed21: "Einstufen"
#
    set ed21 ${edi}21 ; labelframe  $ed21 -text $ms633
#   status info
    set eb21a $ed21.a ; labelframe $eb21a
    label  $eb21a.t1 -text "" -width 20 -anchor w -textvariable ted1
    label  $eb21a.t2 -text $ms646 -width 20 -anchor w
    label  $eb21a.t3 -text "" -width 20 -anchor w -textvariable ted3
    pack  $eb21a.t1 $eb21a.t2 $eb21a.t3 -side left
#
#   doit: buttons
    set eb21b $ed21.right ; labelframe $eb21b
    button $eb21b.b1 -text "" -width 9 -command ""
    button $eb21b.b2 -text $ms70   -width 9 -command "packEd 2"
    pack  $eb21b.b1 $eb21b.b2
    pack  $eb21a $eb21b -side left
#
#*************************************************************************************************
#  ed22: "Filtern",  short version (extended version -> #26)
#
    set ed22 ${edi}22 ; frame  $ed22
#   status info
    set ed22a $ed22.a ; labelframe $ed22a -text $ms441 ;#>>>>>>>>>>>>>> getFiltext
    label  $ed22a.t1 -width 35 -anchor w -textvariable ted22a
    label  $ed22a.t2 -width 35 -anchor w -textvariable ted22b
    label  $ed22a.t3 -width 35 -anchor w -textvariable ted22c
    pack  $ed22a.t1 $ed22a.t2 $ed22a.t3
#
#  right frame: ctrl buttons
    set ed22b $ed22.b ; labelframe $ed22b
    button $ed22b.b0 -text $ms608 -width 9 -command "packEd 0"
    button $ed22b.b1 -text $ms609 -width 9 -command "packEd 26"
    button $ed22b.b2 -text $ms70  -width 9 -command "packEd 2"
    pack  $ed22b.b0 -padx 2 -pady 2 ; pack $ed22b.b2
    pack  $ed22a $ed22b -side left -padx 8 -pady 4
#
#*************************************************************************************************
#  ed26: "Filtern" extended version;   (short version -> #22)
#  "Filtern":  filter the channel list: TV, Radio, Sat0, sat1.
    set ed26 ${edi}26 ; frame  $ed26
#
    set ed26a $ed26.a ; labelframe  $ed26a -text $ms647
    radiobutton $ed26a.rb1 -text $ms442 -variable fmod -value 1 -relief flat \
                                                               -width 12  -anchor w
    radiobutton $ed26a.rb2 -text $ms443 -variable fmod -value 2 -relief flat
    radiobutton $ed26a.rb3 -text $ms444 -variable fmod -value 3 -relief flat
    radiobutton $ed26a.rb4 -text $ms445 -variable fmod -value 4 -relief flat
    pack $ed26a.rb1 $ed26a.rb2 $ed26a.rb3 $ed26a.rb4 -anchor w
#
    set ed26b $ed26.b ; labelframe  $ed26b -text $ms648
    radiobutton $ed26b.rb1 -text "\[xyz\] " -variable fmod -value 5 \
                                -relief flat -width 12  -anchor w
    radiobutton $ed26b.rb2 -text $ms651 -variable fmod -value 6 -relief flat
    radiobutton $ed26b.rb3 -text "" -variable fmod -value 7 -relief flat
    radiobutton $ed26b.rb4 -text "" -variable fmod -value 8 -relief flat
    pack $ed26b.rb1 $ed26b.rb2 $ed26b.rb3 $ed26b.rb4 -anchor w
# filter, 3rd col: delete channel types
    set ed26d $ed26.d ; labelframe  $ed26d -text $ms652
    radiobutton $ed26d.rb1 -text $ms653 -variable fmod -value 9 \
                                     -relief flat -width 12  -anchor w
    radiobutton $ed26d.rb2 -text $ms654 -variable fmod -value 10 -relief flat
    radiobutton $ed26d.rb3 -text $ms655 -variable fmod -value 11 -relief flat
    radiobutton $ed26d.rb4 -text $ms656 -variable fmod -value 12 -relief flat
    pack $ed26d.rb1 $ed26d.rb2 $ed26d.rb3 $ed26d.rb4 -anchor w
#  right frame: ctrl buttons
    set ed26c $ed26.c ; labelframe $ed26c
    button $ed26c.b0 -text $ms608 -width 9 -command "filterList 0"
    button $ed26c.b1 -text $ms609 -width 7 -command "packEd 22"
    button $ed26c.b2 -text $ms610 -width 7 -command "packEd 2"
    pack  $ed26c.b0 -padx 2 -pady 2 ; pack $ed26c.b2
    pack  $ed26a $ed26b $ed26d $ed26c -side left -padx 8 -pady 4
#
#*************************************************************************************************
#  ed23: "Sortierenshort form" (extended version -> #27)
#
    set ed23 ${edi}23 ; frame  $ed23
#   status info
    set ed23a $ed23.a ; labelframe $ed23a -text $ms446 ;#>>>>>>>>>>>>>>>> getFiltext
    label  $ed23a.t1 -width 35 -anchor w -textvariable ted23a
    label  $ed23a.t2 -width 35 -anchor w -textvariable ted23b
    label  $ed23a.t3 -width 35 -anchor w -textvariable ted23c
    pack  $ed23a.t1 $ed23a.t2 $ed23a.t3
#
#  right frame: ctrl buttons
    set ed23b $ed23.b ; labelframe $ed23b
    button $ed23b.b1 -text $ms609 -width 9 -command "packEd 27"
    button $ed23b.b2 -text $ms608 -width 9 -command "sortList 0"
    button $ed23b.b3 -text $ms610 -width 9 -command "packEd 2"
    pack  $ed23b.b1 $ed23b.b2 $ed23b.b3
    pack  $ed23a $ed23b -side left -padx 8 -pady 4
#
#*************************************************************************************************
#  ed27: "Sortieren, extended form" (short version -> #23)
#
    set ed27 ${edi}27 ; frame  $ed27
#  "Sortieren": sort the channel fileby frequency, ABC, TV/Radio, sat0/sat1
    set ed27a $ed27.a ; labelframe $ed27a -text $ms446
    radiobutton $ed27a.rb1 -text $ms448 -variable omod -value 1 -relief flat \
                                                               -width 12  -anchor w
    radiobutton $ed27a.rb2 -text $ms447 -variable omod -value 2 -relief flat
    radiobutton $ed27a.rb3 -text $ms449 -variable omod -value 3 -relief flat
    radiobutton $ed27a.rb4 -text $ms451 -variable omod -value 4 -relief flat
    pack  $ed27a.rb1 $ed27a.rb2 $ed27a.rb3 $ed27a.rb4 -anchor w
#  right frame: ctrl buttons
    set ed27c $ed27.c ; labelframe $ed27c
    button $ed27c.b0 -text $ms608 -width 9 -command "sortList 0"
    button $ed27c.b1 -text $ms656 -width 7 -command "packEd 23"
    button $ed27c.b2 -text $ms70  -width 7 -command "packEd 2"
    pack  $ed27c.b0 -padx 2 -pady 2 ; pack $ed27c.b2
    pack  $ed27a $ed27c -side left -padx 8 -pady 4
#
#*************************************************************************************************
#  ed24: "Sendertest"
#
    set ed24 ${edi}24 ; labelframe  $ed24 -text "**Sender-Test**"
#   status info
    set eb24a $ed24.a ; labelframe $eb24a
    label  $eb24a.t1 -text "" -width 20 -anchor w -textvariable ted1
    label  $eb24a.t2 -text $ms646 -width 20 -anchor w
    label  $eb24a.t3 -text "" -width 20 -anchor w -textvariable ted3
    pack  $eb24a.t1 $eb24a.t2 $eb24a.t3 -side left
#
#   doit: buttons
    set eb24b $ed24.right ; labelframe $eb24b
    button $eb24b.b1 -text ""    -width 9 -command "packEd 2"
    button $eb24b.b2 -text $ms70 -width 9 -command "packEd 2"
    pack  $eb24b.b1 $eb24b.b2
    pack  $eb24a $eb24b -side left
#
#*************************************************************************************************
#  ed25: "**Anzeigen**"
#
    set ed25 ${edi}25 ; labelframe  $ed25 -text "**Anzeigen**"
#   status info
    set eb25a $ed25.a ; labelframe $eb25a
    label  $eb25a.t1 -text "" -width 20 -anchor w
    label  $eb25a.t2 -text $ms646 -width 20 -anchor w
    label  $eb25a.t3 -text "" -width 20 -anchor w
    pack  $eb25a.t1 $eb25a.t2 $eb25a.t3 -side left
#
#   doit: buttons
    set eb25b $ed25.right ; labelframe $eb25b
    button $eb25b.b1 -text ""    -width 9 -command "packEd 2"
    button $eb25b.b2 -text $ms70 -width 9 -command "packEd 2"
    pack  $eb25b.b1 $eb25b.b2
    pack  $eb25a $eb25b -side left

  } ;# end proc.doEdit
#
#*************************************************************************************************
# proc.packEd { enb } packs button field $edi for the edit mode $enb
#*************************************************************************************************
#
proc packEd { enb } {
    global etx edi
    foreach nb {0 1 2 3 4 11 21 22 23 24 25 26 27 31} { catch { pack unpack $edi$nb } }
    pack unpack $etx
    pack $edi$enb $etx -side bottom  -pady 2 -padx 2
    if { $enb == 2 } { $etx.t configure -state normal
    }    else        { $etx.t configure -state disabled }
  } ;# end proc.packEd
#
#
#*************************************************************************************************
# proc.packLoad { } packs sub-menu 'Load', expert on/off
#*************************************************************************************************
#
proc packLoad { } {
    global etx expert
    if { $expert } { packEd 11 } else { packEd 1 }
  } ;# end proc.packLoad
#
#*************************************************************************************************
# proc.packLoad { } packs sub-menu 'Load', expert on/off
#*************************************************************************************************
#
proc packSave { } {
    global etx expert
    if { $expert } { packEd 31 } else { packEd 3 }
  } ;# end proc.packSave
#
#*************************************************************************************************
# proc.getLoadtext { } stores the text for the 'load' info                            *
#*************************************************************************************************
#
proc getLoadtext { } {
    global ted1a ted1b ted1c lmod lnew
    global blist wlist favo1 favo2 fscres fmylis presel
    global ms149 ms147 ms435 ms436 ms310 ms311 ms312 ms313 ms314 ms315 ms316
#"Suchlaufergebnis","Hilfsdatei","Vorauswahl","laden","anfügen"
#"Datei =","Verzeichnis ="
    update
      switch  $lmod  {
        1  { set listfile $blist  ; set fname $ms149 }
        2  { set listfile $wlist  ; set fname $ms147 }
	3  { set listfile $favo1  ; set fname $ms435 }
	4  { set listfile $favo2  ; set fname $ms436 }
	5  { set listfile $fscres ; set fname $ms310 }
        6  { set listfile $fmylis ; set fname $ms311 }
        7  { set listfile $presel ; set fname $ms312 }
      } ;# end switch $lmod
      if { $lnew } { set act $ms313 } else { set act $ms314 }
      set ted1a "$fname $act" ;     set ted1b "$ms315 [file tail $listfile]"
      set ted1c "$ms316 [file dirname $listfile]"
  } ;# end proc.getLoadtext
#
#*************************************************************************************************
# proc.getSavetext { } stores the text for the 'save' info
#*************************************************************************************************
#
proc getSavetext { } {
    global ted3a ted3b ted3c smod snew blist wlist favo1 favo2 fscres fmylis
    global ms294 ms295 ms296 ms149 ms147 ms435 ms436
    update
      switch  $smod  {
        1  { set listfile $blist      ; set fname $ms149 }
        2  { set listfile $wlist      ; set fname $ms147 }
	3  { set listfile $favo1     ; set fname $ms435 }
	4  { set listfile $favo2     ; set fname $ms436 }
	5  { set listfile $fscres ; set fname Suchlaufergebnis }
	6  { set listfile $fmylis     ; set fname Hilfsdatei }
      } ;# end switch $lmod
     if { $snew } { set ted3a "$ms294 $fname" } else { set ted3a "$ms295 $fname" }
     set ted3b "$fname = [file tail $listfile]"
     set ted3c "$ms296 [file dirname $listfile]"
  } ;# end getSavetext
#
#*************************************************************************************************
# Proc loadList { } loads the channel list for the editor (lnew = 1: clear screen)
#*************************************************************************************************
#
proc loadList { } {
    global etx blist wlist favo1 favo2 fscres fmylis
    global lmod smod lnew ltab scam1 scam2 scam3 scam4 scam5
    global ms120 ms121 ms473 ms124 ms320 ms321
#"wurde geladen", "wurde angefügt"
    switch  $lmod  {
        1  { set listfile $blist }
	2  { set listfile $wlist }
	3  { set listfile $favo1 }
	4  { set listfile $favo2 }
	5  { set listfile $fscres }
	6  { set listfile $fmylis }
      } ;# end switch
    set e1 [ catch { open $listfile r } fid ]
    if { $e1 } { Err e1 $fid ; return }
    if { $ltab } {
      set listtext "" ;# 2 columns: replace 1st ':' by tab
      while {![eof $fid]} {
        set e2 [ catch { gets $fid } curl ] ; if {$e2} {Err e2 $curl ; return}
        regsub : $curl \t tcurl ; append listtext "$tcurl\n"
      } ; close $fid ;# end while reading listfile
    } else {
      set listtext [read $fid] ; close $fid ;# store listfile in string 'listtext'
    } ;# if 2 or 1 columns
#
    $etx.t configure -state normal ;   markRadio1 $scam5
    if { $lnew } { $etx.t delete 1.0 end } ;# wipe the screen if 'load'
    $etx.t insert end $listtext
    set f1 {-*-Helvetica-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
    $etx.t configure -font $f1 -spacing1 5 -spacing2 5 -tabs 2.1i
#
    if { $scam1 || $scam2 } { doClassify $scam1 $scam2 } ;# classify, add new channels
    if { $scam3 } { filterList 9 } ;# remove lost channels
    if { $scam4 } { filterList 5 } ;# remove [xyz]
    if { $scam5 } { showList   1 } ;# mark radios, if desired
    $etx.t configure -state disabled
#
    set smod $lmod  ; set fname [file tail $listfile]
    if { $lnew } { set ted1a "$fname $ms320"
      } else     { set ted1a "$fname $ms321" }
 } ;# end proc.loadList
#
#*************************************************************************************************
# Proc getMyscan1 { } gets the name of fmylis "andere Datei" for loadList             *
#*************************************************************************************************
#
proc getMyscan1 { wp } {
    global fscres fmylis lmod ms120 ms121 ms124
    set dir0 [file dirname $fmylis]
    if {![file isdirectory $dir0]} { catch [exec mkdir -p $dir0 ]}
    set rep [tk_getOpenFile -initialdir $dir0 -title $ms124 -parent $wp ]
    if { $rep == "" } { return }  ;#  aborted
    if {![file exists $rep ]} then { tk_messageBox -type ok -icon info \
            -message "$ms120\n$rep\n$ms121" -parent $w ; return }
    set fmylis $rep ; set lmod 6 ; getLoadtext ; update
} ;# end proc.getMyscan1
#
#*************************************************************************************************
# Proc saveList { } saves the channel list                                            *
#*************************************************************************************************
#
proc saveList { } {
    global etx smod snew blist wlist favo1 favo2 fscres fmylis
    global ms120 ms323 ms324 ms474 ms476
# "Abgespeichert als $fname". "Angefügt an $fname"
    set listtext [$etx.t get 1.0 "end - 2 char"]
    switch  $smod  {
        1  { set listfile $blist }
	2  { set listfile $wlist }
	3  { set listfile $favo1 }
	4  { set listfile $favo2 }
	5  { set listfile $fscres }
	6  { set listfile $fmylis }
    } ;# end switch
#
    set ddir [file dirname $listfile]
    if {![file isdirectory $ddir]} { catch [exec mkdir -p $ddir ] }
    if { $snew } { set e1  [ catch { open $listfile w } fid ]
    } else {set e1  [ catch { open $listfile s } fid ] }
    if { $e1 } { Err e3 $fid ; return }
#  read text from screen line by line
    set ln 0 ; set tlin [lindex [ split [ $etx.t index "end - 1 char"] . ] 0 ]
    while { $ln <= $tlin } {
      incr ln ; set curl [$etx.t get $ln.0 "$ln.0 lineend" ]
      if { ![string length $curl ] } { continue } ;# empty: ignore
      regsub \t $curl : curl ;# replace tabs by ':'
      set e2 [ catch { puts $fid $curl } res ]
      if { $e2 } { Err e4 $res ; return }
    }  ; catch { close $fid } ;# end copying screen text into listfile
#
    set fname [file tail $listfile]
    if { $snew } { set ted3a "$ms323 $fname" } else { set ted3a "$ms324 $fname" }
 } ;# end proc.saveList
#
#*************************************************************************************************
# Proc getMyscan2 { } gets the name of fmylis "andere Datei" for saveList             *
#*************************************************************************************************
#
proc getMyscan2 { } {
    global fscres fmylis smod ms120 ms121 ms124 ms291
#"Bitte Datei angeben:"
    set dir0 [file dirname $fmylis]
    if {![file isdirectory $dir0]} { catch [exec mkdir -p $dir0 ]}
    set rep [tk_getSaveFile -initialdir $dir0 -title $ms291 ]
    if { $rep == "" } { return }  ;#  aborted
    set fmylis $rep ; set smod 6 ; getSavetext ; update
} ;# end proc.getMyscan2
#
#*************************************************************************************************
#  proc.filterList { mod }  filters the screen list ; if mod=0: use fmod for switch   *
#*************************************************************************************************
#
proc filterList { mod } {
    global etx fmod
    if { $mod == 0 } { set mod $fmod } ; set delflg 0
    $etx.t configure -state normal
    set ln 1 ; set tlin [lindex [split [$etx.t index "end - 1 char"] . ] 0]
#  read text from screen line by line
    while { $ln <= $tlin } {
      set curl [$etx.t get $ln.0 "$ln.0 lineend" ] ; incr ln
      if { ![string length $curl     ] } { continue } ;# empty:   ignore
      if { ![string first "#"  $curl ] } { continue } ;# comment: ignore
      if { ![string first "__" $curl ] } { continue } ;# title:   ignore
#  regular channel: get the transponder parameters
      regsub \t $curl : curl0 ;  set parms [ split $curl : ]
      set pos0 [string first \[ $curl0 ]
      set satnb [lindex $parms 3 ] ; set vpid 0 ; catch { set vpid [lindex $parms 5] }
      set tags [$etx.t tag names $ln.0]
      set islost [string first "lost" $tags ] ; set isconf [string first "conf" $tags ]
      set isunt  [string first "unt"  $tags ] ; set isnew  [string first "new"  $tags ]
      switch $mod {
        1 { set delflg [expr $vpid  == 0] }
        2 { set delflg [expr $vpid  >  0] }
        3 { set delflg [expr $satnb != 0] }
        4 { set delflg [expr $satnb == 0] }
        5 { set delflg [expr $pos0  == 0] }
        6 { set nln [expr $ln + 1 ] ;  while { $nln <= $tlin } {
              if { [$etx.t get $nln.0 "$nln.0 lineend" ] != $curl } { incr nln
	      } else { $etx.t delete $nln.0 "$nln.0 lineend+1char" ; incr tlin -1 } } }
        7 {  }
        8 {  }
        9 { set delflg [expr $islost >= 0] }
       10 { set delflg [expr $isunt  >= 0] }
       11 { set delflg [expr $isconf >= 0] }
       12 { set delflg [expr $isnew  >= 0] }
	} ;# switch $fmod
       if { !$delflg } { incr ln
        } else { $etx.t delete $ln.0 "$ln.0 lineend+1char" ; incr tlin -1 }
      } ;# while
    update ; $etx.t configure -state disabled
  } ;# end proc.filterList
#
#*************************************************************************************************
#  proc.sortList { mod }  sorts the screen list                                       *
#*************************************************************************************************
#
proc sortList { mod } {
    global etx omod
#  read text from screen line by line
    if { $mod == 0 } { set mod $omod }
    $etx.t configure -state normal ;  set tlist "" ; set tlist1 "" ; set tlist2 ""
    set ln 0 ; set tlin [lindex [ split [ $etx.t index "end - 1 char"] . ] 0 ]
    while { $ln <= $tlin } {
      incr ln ; set curl [$etx.t get $ln.0 "$ln.0 lineend" ]
      if { ![string length $curl     ] } { continue } ;# empty:  ignore
#      if { $mod == 1 } { lappend tlist1 $curl ; continue } ;# ABC-sort: no action
#
      if { ![string first "#"  $curl ] } { continue } ;# comment: ignore
      if { ![string first "__" $curl ] } { continue } ;# title:   ignore
#  regular channel: get the transponder parameters
      set post [ string first \t $curl ]   ;# tab = end-of-name
      if { $post < 0 } { set post [ string first ":" $curl ] }  ;#  :  = end-of-name
      set cnam [ string range $curl 0 $post ] ; set p0 [expr $post - 1]
      set post1 [expr $post + 1] ; set ctrap "[ string range $curl $post1 end ]:$cnam"
      set parms [ split $ctrap : ]
      set satnb [lindex $parms 2 ] ; set vpid 0 ; catch { set vpid [lindex $parms 4] }
      if { $mod == 1       } { set label [string toupper [string range $cnam 0 $p0]]
                               lappend tlist1 "$label:$curl"
      } elseif { $mod == 2 } {
        lappend tlist1 "[lindex $parms 0][lindex $parms 1][lindex $parms 2]:$curl"
      } elseif { $mod == 3 } {
        if { $vpid  != 0 } { lappend tlist1 $curl } else { lappend tlist2 $curl }
      } elseif { $mod == 4 } {
        if { $satnb == 0 } { lappend tlist1 $curl } else { lappend tlist2 $curl }
      } ;# if mod = 2 or 3 or 4
    } ;# end while
#
    switch $mod {
      1 { set tlist2 [lsort $tlist1]
          foreach ctrap $tlist2 {  set p1 [ expr [ string first : $ctrap ] + 1 ]
                                   lappend tlist [string range $ctrap $p1 end] } }
      2 { set tlist2 [lsort $tlist1]
          foreach ctrap $tlist2 {  set p1 [ expr [ string first : $ctrap ] + 1 ]
                                   lappend tlist [string range $ctrap $p1 end] } }
        3 { set tlist [concat $tlist1 $tlist2] }
        4 { set tlist [concat $tlist1 $tlist2] }
      } ;# end switch
#
    set f1 {-*-Helvetica-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
    $etx.t configure -state normal
    $etx.t delete 1.0 end  ;# wipe the screen
    foreach curl $tlist { $etx.t insert "end - 1 char" "$curl\n" }
    $etx.t configure -font $f1 -spacing1 5 -spacing2 5

if {0} { ;#############################################################################
#  check for empty lines + remove them
    set ln 0 ; set cnt 0 ; set tlin [lindex [ split [$etx.t index "end - 1char"] . ] 0]
    while { $cnt <= $tlin } { set curl [$etx.t get $ln.0 "$ln.0 lineend" ] ; incr cnt
      if { [string length $curl ] } { incr ln } else {
                          $etx.t delete $ln.0 "$ln.0 lineend+1char" } ;# empty: delete
    } ;# while
} ;# end invalid section ##############################################################

    update ; $etx.t configure -state disabled
  } ;# end proc.sortList
#
#*************************************************************************************************
#  proc.doCut,doCopy,doPaste  do the editor functions                                 *
#*************************************************************************************************
#
proc doSelin { } {
    global etx limod
    update ; $etx.t tag remove "linsel" 1.0 end
    if { $limod } { $etx.t tag add "linsel" "insert linestart" "insert lineend" }
    update
  } ;# end proc doSelin
#
#
proc doCut { } {
    global etx padlin limod
    if { $limod } { set padlin [$etx.t get "insert linestart" "insert lineend"]
      $etx.t tag remove "linsel" 1.0 end
      $etx.t delete "insert linestart" "insert lineend + 1 char"
    } else { tk_textCut $etx.t } ;# if limod
  } ;# end proc.doCut
#
#
proc doCopy { } {
    global etx padlin limod
    if { $limod } { set padlin [$etx.t get "insert linestart" "insert lineend"]
    } else { tk_textCopy $etx.t } ;# if limod
  } ;# end proc.doCopy
#
#
proc doPaste { } {
    global etx padlin limod
    if { $limod } {  $etx.t insert "insert linestart" "$padlin\n"
      $etx.t tag add "linsel" "insert linestart" "insert lineend"
    } else { tk_textPaste $etx.t } ;# if limod
    update
  } ;# end proc.doPaste
#
#
proc doLineup { } {
    global etx
    set clin [lindex [ split [ $etx.t index insert] . ] 0 ]
    set padlin [$etx.t get "[expr $clin - 1].0" "[expr $clin - 1].0 lineend"]
    if { $clin == 1 } { return } ;# in 1st line: no action, else:
    $etx.t insert "[expr $clin + 1].0" "$padlin\n"
    $etx.t delete "[expr $clin - 1].0" "[expr $clin - 1].0 lineend + 1 char"
    update
  } ;# end proc.doPaste
#
#
proc doLinedown { } {
    global etx
    set clin [lindex [ split [ $etx.t index insert] . ] 0 ]
    set tlin [lindex [ split [ $etx.t index "end - 2 char"] . ] 0 ]
    if { $clin >= $tlin } { return } ;# last line: no action, else:
    set padlin [$etx.t get "[expr $clin + 1].0" "[expr $clin + 1].0 lineend"]
    $etx.t insert "$clin.0" "$padlin\n"
    $etx.t delete "[expr $clin + 2].0" "[expr $clin +2].0 lineend + 1 char"
    update
  } ;# end proc.doPaste
#
#*************************************************************************************************
#  proc.showList { flg }  sets tags in the screen list (test: mark radios only    *
#*************************************************************************************************
#
proc showList { flg } {
    global etx
    set tlin [lindex [ split [ $etx.t index "end - 2 char"] . ] 0 ]
    $etx.t tag remove "radio" 1.0 end
#  read text from screen line by line
    set ln 0 ; set tlin [lindex [ split [ $etx.t index "end - 1 char"] . ] 0 ]
    while { $ln <= $tlin } {
      incr ln ; set curl [$etx.t get $ln.0 "$ln.0 lineend" ]
      if { ![string first "#"  $curl ] } { continue } ;# comment: ignore
      if { ![string first "__" $curl ] } { continue } ;# title: ignore
#  regular channel: get the transponder parameters
      regsub \t $curl : curt ;  set parms [ split $curt : ]
      set vpid 0 ; catch { set vpid [lindex $parms 5] }
      if { $vpid == 0 } { $etx.t tag add radio $ln.0 "$ln.0 lineend"  }
    } ;# while processing lines of text
  } ;# end proc.showList
#
#*************************************************************************************************
#  proc.markRadio1 { mod } sets/clears the 'radio' fonts in the editor to italics
#*************************************************************************************************
#
proc markRadio1 { mod } {
    global etx f1 f3
    update ;    set ft00 "Courier 12 bold italic"
    if { $mod } { $etx.t tag configure "radio" -font $ft00
         } else { $etx.t tag configure "radio" -font $f1     }
  } ;# end proc.markRadio1
#
#*************************************************************************************************
#  proc.doClassify { showclass addnew }  classifies the channels: conf,new,lost,unt   *
#*************************************************************************************************
#  addnew = 1: add new channesl to text
proc doClassify { showclass addnew } {
    global etx ltab scam5 fscres
#
    if { $showclass } { ;# show the classes by colors
      $etx.t tag configure "conf"   -foreground darkgreen -elide 0
      $etx.t tag configure "new"    -foreground darkred   -elide 0
      $etx.t tag configure "lost"   -foreground magenta   -elide 0
      $etx.t tag configure "unt"    -foreground black     -elide 0
    } else { ;# no colors
      $etx.t tag configure "conf"   -foreground black     -elide 0
      $etx.t tag configure "new"    -foreground black     -elide 0
      $etx.t tag configure "lost"   -foreground black     -elide 0
      $etx.t tag configure "unt"    -foreground black     -elide 0
    } ;# end if showclass
#  read fscres into a list
    set ref "" ; set er1 [ catch { open $fscres } fin ]
    if { $er1 } { Err e5 $fin ; return }
    while { ![eof $fin] } {
      set er2 [ catch { gets $fin } curl ]
      if { $er2 } { Err e6 $curl ; return }
      lappend ref $curl
    } ; catch { close $fin } ;# end while
    set newlist $ref
#
#  read text from screen line by line
    set ln 0 ; set tlin [lindex [ split [ $etx.t index "end - 1 char"] . ] 0 ]
    while { $ln <= $tlin } {
      incr ln ; set curl [$etx.t get $ln.0 "$ln.0 lineend" ]
      if { ![string first "#"  $curl ] } { continue } ;# comment: ignore
      if { ![string first "__" $curl ] } { continue } ;# title: ignore
      if { ![string length $curl ] } { continue } ;# empty: ignore
      regsub \t $curl : curl  ;   set cum [ split $curl : ]
      set ind [lsearch $newlist $curl]
      if { $ind >= 0 } {
#  line found in fscres: confirmed channel
	set new1 [lrange $newlist 0 [expr $ind - 1]  ]
	set new2 [lrange $newlist [expr $ind + 1] end]
	set newlist "$new1 $new2" ;# delete line in newlist
        $etx.t tag add "conf" $ln.0 "$ln.0 lineend"
      } else {
#  line not found: get the transponder
        set trap ":[lindex $cum 1]:[lindex $cum 2]:[lindex $cum 3]:"
	if { [string first $trap $ref] >= 0 } {
#  transponder is in recresults: channel is 'lost'
          $etx.t tag add "lost" $ln.0 "$ln.0 lineend"
#          $etx.t tag add sel  $ln.0 "$ln.0 lineend"
        } else {
#  transponder not in fscres: untouched, "nicht-betroffen"
	  $etx.t tag add "unt" $ln.0 "$ln.0 lineend"
        } ;# if transponder in fscres
      } ;# if channel in fscres
      catch { set vpid [lindex $cum 5] } ; if {$vpid == ""} { set vpid 0 }
      if { !$vpid } { $etx.t tag add "radio" $ln.0 "$ln.0 lineend" }
    } ;# while processing lines of text
#
#  if addnew != 0: add newlist to screen text if desired
    if { $addnew } { foreach curl $newlist { if { $ltab } { regsub : $curl \t curl }
	   $etx.t insert "end - 1 char" $curl\n "new" ; catch { $etx.t see end } } }
#  check for empty lines + remove them
    set ln 0 ; set cnt 0 ; set tlin [lindex [ split [$etx.t index "end - 1char"] . ] 0]
    while { $cnt <= $tlin } { set curl [$etx.t get $ln.0 "$ln.0 lineend" ] ; incr cnt
      if { [string length $curl ] } { incr ln } else {
                          $etx.t delete $ln.0 "$ln.0 lineend+1char" } ;# empty: delete
    } ;# while
    update ; $etx.t configure -state disabled
  } ;# end proc.doClassify
#
#*************************************************************************************************
#  proc.Err  { errnbr $errmsg}  displays an error message                             *
#*************************************************************************************************
#
proc Err  { errnbr errmsg } {
#  The errnbr is given in Format xyy, x = a,b,c.. or empty, yy = 1,2,3... (e.g. c12)
#  If x is specified, a 'parent window' is derived from it (default = '.').
    set k [expr 1 + [string first [string index $errnbr 0] "abcdefg"]]
    set winlist ". . .rec .doScan .dvbscan .doEdit . . . . " ;# parent window: -,a,b..
    set par [lindex $winlist $k] ; set messg "Error #$errnbr:\n$errmsg"
    tk_messageBox -icon warning  -message $messg -parent $par
  } ;# end proc.Err
#
proc Err1 { ern procName errmsg } {
    set messg "Error #$ern in proc.$procName : \n$errmsg"
    tk_messageBox -icon warning  -message $messg
  } ;# end proc.Err1  <<<<<<<   old !!!!!!!!!
#
proc Err0 { errmsg ern procName } {
    set messg "Error #$ern in proc.$procName : \n$errmsg"
    tk_messageBox -icon warning  -message $messg
  } ;# end proc.Err0  <<<<<<<   old !!!!!!!!!
#
#*************************************************************************************************
# Prozedur doHelp {} verwaltet die Hilfe-Texte                                        *
#*************************************************************************************************
#
proc doHelp  { } {
    global  wh w cbut4 wbut1 myVersion0 fhelp thelp dutil ms70 helptxt
    global ms120 ms122 ms123 ms126 ms285 ms286 ms287 ms288 ms289
#"Bitte Hilfe-Datei auswählen"
#"\t^zum Anfang\n"
#"\t^ auf"
#"\t  v ab\n"
#"Teclasat Version: $myVersion0"

#
    if { [winfo exists .doHelp ] } {
      tk_messageBox -type ok -icon info -message $ms122  ; return }
# check if fhelp available:
    if {![file exists $fhelp ] } then {
      set dir0 $dutil ; set tail0 $thelp
      if { ![file isdirectory $dir0] } { catch { exec mkdir -p $dir0 } }
      set inp [tk_getOpenFile -initialdir $dir0 -initialfile $tail0 -title $ms285 ]
      if { $inp == "cancel" } { return }
      set fhelp $inp ; saveConfig
    } ;# if no fhelp
#
    set wh .doHelp ;  toplevel $wh ;  wm title $wh $ms126
#
    set txt $wh.text ; set helptxt $txt.t ; frame $txt
    text $helptxt -width 80 -height 30 -wrap word  \
              -xscrollcommand "$txt.xsbar set" -yscrollcommand "$txt.ysbar set"
    scrollbar $txt.xsbar -orient horizontal -command "$helptxt xview"
    scrollbar $txt.ysbar -orient vertical   -command "$helptxt yview"
    grid $helptxt $txt.ysbar -sticky nsew
    grid $txt.xsbar -sticky nsew
    grid columnconfigure $txt 0 -weight 1
    grid rowconfigure    $txt 0 -weight 1
    pack $txt  -padx 10 -pady 10
    $helptxt configure -state normal ; $helptxt delete 1.0 end
#
#  fonts for help text
#
#    set f0 { -*-Helvetica-*-r-normal--*-120-*-*-*-*-iso8859-15 }
    set f0 {-*-Helvetica-*-r-normal-*-*-120-*-*-*-*-iso8859-15}
#    set f1 { -*-Helvetica-*-r-normal-*-*-120-*-*-*-*-iso8859-15 }
    set f5 {-*-Helvetica-*-r-normal-*-*-140-*-*-*-*-iso8859-15}
    set f1 [font create -size 12 -weight normal -slant roman ]
    set f2 [font create -size 12 -weight bold   -slant roman ]
    set f3 [font create -size 12 -weight normal -slant roman ]
    set f4 [font create -size 12 -weight normal -slant roman -underline 1]
#    set f5 [font create -size 14 -weight bold   -slant roman ]
    $helptxt configure -font $f0
    $helptxt tag configure tab1    -spacing1 5
    $helptxt tag configure head    -tabs {0.45i} -font $f5 -spacing1 5
    $helptxt tag configure headtxt -underline 1 -font $f5 -spacing1 5
    $helptxt tag configure body3   -spacing1 5  -spacing2 5
#
    $helptxt tag configure gohome  -tabs {5.7i right}
    $helptxt tag configure goup    -tabs {4.9i left 5.7i right}
#
#  read fhelp line by line and set tags
#
    set dmin 14 ; set dmax 24 ; set mod 1 ; set hedflg 1
    set lcnt 1  ; set tcnt 0  ; set nt 0  ; set pcnt 0 ;# updoown-points
    set hedtt $ms123 ; set hedid0 "nix"
#
    set e1 [catch { open $fhelp } fid ] ; if { $e1 } { Err f1 $fid ; return }
    while { 1 } {
      set e2 [ catch { gets $fid } curl ] ;  if { $e2 } { Err f2 $curl ; return }
      if { [eof $fid] != 0 } { break }
      if { [string length $curl] == 0 } { continue } ;# ignore empty lines
#          $helptxt insert end "$curl\n" body2 ;# empty line, alternative: show them
#
#  lines before table of contents: look for title of table of contents
      if { $mod == 1 } {
        if { $curl != $hedtt } {
	  $helptxt insert end "$curl\n" body1  ;# lines before table
	} else {
	  $helptxt insert end "$curl\n" tagtt ; set mod 2 ;# title of table
	} ;# end reading lines before table of contents
#
#  reading table of contents
      } elseif { $mod == 2 } {
        if { [string length $curl] == 0 } {
#          $helptxt insert end "$curl\n" body2 ;# empty line
	} else {
          set hedid  [lindex $curl 0] ; set lenid [string length $hedid]
	  set hetxt [string trim [string range $curl $lenid end]]
#	  set tabtag tagt$tlin
	  if { $hedid != $hedid0 } {
#  line whithin table of content
	    if { $tcnt == 0 } { set hedid0 $hedid ; set hetxt0 $hetxt } ;# 1st line
	    lappend hedidlist $hedid ; lappend hetxtlist $hetxt ;
	    if { [string first "." $hedid] == [expr [string length $hedid] -1] } {
	      $helptxt insert end "$hedid\t$hetxt\n" "tagt$tcnt tab1"
	    } else {
	      $helptxt insert end "$hedid\t$hetxt\n" "tagt$tcnt tab2"
	    } ;# table level 1 or more
           incr tcnt ; incr lcnt ;# increment line counters
	    if { $lcnt > $dmax } {
# end of page: insert updown fields
              $helptxt insert end $ms286 "gohome hom$pcnt"
              $helptxt insert end $ms287 "goup up$pcnt"
	      $helptxt insert "end - 1 chars" $ms288 "godown dn$pcnt"
	      incr pcnt ; set lcnt [expr $lcnt - $dmax] ;# reset line counter
	    } ;# end if end of page
	  } else {
#  title of 1st body section found: switch to body mode: mode = 3
	    set mod 3 ; set nt [expr $tcnt - 1 ] ; set bcnt 0 ; set lcnt int($dmax)
	  } ;# end if table done or not
	} ;# end if curl empty or not
      } ;# if mod = 2
#
#  reading the text body; check if this is a section heading
      if { $mod == 3 } {
        set hedid [lindex $hedidlist $bcnt ] ;# get next header numbering
        if { [string first $hedid $curl ] == 0 } {
#  header found
          if { $hedflg } { $helptxt insert end "\n" ; set hedflg 0 }
	  if { $lcnt >= $dmin } {
            $helptxt insert end $ms286 "gohome hom$pcnt"
            $helptxt insert end $ms287 "goup up$pcnt"
	    $helptxt insert "end - 1 chars" $ms288 "godown dn$pcnt"
	    incr pcnt ; set lcnt 0 ;# reset the counter for physical lines
	  } else { incr lcnt }
#
#  store a header line
          set hetxt [lindex $hetxtlist $bcnt ] ; set tagbx tagb$bcnt

	  $helptxt insert end "$hedid\t" head
	  $helptxt insert end "$hetxt\n" " head headtxt $tagbx " ; incr bcnt
	} else {
#  store a body record
	  set lval [expr ceil ( [string length $curl] / 80. ) ]
	  set lcnt [expr $lcnt + int ($lval)] ; set len [string length $curl]
          if { $lcnt >= $dmax } {
            $helptxt insert end $ms286 "gohome hom$pcnt"
            $helptxt insert end $ms287 "goup up$pcnt"
	    $helptxt insert "end - 1 chars" $ms288 "godown dn$pcnt"
	    incr pcnt ; set lcnt 0 ;# reset the counter for physical lines
	  } ;# end updown field
	  $helptxt insert end "$curl\n" "body3" ; set hedflg 1
	} ;# end if header line
      } ;# end mod = 3
    } ;# end while reading text
#
#  make the table of contents a 'hypertext': configure the tags
#
    set cnt 0  ; set pn [ expr $pcnt - 1 ]
    while { $cnt <= $nt } {
      set tagtx tagt$cnt ; set tagbx tagb$cnt ; incr cnt
      eval $helptxt tag bind $tagtx <ButtonPress> \"seeHelp $tagbx\"
      eval $helptxt tag bind $tagtx <Enter> \
                 \"$helptxt tag configure  $tagtx -foreground red   -underline 1\"
      eval $helptxt tag bind $tagtx <Leave> \
                 \"$helptxt tag configure  $tagtx -foreground black -underline 0\"
    } ;# end while
#
    set cnt 0
    while { $cnt <= $pn } {
      if { $cnt > 0   } { set  upx up[expr $cnt - 1] } else { set upx tagtt }
      if { $cnt < $pn } { set  dnx dn[expr $cnt + 1] } else { set dnx dn$pn }
      eval $helptxt tag bind up$cnt  <ButtonPress> \"seeHelp $upx\"
      eval $helptxt tag bind dn$cnt  <ButtonPress> \"seeHelp $dnx\"
      eval $helptxt tag bind hom$cnt <ButtonPress> \"seeHelp tagtt\"
      incr cnt
    } ;# end while

#  updown field: "go up"
    $helptxt tag bind goup <Enter> \
                     "$helptxt tag configure goup   -foreground red   -underline 1"
    $helptxt tag bind goup <Leave> \
                     "$helptxt tag configure goup   -foreground black -underline 0"
#  updown field: "go down"
#    $helptxt tag bind godown <ButtonPress> "seeUpDown +23"
    $helptxt tag bind godown <Enter> \
                     "$helptxt tag configure godown -foreground red   -underline 1"
    $helptxt tag bind godown <Leave> \
                     "$helptxt tag configure godown -foreground black -underline 0"
#  "go-home field:  "zurueck zum Verzeichnis"
#    eval $helptxt tag bind gohome <ButtonPress> \"seeHelp $tagtt\"
    $helptxt tag bind gohome <Enter> \
                     "$helptxt tag configure gohome -foreground red   -underline 1"
    $helptxt tag bind gohome <Leave> \
                     "$helptxt tag configure gohome -foreground black -underline 0"
#
    $helptxt configure -state disabled -font $f0
    $helptxt see   [$helptxt index  tagtt.first]
#
#  Bottom: Info + return button
#
    set    wbot  $wh.bottom ; set   wmsg $wbot.messages ; set wbut $wbot.buttons
    frame  $wbot
    frame  $wmsg  -padx 4 -pady 4
    label  $wmsg.msg0 -text "$ms289 $myVersion0" -anchor w -padx 4 -pady 4
#
    frame  $wbut  -padx 4 -pady 4
    button $wbut.b0   -text $ms70 -width 9 -command "quitHelp $wh"
    pack   $wmsg.msg0 -side bottom
    pack   $wbut.b0  -pady 12 -padx 4 -side bottom -anchor se
#
    pack   $wmsg $wbut -pady 2 -padx 36 -fill y -side left
    pack   $wbot -pady 8 -padx 8 -side top
#
    tkwait window $wh
  } ;#  end proc. doHelp
#
#  proc.quitHelp closes the help window and resets the help keys
#
proc quitHelp { wh } {
    destroy $wh                    ;#  delete help window
  } ;# end proc. quitHelp
#
#  proc.seeUpDown { dif } moves the help text dif lines up or down
#
proc seeUpDown { dif } {
    global helptxt
    $helptxt see [$helptxt index "current + $dif lines"]
  } ;# end proc. seeUpDown
#
#  proc.seeHelp processes the 'see tag'-bindings in doHelp
#
proc seeHelp { tagx } {
    global helptxt
    $helptxt see [$helptxt index $tagx.first]
  } ;# end proc. seeHelp
#
#*************************************************************************************************
#     Prozedur setPlayer { item } macht den Player #item aktiv
#*************************************************************************************************
#   allPlayers = list of all implemented players; xine kaffeine mplayer
#   actPlayers = list of the active players (e.g. xine kaffeine)
#   isplayer   = array of flags; e.g. isplayer(mplayer) =1 if mplayer active, =0 else.
#   playertyp  = name of the selected player (e.g. xine)
#
proc setPlayer { item } {
    global home receivertyp playertyp receiverdir allPlayers allReceivers
#
#   soft-reset: laufende Programme abschalten ; evtl. fragen? Do you really want..?
    set proglist [list xine mplayer kaffeine szap tzap czap tee cat]
#    kill-progs $proglist   ;#  kill all programs in list
#
    set playertyp   [lindex $allPlayers   $item ]
    set receivertyp [lindex $allReceivers $item ]
    set receiverdir .$receivertyp
    if {![file isdirectory $home/$receiverdir]} \
                                           {catch [exec mkdir -p $home/$receiverdir]}
  } ;# end proc.setPlayer
#
#
#*************************************************************************************************
proc dummy {} { tk_messageBox -type ok -message "Leider noch nicht fertig." }
#*************************************************************************************************
#
#
#*************************************************************************************************
#     Prozedur mplayerConfig {}   Auswahl der Mplayer Audio und Videotreiber
#*************************************************************************************************
#
proc mplayerConfig {} {
    global optvs optas

    set OUTV [open "| mplayer -vo help | expand | sed -e {/^ .*/!d} -e {s/^ *//}"]
    set OUTA [open "| mplayer -ao help | expand | sed -e {/^ .*/!d} -e {s/^ *//}"]

    toplevel .mplayeropts
    label .mplayeropts.head -text "MPlayer-Optionen"
    pack .mplayeropts.head -pady 5

    iwidgets::optionmenu .mplayeropts.vid -labeltext "Videotreiber:" \
                                          -labelpos w -width 450
    pack .mplayeropts.vid

    iwidgets::optionmenu .mplayeropts.aud -labeltext "Audiotreiber:" \
                                          -labelpos w -width 450
    pack .mplayeropts.aud
    button .mplayeropts.sel -text "OK" -width 9 -height 1 -command mplayerCursel
    pack .mplayeropts.sel

    set COUNT 0
    while {![eof $OUTV]} {
      set INSV [gets $OUTV]
      .mplayeropts.vid insert end $INSV
      if {[string match [exec echo $INSV | sed {s/ .*//}] $optvs]} { set POSV $COUNT }
      incr COUNT
    } ;# end while not eof

    .mplayeropts.vid select $POSV

    set COUNT 0
    while {![eof $OUTA]} {
      set INSV [gets $OUTA]
      .mplayeropts.aud insert end $INSV
      if {[string match [exec echo $INSV | sed {s/ .*//}] $optas]} { set POSV $COUNT }
      incr COUNT
    } ;# end while not eof

    catch {.mplayeropts.vid select $POSV}
    proc mplayerCursel {} {
      global dtec tconf optvs optas
      set TMPV [.mplayeropts.vid get]
      set TMPA [.mplayeropts.aud get]
      set optvs [exec echo $TMPV | sed {s/ .*//}]
      set optas [exec echo $TMPA | sed {s/ .*//}]
      saveConfig
      destroy .mplayeropts
    } ;# end proc.mplayerCursel
  } ;# end proc.mplayerConfig
#
#
#*************************************************************************************************
#  Proc. saveConfig {}  saves the system parameters in the permanent disc file teclaxy.conf
#*************************************************************************************************
#
proc saveConfig {} {
    global dtec tconf myVersion tan sel playertyp maunam fmylis fmydvb
    global blist wlist favo1 favo2 mrecfil trecfil dutil lang fscres
    global vtflag showflag modflag offbut weltime wait1 wait2 optvs optas
    global bgcolor fgcolor actcolor offcolor ad siglist
    global fdvb1 fdvb2 dlif smode clif cdvb flscan fdscan mara mahot adel aconf
#
    if {![file isdirectory $dtec]} { catch [exec mkdir -p $dtec ] }
      set   CONFFILE    [open $dtec/$tconf w ]
      puts  $CONFFILE   "Version   = $myVersion"
      puts  $CONFFILE   "player    = $playertyp"
      puts  $CONFFILE   "baselist  = $blist"
      puts  $CONFFILE   "worklist  = $wlist"
      puts  $CONFFILE   "favo1-list= $favo1"
      puts  $CONFFILE   "favo2-list= $favo2"
      puts  $CONFFILE   "manRecFile= $mrecfil"
      puts  $CONFFILE   "timrecFile= $trecfil"
      puts  $CONFFILE   "utils-dir = $dutil"
      puts  $CONFFILE   "language  = $lang"
      puts  $CONFFILE   "ad+siglist= $ad $siglist"
      puts  $CONFFILE   "Flags     = $vtflag $showflag $maunam $offbut $mara $mahot $adel $aconf"
      puts  $CONFFILE   "sel-list  = $sel(0) $sel(1) $sel(2) $sel(3) $sel(4) $sel(5) $sel(6) $tan"
      puts  $CONFFILE   "Times     = $weltime $wait1 $wait2"
      puts  $CONFFILE   "bg,fg,a,of= $bgcolor $fgcolor $actcolor $offcolor"
      puts  $CONFFILE   "MPlr-optvs= $optvs $optas"
      puts  $CONFFILE   "dvbfile1  = $fdvb1"
      puts  $CONFFILE   "dvbfile2  = $fdvb2"
      puts  $CONFFILE   "listfildir= $dlif"
      puts  $CONFFILE   "scanFlags = $smode $clif $cdvb"
      puts  $CONFFILE   "listscafil= $flscan"
      puts  $CONFFILE   "dvbscanfil= $fdscan"
      puts  $CONFFILE   "scanresult= $fscres"
      puts  $CONFFILE   "myscanfile= $fmylis"
      puts  $CONFFILE   "mydvbfile = $fmydvb"
      close $CONFFILE
  } ;# end proc. saveConfig
#
#*************************************************************************************************
#  proc doSelection {} processes a new selection in the table: sel($tan)
#*************************************************************************************************
#
proc doSelection {} {
    global tan tab sel
    update ; set sel($tan) [$tab curselection] ; saveConfig ; showChanParms
  } ;# end proc.doSelection
#
#*************************************************************************************************
#  proc onKey {kid nx1 nx2 cmd1 cmd2} handles the on/off keys (view-on/view-off etc)
#*************************************************************************************************
#
proc onKey { kid nx1 nx2 cmd1 cmd2 } {
    global cbut offcolor bgcolor offbut xbut11 xbut12 xbut13 xbut21 xbut22 xbut41
    global ms1 ms2 ms3 ms4 ms5 ms6 ms7 ms8 ms9 ms11 ms12 ms185 ms186
    eval "set xact \$xbut$kid" ; eval "set x1 \$ms$nx1" ; eval "set x2 \$ms$nx2"
    if { $xact == $x1 } { eval $cmd1 } elseif { $xact == $x2 } { eval $cmd2
    } elseif { $xact == $ms4 } { manRecord }
  } ;# end proc.onKey
#
#
#*************************************************************************************************
##################                     Hauptroutine                            ###################
#*************************************************************************************************
#
#  System-Parameter initialisieren mit Default-Werten:
    set myVersion [string range $myVersion0 0 7] ;#  Versions-Name (verkuerzt)
    set dtec  [file dirname $teclaconf ] ; set tconf [file tail $teclaconf]
#
#puts "§*Haupteingang,5839; Version0= * $myVersion0 *" ;### Test! ####
#set s0 "20051224"
#puts "§main6005; s0,dig = *$s0**[string is digit -strict $s0]*"
#set tim0 [clock clicks]
#gets stdin dummy                                ;### Test! ####
#
#   Wichtige Default-Werte
    set blist    $dtec/channels.conf
    set wlist    $dtec/wlist              ; set ftemp    $dtec/scratchpad.tmp
    set favo1    $dtec/ARD-Favos          ; set favo2    $dtec/Radio
    set mrecfil  $home/rec/rec01.ts       ;# record file for manual recording
    set trecfil  $home/rec/rec01.ts       ;# record file for timer-recording
    set allkeys  0       ; set confVersion  none
    set receivertyp none ; set playertyp none ; set titreply "" ; set newColormsg ""
    set oldtan   2       ; set recmode   0    ; set playmode    0  ; set color   0
    set modflag  -1      ; set showflag  0    ; set logflag     0  ; set vtflag  0
    set taunam   1       ; set maunam    0    ; set timdir    $dtec/timer
    set weltime  0       ; set weltime0 $weltime ;  set  dohalt 0 ; set adel 0 ; set aconf 1
    set wait10   0       ; set wait20    0    ; set wait1 $wait10  ; set wait2 $wait20
    set balhelp  0           ; set tan 2
    set siglist  "stcs"      ; set ad   0     ; set  zap  "szap"
    set bgcolor0 "#e6e6c8"   ; set fgcolor0  "#000000" ;  set actcolor0 "#ffffff"
    set bgcolor  $bgcolor0   ; set fgcolor   $fgcolor0 ;  set actcolor  $actcolor0
    set offbut 1             ; set offcolor0 "#ffff90" ;  set offcolor  $offcolor0
    set optvs    "xv"        ; set optas "arts"   ;# MPlayer: video + audio drivers
    set homechnf 0 ; set homechnr 0 ; set lastchnf 0 ; set lastchnr 0 ; set onoff 0
    set mara   1 ; set mahot  1
    foreach k {0 1 2 3 4 5 6} { set sel($k) 0 }
#
# init the scan parameters
    set smode 1 ; set clif 1    ; set cdvb 0
    set scansat -1 ; set stopflg 1
    set scansig s ; set skey  -1
    set shom0  0 ; set shom1  1 ; set shom2  1 ; set shom3  1  ; set shom4  0
    set shom5  0 ; set shom6  0 ; set shom6  0 ; set shom7  1  ; set shom8  0
    set shom9  0 ; set shom10 0 ; set shom11 0 ; set shom12 0  ; set shom13 0
    set shom14 1 ; set shom15 0 ; set fta "-x0" ; set tra "-t3"
    set sv1 1 ; set sv2 0 ; set sv3 1 ; set sv4 0 ; set scanflg 0
    set lnew 1 ; set smod 5 ; set snew 1 ;  set fmod 5 ; set omod 1    ; set expert 1
    set lmod 1 ; set scam1 1 ; set scam2 1 ; set scam3 1 ; set scam4 1 ; set scam5 0
    set limod 1
#
#   Welche Player & Receiver sind vorhanden?
    set allPlayers   [ list xine kaffeine mplayer totem ] ;# implementierte player
    set allReceivers [ list $zap $zap     mplayer $zap  ] ;# zugehoerige receiver
    foreach plr $allPlayers {
      if { ![catch {exec which $plr } path]} {
	lappend actPlayers $plr ; set isplayer($plr) 1  ; set ispath($plr) $path
      } else { set isplayer($plr) 0 }
    } ;# end foreach plr
    if { ![catch {exec which dvbrowse } epgpath]} { set isepg 1 } else { set isepg 0 }
#
#*************************************************************************************************
#   Konfig-Datei tecla.conf oeffnen + lesen;
#*************************************************************************************************
#   zuerst sicherstellen, dass dtec existiert:
    if {![file isdirectory $dtec]} { catch [exec mkdir -p $dtec ] }
    if {[file exists $dtec/$tconf]} then {
      catch {open $dtec/$tconf RDONLY} inf
      while {1} {
        gets $inf curl
	if { [eof $inf] != 0 } { break }
	lappend lconf $curl
      } ;# end while
#     VersionCode aus tecla.conf auslesen + pruefen:
      catch {set confVersion [string trim [string range [lindex $lconf 0] 11 end ]]}
    } ; # end if tconf exists
#
    if {$confVersion == $myVersion } then {
#
#  VersionCode OK: Config-Datei lesen + Daten abspeichern:
#
      if { [llength $lconf ] >= 5 } {
        set playertyp  [string trim [string range [lindex $lconf 1] 11 end ]]
        set blist      [string trim [string range [lindex $lconf 2] 11 end ]]
	if { [string first "~" $blist ] == 0 } { set blist $home[string range $blist 1 end] }
	set wlist      [string trim [string range [lindex $lconf 3] 11 end ]]
	if { [string first "~" $wlist ] == 0 } { set wlist $home[string range $wlist 1 end] }
        set favo1      [string trim [string range [lindex $lconf 4] 11 end ]]
	if { [string first "~" $favo1 ] == 0 } { set favo1 $home[string range $favo1 1 end] }
        set favo2      [string trim [string range [lindex $lconf 5] 11 end ]]
	if { [string first "~" $favo2 ] == 0 } { set favo2 $home[string range $favo2 1 end] }
        set mrecfil    [string trim [string range [lindex $lconf 6] 11 end ]]
	if { [string first "~" $mrecfil ] == 0 } { set mrecfil $home[string range $mrecfil 1 end]}
        set trecfil    [string trim [string range [lindex $lconf 7] 11 end ]]
	if { [string first "~" $trecfil ] == 0 } { set trecfil $home[string range $trecfil 1 end]}
        set dutil      [string trim [string range [lindex $lconf  8] 11 end ]]
	if { [string first "~" $dutil ] == 0 }   { set dutil $home[string range $dutil 1 end] }
        set lang       [string trim [string range [lindex $lconf  9] 11 end ]]
	set adSig      [string trim [string range [lindex $lconf 10] 11 end ]]
          set ad       [lindex $adSig 0] ; set siglist  [lindex $adSig 1]
        set Flags      [string trim [string range [lindex $lconf 11] 11 end ]]
          set vtflag   [lindex $Flags 0] ; set showflag [lindex $Flags 1]
          set maunam   [lindex $Flags 2] ; set offbut   [lindex $Flags 3]
          set mara     [lindex $Flags 4] ; set mahot    [lindex $Flags 5]
          set adel     [lindex $Flags 6] ; set aconf    [lindex $Flags 7]
        set selli      [string trim [string range [lindex $lconf 12] 11 end ]]
          set sel(0)   [lindex $selli 0] ; set sel(1)   [lindex $selli 1]
          set sel(2)   [lindex $selli 2] ; set sel(3)   [lindex $selli 3]
          set sel(4)   [lindex $selli 4] ; set sel(5)   [lindex $selli 5]
          set sel(6)   [lindex $selli 6] ; set tan      [lindex $selli 7]
        set Times      [string trim [string range [lindex $lconf 13] 11 end ]]
          set weltime  [lindex $Times 0]
          set wait1    [lindex $Times 1] ; set wait2    [lindex $Times 2]
        set Colors      [string trim [string range [lindex $lconf 14] 11 end ]]
          set bgcolor  [lindex $Colors 0] ; set fgcolor  [lindex $Colors 1]
          set actcolor [lindex $Colors 2] ; set offcolor [lindex $Colors 3]
        set mplr       [string trim [string range [lindex $lconf 15] 11 end ]]
          set optvs    [lindex $mplr  0] ; set optas     [lindex $mplr  1]
        set fdvb1      [string trim [string range [lindex $lconf 16] 11 end ]]
	if { [string first "~" $fdvb1 ] == 0 } { set fdvb1 $home[string range $fdvb1 1 end]}
        set fdvb2      [string trim [string range [lindex $lconf 17] 11 end ]]
	if { [string first "~" $fdvb2 ] == 0 } { set fdvb2 $home[string range $fdvb2 1 end]}
        set dlif       [string trim [string range [lindex $lconf 18] 11 end ]]
	if { [string first "~" $dlif  ] == 0 } { set dlif  $home[string range $dlif  1 end]}
        set sFlags     [string trim [string range [lindex $lconf 19] 11 end ]]
          set smode [lindex $sFlags 0] ; set clif [lindex $sFlags 1] ; set cdvb [lindex $sFlags 2]
        set flscan     [string trim [string range [lindex $lconf 20] 11 end ]]
	if { [string first "~" $flscan ] == 0 } { set flscan $home[string range $flscan 1 end]}
        set fdscan     [string trim [string range [lindex $lconf 21] 11 end ]]
	if { [string first "~" $fdscan ] == 0 } { set fdscan $home[string range $fdscan 1 end]}
        set fscres     [string trim [string range [lindex $lconf 22] 11 end ]]
	if { [string first "~" $fscres ] == 0 } { set fscres $home[string range $fscres 1 end]}
        set fmylis     [string trim [string range [lindex $lconf 23] 11 end ]]
	if { [string first "~" $fmylis ] == 0 } { set fmylis $home[string range $fmylis 1 end]}
        set fmydvb     [string trim [string range [lindex $lconf 24] 11 end ]]
	if { [string first "~" $fmydvb ] == 0 } { set fmydvb $home[string range $fmydvb 1 end]}
#
      } else {  set confVersion  none } ;#  versionCode unbrauchbar
    } ;# end if confVersion OK: config-Datei verarbeitet.
#
#*************************************************************************************************
#            ***    Initialize  files + configuration   ***
#*************************************************************************************************
#  identify lang (language flag) , fhelp, fmsg, scan files
#
    set fhelp "" ;  set fmsg "" ; set ficon ""
    if { $confVersion == "none" } {
#  cold start: look for fhelp
      if {       [file exists $dutil/$thelp$lang  ] } { set fhelp $dutil/$thelp$lang
      } elseif { [file exists "$dutil1/$thelp-de" ] } { set fhelp "$dutil1/$thelp-de"
      } elseif { [file exists "$dutil2/$thelp-de" ] } { set fhelp "$dutil2/$thelp-de"
      } elseif { [file exists "$dutil3/$thelp-de" ] } { set fhelp "$dutil3/$thelp-de" } ;# if fhelp
      if { [string length $fhelp] } { set dutil [ file dirname $fhelp ] }
#  cold start (cont'd): look for scan files
      set ddvb1 /usr/share/teclasat/scanctrl ; set ddvb2 $ddvb1
      if { ![file isdirectory $ddvb1] } { set ddvb1 "/usr/share/teclasat/initscan"
      if { ![file isdirectory $ddvb1] } { set ddvb1 "pctv/scanctrl"
      if { ![file isdirectory $ddvb1] } { catch [exec mkdir -p $ddvb1 ] } } }
      set dlif $ddvb1/listfiles
      if { ![file isdirectory $dlif] } { set dlif $ddvb1 }
      set fdvb1  $ddvb1/Astra-19.2E  ; set fdvb2  $ddvb2/Hotbird-13.0E
      set fdscan $ddvb1/Astra-19.2E  ; set flscan $dlif/astra-list0
      set fmydvb $ddvb1/de-Berlin    ; set fmylis $dlif/astra-longlist-051010
      set dscan  $home/pctv/scan     ; set fscres $dscan/newchans.conf
    } else {
#  warm start: dutil + lang from config-file
      if { [file exists $dutil/$thelp$lang ] } { set fhelp $dutil/$thelp$lang
      } elseif { ($lang == "-default") && [file exists "$dutil/${thelp}-de"] } {
	                      set fhelp "$dutil/${thelp}-de" } ;# if fhelp exists
      set ddvb1 [file dirname $fdvb1] ; set ddvb2 [file dirname $fdvb2]
      set dlif $ddvb1/listfiles ; if { ![file isdirectory $dlif] }  { set dlif $ddvb1 }
    } ;# end if cold/warm start
#
    if { [ file exists $dutil/teclasat.ppm ] } { set ficon $dutil/teclasat.ppm }
    if { [ file exists $dutil/$tmsg$lang   ] } { set fmsg  $dutil/$tmsg$lang }
#
#*************************************************************************************************
    if { $fmsg == "" } {
#   * default dialog: read messages ms1 .. ms6xx from internal list  *
#   * Attention pls:  the following button texts MUST by in iso8859-15 code !  *
    set msgList [ list {ein} {aus} {Videotext} {Datei} {Videotext aus} {Start} \
    {Pause} {Weiter} {Stop} {Timer} {Bearbeiten} {Einklappen} {Einrichten} {Beenden} \
    {Senderdaten} {Name} {frequency etc} {Sender} {Senderliste} {Senderlisten:} \
    {Filtern} {Sortieren} {Wiedergabe} {Aufnahme} \
    {--ms25...} {ausschneiden} {kopieren} {Titel-Favo1} {Titel-Favo2} {Radio} \
    {Sat} {alle Sender} {nur TV} {nur Radio} {nur Astra} {nur Hotbird} \
    {ABC-Z} {ZYX-A} {Frequenz} {TV/Radio} {Astra/Hotbd} {^ aufwärts} {v abwärts} \
    {löschen} {Einfügen in} {einfügen} {Titel} {speichern} {einbinden} \
    {--ms50...} {Einrichten} {Hilfe} {Farben} {Suchlauf} {Farbwerte:} {Hintergrund} \
    {Vordergrund} {Aktive Teile} {aus-Knöpfe} {Rot} {Grün} {Blau} {Defaultwerte} \
    {Hilfe-aus} {Suchlauf-aus} {Einrichten} {Einrichten-aus} {alle Prog.aus} \
    {MPlayerConfig} {Zurück} {System} {72} {Kein Sender angewaehlt.} \
    {Aufnahme ist aktiv mit } \
    {--ms75} {Aufnahme-Pause mit} {umschalten auf} {Kann} { nicht starten! Abbruch.} \
    {Kann xine nicht starten! Abbruch.} {Kann kaffeine nicht starten! Abbruch.} \
    {Kann totem nicht starten! Abbruch.} {Kann MPlayer nicht starten! Abbruch.} \
    {Aufnahme ist aktiv mit} {Umschalten nur im Pause-Modus.} \
    {Kann dvb-Module nicht laden! Abbruch.} { scheint aktiv zu sein.} \
    {88} {Kein gueltiges Verzeichnis;} \
    {Bitte Ausgabedatei auswaehlen} {Teclasat Timer-Aufnahme} \
    {Bitte Aufnahmedaten eingeben} {Datum (mm/dd/yyyy)} {Stunde} \
    {Minute} {Sender} {Dateiname} {Speichern} {Serie} \
    {--ms100...} {Dateiwahl} {Beenden} {Loeschen} {Bitte Ausgabedatei eingeben} \
    {105} {106} {oder Serie:} {Auswahl} {oder auto-Name:} {z.B.} \
    {Kann 'crontab' nicht starten.} {Kann 'at' nicht starten.} \
    {Startzeit = Stopzeit? Abbruch.} {Zeiten überschneiden sich:} \
    {Kann Datei nicht öffnen:} {Kann Datei nicht lesen} \
    {Bitte Wochentag(e) eingeben} {*taeglich*} {List} {Datei} {nicht gefunden.} \
    {Fenster existiert bereits.} {*** Inhaltsverzeichnis. ***} {Liste laden} \
    {--ms125...} {TeclaSat: Hilfe} {Aufnahmedatei = } {Teclasat: manuelle Aufnahme} \
    {Aufnahmemodus} {immer neu schreiben} {Aufnahmen anfügen} {auto-Name} {gespeichert in} \
    {Nichts angewaehlt.} {135} {Timeraufnahme laeuft; Aufnahme abbrechen?} {Bitte } \
    { auswählen:} {In diesem Transponder sind} {als Videotext verfuegbar:} \
    {(Bitte Sender 1x anklicken)} {Liste ist leer} {(Titel)} {(Titel - keine Senderdaten)} \
    {(kein Sender)} {Sender: } {Arbeitsliste} {Liste defekt?-} {Basisliste} \
    {--ms150...} {Favo1-Liste} {Favo2-Liste} {Ablage} { abgespeichert als Datei } \
    {Datei konnte nicht geschrieben werden.} {TeclaSat: Gruppentitel} \
    {Bitte Gruppentitel eingeben:} {   nur: a-z, A-Z, 0-9, _; nicht: <>|} {OK} \
    {Abbruch} {Fenster existiert bereits.} {TeclaSat: Einrichten} {Signalquelle:} \
    {Signalart:} {Treiber-Module:} {nie laden} {PCTVSat} {PCTVSatCI} {169} \
    {Playerwahl:} {xine} {kaffeine} {MPlayer} {totem} \
    {--ms175...} {VideoText mit:} {alevt} {mtt4} {mtt} {180} {Anzeigen:} {Senderdaten} {Extras:} \
    {Auto-Name} {EPG} {EPG-aus} {187} {Teclasat Version: } {Info: www.pinnaclefanboard.com} \
    {Kontakt:  pinux@pctvsat.com} {Einrichten} {Sprachen} {Zeiten} {194} {195} \
    {TeclaSat: Zeiten} {Standzeit Welcome-Fenster:} \
    {Standzeit Welcome ; aktuell: t0= } {Dauerlauf} \
    {--ms200...} {t0 speichern} {Defaultwert} {Wartezeiten:} \
    {->xine ;          aktuell: t1= } \
    {Interval nach kill-prog ;     aktuell: t2= } {t1 speichern} \
    {t2 speichern} {Defaultwerte} {t0 - Test} {Interval} {211} {TeclaSat: Sprachen} \
    {Suchlauf gestartet.} {ist keine dvb-Suchdatei.} {dvb-Suchlauf aktiv.} \
    {- bitte warten -} {Test} {directory/Ordner} {select} {TV+Radio} {Liste} \
    { = dvb-Datei?} {(keine)} {Listensuchlauf} \
    {--ms225...} {Suchlauf abgebrochen} { - bitte warten.} {dvb-Suchlauf abgebrochen} \
    {229} {dvb-Suchlauf} { Kennwerte} {Signal  = } {Modus   = } {Auswahl = } \
    {Dienste = } {Dateien} {Suchdatei = } {Ergebnis  = } {Status} {Pegel} \
    {Bitte Verzeichnis auswaehlen} {Sat/Bereich} {aus Liste} {Suchdaten} \
    {List-Modus} {Sat #0} {Sat #1}   {dvb-Modus} {249} \
    {--ms250...} {Signalquelle} {dvb-Suchlauf} {Suchdatei (dvb-Modus)} {254} {255} \
    {Auswahl:} {nur FTA} {(alle)} {Dienste:} {nur TV} {nur Radio} {TV + Radio} \
    {sonstiges} {(alles)} {Sat / Bereich einstellen} {andere Einstellung} \
    {andere Datei} {Sat / Bereich #0:} {Sat / Bereich #1:} {Standard-Suchlisten} \
    {Pegelanzeige} {Std-Listen} {x} {x} \
    {--ms275...} {Bitte Ergebnisdatei angeben} {277} {x} {x} {x} {x} {x} \
    {Kann Programm dvb-scan nicht starten!} {Kann Datei nicht oeffnen.} \
    {Bitte Hilfe-Datei auswählen} {\t^zum Anfang\n} {\t^ auf} {\t  v ab\n} \
    {Teclasat Version:} {von} {Bitte Datei angeben:} {292} \
    {Kann Scan-Datei nicht oeffnen.} {Neu abspeichern als} {Anfügen an} \
    {Verzeichnis =} {297} {298} {299} \
    {--ms300} {Keine Daten von Listen-Suchlauf gefunden;} \
    {kann dvb-Daten nicht speichern.} {Ergebnisse abgespeichert:} {bestätigte,} \
    {nicht-betroffene,} {neue,} {entfallene.} {Ergebnis abgespeichert,} {Sender.} \
    {Suchlaufergebnis} {Hilfsdatei} {Vorauswahl} {laden} {anfügen} {Datei =} \
    {Verzeichnis =} {317} {318} {319} {wurde geladen} {wurde angefügt} {322} \
    {Abgespeichert als} {Angefügt an} \
    {--ms325...} {System runterfahren} {(falls berechtigt)} {Halt} {Manuell} \
    {In Aufnahmeliste} {Verzeichnis der Suchmodus-Dateien} {Aufnahmetag} {Ende} \
    {Sender} {täglich} {Montag} {Dienstag} {Mittwoch} {Donnerstag} {Freitag} {Samstag} \
    {Sonntag} {Signalquelle} {344} {345} {346} {Sat-Nr.} {Einzel-Transponder} {349} \
    {---ms350.} {x} {x} {x} {x} {x} {x} {x} {x} {x} {360} {Transponder ausgewertet} \
    {362} {363} {Anzeigen} {365} {366} {367} {368} {369} {nicht betroffen} \
    {ganze Listen} {alt} {gefunden} {nicht betroffen} \
    {---ms375...} {Expertenmodus} {Radios markieren} {378} {bestätigt} {neu} \
    {entfallen} {nicht betroffen} {x} {x} {x} {x} {x} {x} {x} {x} {x} {x} {x} {x} \
    {x} {x} {x} {x} {x} \
    {---ms400} {Kann Datei nicht lesen:} {Kann Datei nicht öffnen:} {nicht öffnen;} \
    {Bitte Suchlauf neu starten.} {Transponderliste wurde geändert;} \
    {Kann Datei out2 nicht lesen} {von } \
    {war in früherem Suchlauf gestört (time-out);} \
    {abbrechen, diesen Transpdr.abfragen, oder auslassen?} {410} {411} \
    {weiter nonstop} {in Suchliste} {Suchbericht} {gefunden} {Suchergebnis} \
    {Suchliste} {auslassen} {abbrechen} {abfragen} {Suchlauf} {Starten} \
    {Wiederholen} {Löschen} \
    {---ms425} {426} {427} {428} {429} {430} {431} {432} {Basisliste} \
    {Arbeitsliste} {Favoliste} {Radioliste} {437} {438} {439} {440} {Filtern} \
    {nur TV} {nur Radio} {nur sat0} {nur sat1} {Sortieren} {Frequenz} {ABC} \
    {TV / Radio} \
    {---ms450} {sat0 / sat1} {Suchlauf einrichten} {Kennwerte} {Signal  = } \
    {Modus   = } {Auswahl = } {Dienste = } {Dateien} {Suchdatei = } \
    {im Verzeichnis = } {Ergebnis  = } {Suchlauf} {Einrichten} {Suchmodus} \
    {Ausführen} {Auswerten} {Hilfe  } {Voreinstellung} {Dateien} {Liste} {dvb} \
    {manuell} {x} {x} \
    {---ms475} {Manueller Suchlauf} {manuell} {bitte eingeben:} {(Einzeltransponder)} \
    {TV+Radio} {nur TV} {nur Radio} {sonst.} {alle} {x} {Dateien} \
    {Standard-dvb-Dateien} {Sat-Name} {dvb-Datei} {alle im Verzeichnis } \
    {andere Suchdatei =} {im Verzeichnis  =} {Ergebnisdatei} {Ergebnis =} \
    {im Verzeichnis =} {andere Dateien wählen } {497} \
    {498} {Verzeichnis f.Standard-Suchlisten} \
    {---ms500} {Sat #0} {Sat #1} {andere} {Ergebnis} {dvb-Datei?} {Bitte Suchliste angeben} \
    {Bitte dvb-Suchdatei angeben} {Bitte Standard-dvb-Datei angeben} \
    {Kann Verzeichnis nicht anlegen: } {Für jeden Transponder} \
    {Sender in alter Liste} {Transpdr.in Suchliste} {gefundene Sender} \
    {bestätigte Sender} {neue Sender} {entfallene Sender} {out1-Daten} {out2-Daten} \
    {x} {Suchlauf ausfuehren} {Signal  = } {Modus   = } {Auswahl = } {524} \
    {---ms525} {Dienste = } {Suchdatei = } {Ergebnis  = } {Anzeigen:} {neue; } \
    {bestätigte; } {entfallene;} {nicht-betroffene; } {alle gefundenen;} \
    {Suchbericht; } {Suchliste ; } {anderes} {Status} {Einstellen} {Vorauswahl} \
    {Anzeige} {Auswerten} {Ergebnis auswählen } {für Ergebnisdatei} {Einstellbereich} \
    {einklappen} {dvb-Suchlauf beendet} {Suchlauf beendet} {549} \
    {---ms550} {dvb-Suchlauf beendet.} {Ergebnis abgespeichert.} \
    {Listensuchlauf wird wiederholt.} {Suchlauf gestartet.} \
    {Alte Daten werden gelöscht.} {Manuell/Einzeltransponder: } {x} {x} {x} \
    {Keine gueltige Suchliste!} {Suchliste wird geprüft:} {Suchliste:} \
    {Alte Suchlauf-Daten geloescht.} {x} {Suchlauf mit} {timeout-Störung bei Trp.#} \
    {timeout-Störung, bitte Suchbericht beachten.} \
    {Treibermodul dvb-bt8xx ist blockiert, Details s.Hilfetext.} {x} \
    {Bitte eine Konsole öffnen, eingeben:} {> su (root-Passwort)} \
    { # modprobe -r dvb-bt8xx} { # modprobe dvb-bt8xx} { # exit} \
    {---ms575} {timeout-Störung bei Trp.#} {Treibermodul dvb-bt8xx ist blockiert,} \
    {bitte Suchbericht beachten.} {Dann: Knopf 'Weiter' anklicken.} \
    {Ende der Liste: Suchlauf abgebrochen.} {Suchlauf abgebrochen.} \
    {Suchlauf wird fortgesetzt mit Trp.#} {Bitte ggf. Suchlauf wiederholen, um Trp.#} \
    {abzufragen.} {Sender gefunden;} {neue Sender} {bestätigt,} {entfallen,} \
    {nicht betroffen (andere Transpdr)} {Suchlauf mit } { beendet} \
    {Suchlauf beendet; Ergebnisse werden abspeichert.} {Suchlauf beendet:} {x} {x} \
    {x} {x} {x} {x} \
    {---ms600} {Teclasat: Editor} {Expertenmodus} {Laden} {Editor} {Speichern} \
    {Hilfe} {Suchlauf} {OK} {Ausklappen} {abbrechen} {Hauptliste laden} \
    {Ergebnisdatei} {andere Datei} {Dateiwahl} {Suchlaufergebnis} \
    {Hauptliste einstufen} {neue Sender anfügen} {entfallene Sender löschen} \
    {\[xyz\]-Sender löschen} {Radios markieren} {Im Editor} {neu laden} \
    {Text anfügen} {2-spaltig} \
    {---ms625} {Zeilenmodus} {Ausschneiden} {Kopieren} {Einfügen} {^ auf} {v ab} \
    {Anzeige} {Einstufen} {Filtern} {Sortieren} {Hilfe} {Sendertest} {Speichern als:} \
    {Suchlaufergebnis} {Hilfsdatei} {Dateiwahl} {neu speichern} {anfügen} \
    {Speichern als:} {Einstufen} {Leider noch nicht fertig} {Filtern: Auswahl} \
    {Filtern: löschen} {[xyz]} \
    {---ms650} {Duplikate} {Sender löschen} {entfallene} {nichtbetroffene} \
    {bestätigte} {neue} {Einklappen} {658} {** end **} ]
#
      set mi  0 ; foreach msgt $msgList { incr mi ; set ms$mi $msgt } ;# ms1,ms2,...
    } else {
#*************************************************************************************************
#***************    fmsg exists: read labels from fmsg  *******************************************
      set fid [ open $fmsg r ] ; set msgtext [read $fid] ; close $fid ;# read file
#     process buttext record by record, skip comments, build the labels but1, but2,...
      set mi 0 ; set lf [ format %c [expr 10] ] ; set msglen [ string length $msgtext]
      while { $msglen } {
        set reclen [expr [ string first $lf $msgtext ]]
	set c [ string range $msgtext 0 0]
        if { $c != "#" } {
          incr mi ; set ms$mi [ string range $msgtext 0 [expr $reclen - 1] ]
	} ;# end if not comment
        set msgtext [ string range $msgtext [expr $reclen + 1] end ]
        set msglen [ string length $msgtext ]
##############   end reading fmsg  #######################
      } ;# end while msglen > 0
    } ;# end if default fmsg
#
#  $f1 = standard font for button text
    set f1 {-*-Helvetica-bold-r-normal-*-*-120*-*-*-*-*-iso8859-15}
    set f2 {-*-Helvetica-bold-r-normal-*-*-100*-*-*-*-*-iso8859-15}
    set f3 {-*-Helvetica-bold-i-normal-*-*-120*-*-*-*-*-iso8859-15}
    set f4 {-*-Helvetica-medium-i-normal-*-*-120-*-*-*-*-iso8859-15}
#
#**********    fmsg exists: read labels from fmsg  ************************************************
    welcomewindow $weltime  ;#   open 'Welcome' window if desired
#   player anwaehlen
    set item [lsearch $allPlayers $playertyp ]
    setPlayer $item
#   Welche Videotext-Programme sind vorhanden?
    set allVtext [ list alevt mtt4 mtt ] ; set actVtext ""
    foreach item $allVtext {
      if { ![catch { exec which $item } path] } { lappend actVtext $item
        set isvtext($item) 1  ; set ispath($item) $path
      } else { set isvtext($item) 0 }
    } ;# end foreach item
#
#  Kanal-Datei finden
    if { ![file exists $blist] } then {
#  Sicherstellen, dass chandir existiert:
      set dbli [file dirname $blist] ; set tbli [file tail $blist]
      if { ![file isdirectory $dbli] }  { catch { exec mkdir -p $dbli } }
      if { ![file exists $blist] } { catch { exec cp $dutil1/$tbli $blist } }
      if { ![file exists $blist] } { catch { exec touch $blist }
        tk_messageBox -type ok -icon info  \
       -message "Basisliste \n$blist\n nicht gefunden. \nEingabe-Dialog starten: OK"
        set tan 0 ; set result [linkList]
        if { $result == 0 } { tk_messageBox -type ok -icon info  \
	         -message "Keine Basisliste definiert: \nSuchlauf empfohlen." } }
    } ;# if no blist found
#
#  copy wlist, favo1, favo2 from /usr/share/teclasat, if possible;
#  create directories + create empty files if required
    set dwli [file dirname $wlist]
    if {![file isdirectory $dwli]}    { catch { exec mkdir -p $dwli } }
    if {![file exists $wlist]} { catch { exec cp $dutil1/$tbli $wlist } }
    if {![file exists $wlist]} { catch { exec touch $wlist } }
#  get favo1 if possible
    set dfa1 [file dirname $favo1]
    if {![file isdirectory $dfa1]}  { catch { exec mkdir -p $dfa1 } }
    if {![file exists $favo1]} { catch { exec cp $dutil1/[file tail $favo1] $favo1 } }
    if {![file exists $favo1]} { catch { exec touch $favo1 } }
#  get favo2 if possible
    set dfa2 [file dirname $favo2]
    if {![file isdirectory $dfa2]} { catch { exec mkdir -p $dfa2 } }
    if {![file exists $favo2]} { catch { exec cp $dutil1/[file tail $favo2] $favo2 } }
    if {![file exists $favo2]} { catch { exec touch $favo2 } }
    if {![file exists $ftemp]} { catch { exec touch $ftemp } }
#  Sicherstellen, dass recdir + resdir existieren:
    set drec [file dirname $mrecfil]
    if {![file isdirectory $drec] }  { catch { exec mkdir -p $drec } }
    set dres [file dirname $fscres]
    if {![file isdirectory $dres] }  { catch { exec mkdir -p $dres } }
#
#
#*************************************************************************************************
#  If no valid config-file found: Cold start; define player + channels.conf         ***
#*************************************************************************************************
#
    if {$confVersion != $myVersion} then {
#   Keine gueltige config-Datei:  Default-Player = erster Eintrag in actPlayers
#
      if {[llength $actPlayers] == 0 } {
        set button [tk_messageBox -icon warning -type okcancel \
                                -message "No player found! Continue anyway?"]
        if { $button == "cancel" } { exit } else { set actPlayers [ list xine ] }
      } ;# end if kein Player gefunden; notfalls xine als existent betrachten
      set playertyp [lindex $actPlayers 0] ;# use 1st player as default (usually xine)
      if {![file exists $blist]} then { set tan 0 ; linkList } ;# Senderliste anwaehlen
    } ;# end cold start (if no valid config file - use default values
#                      ***  End  Cold start   ***
#  Configurations-Datei + Titel-Liste fuer favo1 + favo2 ablegen
    set sigtyp [string range $siglist $ad $ad ] ; set zap ${sigtyp}zap
    saveConfig  ; getTitles 2 ; getTitles 3
#
#
#*************************************************************************************************
#############                Define the main window                     ###############
#*************************************************************************************************
#
#   Definition des Hauptfensters
#
    set w .  ;      set wh .doHelp ;  wm iconify  $w
    after $weltime wm deiconify $w    ;# Hauptfenster anschliessend an welcome oeffnen
    wm title    $w "TeclaSat $myVersion0" ; wm iconname $w "TeclaSat"
    wm geometry $w -40-80 ;   wm minsize  $w  20 12 ;   set font {Helvetica 12}
    set main  .main     ; frame $main
    set ctop  $main.top ; frame $ctop ;# frame for table + radio buttons
#
#  main channels table with scrollbars
#
    set tabframe $ctop.tab ; set tab $tabframe.ts.list ;# frame for main channels table
    frame  $tabframe -borderwidth .5c      ;# Tabelle mit Scrollbar
    iwidgets::tabset $tabframe.ts -tabpos n -raiseselect 1 -tabborders yes -backdrop thistle3
    listbox $tab -yscroll "$tabframe.ts.scroll set" -setgrid 1 -height 12  -selectmode single
    scrollbar $tabframe.ts.scroll -command "$tab yview"
    pack $tabframe.ts        -side top   -fill x
    pack $tabframe.ts.scroll -side right -fill y
    pack $tab   -side bottom -expand 1 -fill both
#
#  radio-buttons for list selection
#  upper part: radio buttons
    set xfav1 [file tail $favo1] ; set xfav2 [file tail $favo2]
    if {[string length $xfav1] > 14 } { set xfav1 [string range $xfav1 0 13] }
    if {[string length $xfav2] > 14 } { set xfav2 [string range $xfav2 0 13] }
    set rabut $ctop.rab     ;# frame for radio-buttons for list selection
    labelframe $rabut -text $ms20  -padx 2 -pady 2 ;# Radio-Buttons
    set rab1 $rabut.f1 ; frame $rab1
    radiobutton $rab1.b0 -font $f1 -text $ms149 -width 14\
                  -variable tan -anchor w -relief flat -value 0 -command "newTab"
    radiobutton $rab1.b1 -font $f1 -text $ms147 \
                  -variable tan -anchor w -relief flat -value 1 -command "newTab"
    radiobutton $rab1.b2 -font $f1 -textvariable xfav1  \
                  -variable tan -anchor w -relief flat -value 2 -command "newTab"
    radiobutton $rab1.b3 -font $f1 -textvariable xfav2 \
                  -variable tan -anchor w -relief flat -value 3 -command "newTab"
    radiobutton $rab1.b4 -font $f1 -text $ms28 \
                  -variable tan -anchor w -relief flat -value 4 -command "newTab"
    radiobutton $rab1.b5 -font $f1 -text $ms29 \
                  -variable tan -anchor w -relief flat -value 5 -command "newTab"
    pack $rab1.b0 $rab1.b1 $rab1.b2 -side top -pady 2 -anchor w -fill x
    pack $rab1.b4 -side top -pady 2 -padx 16 -anchor w -fill x ;# titles favo1
    pack $rab1.b3 -side top -pady 2 -anchor w -fill x
    pack $rab1.b5 -side top -pady 2 -padx 16 -anchor w -fill x ;# titles favo2
#  lower part: button for extended wing
    set rab2 $rabut.f2 ; frame $rab2 ; set xbut41 $ms11
    button $rab2.b1  -font $f1 -textvariable xbut41 \
                                           -width 9 -command "onKey 41 11 12 expand compress"
    pack $rab2.b1
    pack $rab1 $rab2 -pady 2
    pack $tabframe $rabut -side left ;# build the uper 'ctop' frame: table + radio buttons
#
#  status message
#
    set xmsg ""
    set smsg $main.smsg ; frame $smsg    ;# labelframe $smsg -text "info!" -padx 2  -pady 2
    label  $smsg.m1 -textvariable xmsg ; pack $smsg.m1
#
#   show channel parameters 'Senderdaten': transponder, pid etc, listfile (name+dir)
#
    set cdat $main.cdat  ; labelframe $cdat -text $ms15  -padx 2  -pady 2
    label $cdat.m1 -textvariable xdat1 ; label $cdat.m2 -textvariable xdat2
    set xdat1 "" ; set xdat2 "" ; pack  $cdat.m1  $cdat.m2 -side top
#
#  Lower frame: buttons for main system control
#
    set cbut   $main.cbut ; frame $cbut   ;# frame for main system buttons
    set cbut1  $cbut.c1 ; labelframe $cbut1 -text $ms23 ;# frame1: viewer control
    set cbut2  $cbut.c2 ; labelframe $cbut2 -text $ms24 ;# frame2: record control
    set cbut3  $cbut.c3 ; labelframe $cbut3 -text $ms71 ;# frame3: systemcontrol
#
    set xbut11 $ms1 ; set xbut21 $ms6 ; set xbut22 $ms4
    if { $isepg } { set xbut12 $ms185 } else { set xbut12 "" }
    if { [llength $actVtext] } { set xbut13 $ms3 } else { set xbut13 "" }
    button $cbut1.b1 -font $f1 -textvariable xbut11 -width 9 \
                               -command "onKey 11 1 2 view-on view-off"
    button $cbut1.b2 -font $f1 -textvariable xbut12 -width 9 \
                               -command "onKey 12 185 186 epg-on epg-off"
    button $cbut1.b3 -font $f1 -textvariable xbut13 -width 9 \
                               -command "onKey 13 3 5 vtext vtext-off"
#
    button $cbut2.b1 -font $f1 -textvariable xbut21 -width 9 \
                               -command "onKey 21 6 9 record-on record-off"
    button $cbut2.b2 -font $f1 -textvariable xbut22 -width 9 \
                               -command "onKey 22 7 8 record-pause record-resume"
    button $cbut2.b3 -font $f1 -text $ms10  -width 9 -command "timerdef"
#
    button $cbut3.b1 -font $f1 -text $ms52  -width 9 -command "doHelp"
    button $cbut3.b2 -font $f1 -text $ms13  -width 9 -command "doConfig"
    button $cbut3.b3 -font $f1 -text $ms14  -width 9 -command "quit"
#
    pack $cbut1.b1 $cbut1.b2 $cbut1.b3
    pack $cbut2.b1 $cbut2.b2 $cbut2.b3
    pack $cbut3.b1 $cbut3.b2 $cbut3.b3
    pack $cbut1 $cbut2 $cbut3 -side left -pady 4 -padx 4
#  pack the main frame:
    pack $cbut -side bottom ; pack $ctop $smsg -side top ;# pack the main modules
    packData; pack $main -padx 4 -side right ;# pack the main frame
#
#*************************************************************************************************
#
#  left wing: modify lists: filter / sort / insert / export / import
#
    set wing   .wing      ; frame $wing  ;#  main frame of extension wing
    set fiso   $wing.fiso ; frame $fiso  ;# left part of wing: filter + sort
    set fil    $fiso.fil  ; labelframe $fil  -text $ms21 ;# frame for filter-buttons
    set sort   $fiso.sort ; labelframe $sort -text $ms22 ;# frame for sort-buttons
#
#  filter buttons
    button $fil.b1  -font $f1 -text $ms149 -width 9 -command "doFilter 0"
    button $fil.b2  -font $f1 -text $ms33  -width 9 -command "doFilter 1"
    button $fil.b3  -font $f1 -text $ms34  -width 9 -command "doFilter 2"
    button $fil.b4  -font $f1 -text $ms35  -width 9 -command "doFilter 3"
    button $fil.b5  -font $f1 -text $ms36  -width 9 -command "doFilter 4"
    button $fil.b6  -font $f1 -text "\[xyz\] $ms44"  -width 9 -command "doFilter 5"
    pack $fil.b1 -side top ; pack $fil.b6 $fil.b5 $fil.b4 $fil.b3 $fil.b2 -side bottom
#
#  sort buttons
    button $sort.b1 -font $f1 -text $ms37  -width 9 -command "doSort  1"
    button $sort.b2 -font $f1 -text $ms38  -width 9 -command "doSort  2"
    button $sort.b3 -font $f1 -text $ms39  -width 9 -command "doSort  3"
    button $sort.b4 -font $f1 -text $ms40  -width 9 -command "manSort 4"
    button $sort.b5 -font $f1 -text $ms41  -width 9 -command "manSort 5"
    pack $sort.b1 $sort.b2 $sort.b3 $sort.b4 $sort.b5 -side top
    pack $fil -side top -pady 4 ; pack $sort -side bottom
#
#  favo buttons: right part of wing
    set fav    $wing.favo ; frame $fav   ;# frame for favo-buttons,fiso, mabu-frame
    set favu   $fav.upper ; set favu1 $favu.right ; set favu2 $favu.left
    set fav1 $favu1.f1  ; set fav2 $favu1.f2 ; set fav3 $favu1.f3
    set fav4 $favu2.f4  ; set fav5 $favu2.f5 ; set fav6 $favu2.f6
    frame $favu ; frame $favu1 ; frame $favu2
    labelframe $fav1 -text $ms18  -padx 2 -pady 2 ;# favo-buttons: edit v^ del
    labelframe $fav2 -text $ms45  -padx 2 -pady 2 ;# favo-buttons: ins -> favo list
    labelframe $fav3 -text $ms47  -padx 2 -pady 2 ;# favo-buttons: ins title
    labelframe $fav4 -text $ms19  -padx 2 -pady 2 ;# favo-buttons: export/import/edit
    labelframe $fav5 -text $ms153 -padx 2 -pady 2 ;# favo-buttons:
    labelframe $fav6 -text $ms71  -padx 2 -pady 2 ;# favo-buttons:
#
#  favo-buttons, upper part: edit the favo-lists
    button $fav1.b1 -font $f1 -text $ms42  -width 9 -command "move-up"
    button $fav1.b2 -font $f1 -text $ms43  -width 9 -command "move-down"
    button $fav1.b3 -font $f1 -text $ms44  -width 9 -command "delChan"
    button $fav1.b4 -font $f1 -text $ms26  -width 9 -command "cutChan"
    button $fav1.b5 -font $f1 -text $ms27  -width 9 -command "insFav 0 $ftemp"
#  favo buttons: -> favo list
    button $fav2.b4 -font $f1 -textvariable xfav1 -width 9 -command "insFav 2 $favo1"
    button $fav2.b5 -font $f1 -textvariable xfav2 -width 9 -command "insFav 3 $favo2"

#  favo buttons: insert title
    button $fav3.b6 -font $f1 -text $ms46  -width 9 -command "insTitle"
#
#  favo-buttons: link, load, store
    button $fav4.b1 -font $f1 -text $ms49  -width 9 -command "linkList"
    button $fav4.b2 -font $f1 -text $ms313 -width 9 -command "copyList"
    button $fav4.b3 -font $f1 -text $ms48  -width 9 -command "storeList"
# 'Ablage'
    button $fav5.b7 -font $f1 -text $ms46  -width 9 -command "insTemp"
    button $fav5.b8 -font $f1 -text $ms44  -width 9 -command "delTemp"
    button $fav6.b4 -font $f1 -text $ms604 -width 9 -command "doEdit"
    button $fav6.b5 -font $f1 -text $ms54  -width 9 -command "configScan"
#
    pack $fav1.b1 $fav1.b2 $fav1.b3 $fav1.b4 $fav1.b5 -side top
    pack $fav2.b5 $fav2.b4 -side top
    pack $fav3.b6 -side top
    pack $fav4.b1 $fav4.b2 $fav4.b3 -side top
    pack $fav5.b7 $fav5.b8 -side top ; pack $fav6.b4 $fav6.b5 -side top
    pack $fav1 -side top -pady 2 -padx 2
    pack $fav2 -side bottom -pady 2 -padx 2 ; pack $fav3 -side bottom -pady 6 -padx 2
    pack $fav5 -side top    -pady 2 -padx 2 ; pack $fav4 -side top    -pady 6 -padx 2
    pack $fav6 -side bottom -pady 6 -padx 2
    pack $favu1 $favu2 -side right -anchor n -padx 2 -expand 1 -fill y
#
#  special buttons for scratchpad ('Ablage'): alternative 'wing6' for tan=6
    set wing6 .wing6 ; frame $wing6
    set fav7 $wing6.f7 ; labelframe $fav7 -text $ms18
    button $fav7.b1 -font $f1 -text $ms42  -width 9 -command "move-up"
    button $fav7.b2 -font $f1 -text $ms43  -width 9 -command "move-down"
    button $fav7.b3 -font $f1 -text $ms44  -width 9 -command "delChan"
    pack $fav7.b1 $fav7.b2 $fav7.b3 -side top
#  favo-buttons: link, load, store
    set fav8  $wing6.f8 ; labelframe $fav8 -text $ms153
    button $fav8.b1 -font $f1 -text $ms49  -width 9 -command "linkList"
    button $fav8.b2 -font $f1 -text $ms313 -width 9 -command "copyList"
    button $fav8.b3 -font $f1 -text $ms48  -width 9 -command "storeList"
    pack $fav8.b1 $fav8.b2 $fav8.b3 -side top
    pack $fav7 $fav8 -side top -pady 6 -padx 6
#
#   Check-Buttons: display mode; show channel data + mark radios/hotbird
#
    set mabu  $fav.mabu ; set mabu1 $mabu.f1 ; set mabu2 $mabu.f2
    labelframe  $mabu  -text $ms181 ; frame $mabu1 ; frame $mabu2
    checkbutton $mabu1.b1 -text $ms182 \
                -variable showflag -anchor w -relief flat -command packMain
    radiobutton $mabu1.b2 -font $f1 -text $ms153 \
                  -variable tan -anchor w -relief flat -value 6 -command "newTab"
    checkbutton $mabu2.b3 -text $ms30 \
                -variable mara -anchor w -relief flat -command doMark
    checkbutton $mabu2.b4 -text "hotbird" \
                -variable mahot -anchor w -relief flat -command doMark
    pack $mabu1.b1 $mabu1.b2 -side top -anchor w ; pack $mabu2.b3 $mabu2.b4 -side top -anchor w
    pack $mabu1 -side left ; pack $mabu2 -side left -expand 1 -fill x
    pack $favu -side top ; pack $mabu -side bottom -anchor s -expand 1 -fill x
    pack $fav  -side right -pady 4
#  note: $fiso (the filter/sort part) is not yet packed.
#
#  Gesamtbild einfaerben
#
    setColor $w -background $bgcolor
    setColor $w -foreground $fgcolor
    setColor $w -activebackground $actcolor
#
#  init variables
    set tstat1 "Suchlauf inaktiv" ; set tstat2 "" ; set tstat3 "" ; set tstat4 ""
    set tstat5 "" ; set tstam ""
    set twsbut0 $ms422 ;  set xtsr "[file tail $fscres]"
#
#   Tasten definieren
#
    bind . <KeyPress-Down>         { sel-down   }
    bind . <Control-KeyPress-Down> { view-next  }
    bind . <KeyPress-Next>         { view-next  }
    bind . <KeyPress-Up>           { sel-up     }
    bind . <Control-KeyPress-Up>   { view-prev  }
    bind . <KeyPress-Prior>        { view-prev  }
    bind . <KeyPress-Left>         { prev-title }
    bind . <KeyPress-Right>        { next-title }
    bind . <KeyPress-Home>         { view-home  }
    bind . <KeyPress-End>          { view-last  }
    bind . <KeyPress-Begin>        {   }
    bind . <Control-KeyPress-Home> { setHomeChannel }
    bind . <Control-KeyPress-h>    { setHomeChannel }
    bind $tab <Double-Button-1> { view-on }
    bind $tab <ButtonRelease-1> { doSelection }
#    bind . <Control-KeyPress-v> { view-on }
    bind . <Control-KeyPress-f> { insFav $favo1  }
    bind . <Control-KeyPress-r> { insFav $favo2 }
    bind . <Control-KeyPress-u> { move-up   }
    bind . <Control-KeyPress-d> { move-down }
    bind . <Control-KeyPress-s> { view-off  }
    bind . <Control-KeyPress-q> { quit }
    bind . <Control-KeyPress-l> { showLog $home }
#    grab set -global $w
    focus $w ;  initScanParms ; saveConfig ; newTab   ;# Liste anzeigen
########################### ---  Programm Ende  --- ##################################
