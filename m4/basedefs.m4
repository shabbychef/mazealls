define(`m4_CHOMP',`substr($1,0,eval(len($1)-1))')dnl
define(`m4_CHOMP_SYS',`m4_CHOMP(`esyscmd($1)')')dnl
dnl holy fuck. http://mbreen.com/m4.html#quotemacro 
define(`LQ',`changequote(<,>)`dnl'
changequote`'')
define(`RQ',`changequote(<,>)dnl`
'changequote`'')
define(`m4_R_FILES',`m4_CHOMP_SYS(`ls  R/*.r | sort | perl -pe "s{^R/}{    `'RQ()};s{$}{`'RQ()};";')')dnl
dnl vim modelines;
dnl vim:ts=2:sw=2:syn=m4:ft=m4:si:cin:nu
