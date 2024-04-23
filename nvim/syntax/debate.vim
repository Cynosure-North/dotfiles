syntax region debate_preamble start="\%^" end="\ze;;"
" Aff
syntax region debate_1a matchgroup=nil start=";;1a" end="\ze;;" concealends
syntax region debate_2a matchgroup=nil start=";;2a" end="\ze;;" concealends
syntax region debate_3a matchgroup=nil start=";;3a" end="\ze;;" concealends
" Neg
syntax region debate_1n matchgroup=nil start=";;1n" end="\ze;;" concealends
syntax region debate_2n matchgroup=nil start=";;2n" end="\ze;;" concealends
syntax region debate_3n matchgroup=nil start=";;3n" end="\ze;;" concealends
" BP
syntax region debate_PM matchgroup=nil start=";;PM" end="\ze;;" concealends
syntax region debate_DPM matchgroup=nil start=";;DPM" end="\ze;;" concealends
syntax region debate_LO matchgroup=nil start=";;LO" end="\ze;;" concealends
syntax region debate_DLO matchgroup=nil start=";;DLO" end="\ze;;" concealends
syntax region debate_MP matchgroup=nil start=";;MP" end="\ze;;" concealends
syntax region debate_GW matchgroup=nil start=";;GW" end="\ze;;" concealends
syntax region debate_MO matchgroup=nil start=";;MO" end="\ze;;" concealends
syntax region debate_OW matchgroup=nil start=";;OW" end="\ze;;" concealends
" Adj
syntax region debate_F matchgroup=nil start=";;F" end="\ze;;" concealends
syntax region debate_R matchgroup=nil start=";;R" end="\ze;;" concealends
	" Single semicolon so it doesn't end a region
syntax match debate_score ";\d\d\(\.5\)\?" containedin=ALL
syntax region debate_F_line matchgroup=nil start=";F" end="$" end="\ze;" concealends excludenl containedin=ALL
syntax region debate_R_line matchgroup=nil start=";R" end="$" end="\ze;" concealends excludenl containedin=ALL



highlight debate_preamble guifg=#bebebe
highlight debate_speaker_boundary guifg=#777777 gui=bold
" Aff
highlight debate_1a guifg=#2222a5 gui=bold
highlight debate_2a guifg=#6495ed gui=bold
highlight debate_3a guifg=#87cefa gui=bold
" Neg
highlight debate_1n guifg=#b22222 gui=bold
highlight debate_2n guifg=#dc143c gui=bold
highlight debate_3n guifg=#f08080 gui=bold
" Adj
highlight debate_score guifg=#dedede
	" Feedback
highlight debate_F guifg=#777777
highlight link debate_F_line debate_F
	" Reckons
highlight debate_R guifg=#b9b9b9
highlight link debate_R_line debate_R
" BP
highlight link debate_PM debate_1a
highlight link debate_DPM debate_2a
highlight link debate_LO debate_1n
highlight link debate_DLO debate_2n
highlight debate_MP guifg=#008000 gui=bold
highlight debate_GW guifg=#00ff7f gui=bold
highlight debate_MO guifg=#9932cc gui=bold
highlight debate_OW guifg=#da70d6 gui=bold
" Misc
highlight Beacon guibg=white blend=25
