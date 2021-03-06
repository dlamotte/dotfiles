" NOTE: You must, of course, install pt / the_platinum_searcher
command! -nargs=* -complete=file Pt call pt#Pt('grep!',<q-args>)
command! -nargs=* -complete=file PtBuffer call pt#PtBuffer('grep!',<q-args>)
command! -nargs=* -complete=file PtAdd call pt#Pt('grepadd!', <q-args>)
command! -nargs=* -complete=file PtFromSearch call pt#PtFromSearch('grep!', <q-args>)
command! -nargs=* -complete=file LPt call pt#Pt('lgrep!', <q-args>)
command! -nargs=* -complete=file LPtBuffer call pt#PtBuffer('lgrep!',<q-args>)
command! -nargs=* -complete=file LPtAdd call pt#Pt('lgrepadd!', <q-args>)
command! -nargs=* -complete=file PtFile call pt#Pt('grep! -g', <q-args>)
command! -nargs=* -complete=help PtHelp call pt#PtHelp('grep!',<q-args>)
command! -nargs=* -complete=help LPtHelp call pt#PtHelp('lgrep!',<q-args>)

cabbrev pt Pt
cabbrev ptadd PtAdd
cabbrev ptsearch PtFromSearch
cabbrev lpt LPt
cabbrev lptadd LPtAdd
