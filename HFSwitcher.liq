set("log.file.path","/tmp/HFRSwitcher.log")
set("server.telnet",true)
set("server.telnet.port", 1234)
set("harbor.bind_addr","0.0.0.0")
set("harbor.verbose", true)
set("root.max_latency",60.)
set("server.telnet.bind_addr","0.0.0.0")
set("log.level",3)
set("log.stdout",true)


%include "../HullfireSwitcher/passwords.liq"
%include "../HullfireSwitcher/outputs.liq"
#In the command %include "file" the path is relative to the script file. In %include <file>, it is relative to the library directory of liquidsoap.

#interactive variables for control
unionautodj = interactive.bool("unionautodj", false)
swstudio1 = interactive.bool("swstudio1", false)


songs = playlist("/hullfire/songs/")
jingle = playlist(mode='random',"/hullfire/jingles/")


localtracks = random(weights=[1,5],[ jingle, songs ])


#Transition code
def next(j,a,b)
	add(
		[sequence(merge=true,[fade.final(duration=3.,a)]),
		sequence(
                 [ j,fallback([]) ]
				),
		sequence(
                 [ blank(duration=4.),
                   fade.initial(duration=5.,b) ]
				),
		]
	)    
end

def crossfade(a,b)
  add(normalize=false,
      [ sequence([ blank(duration=5.),
                   fade.initial(duration=10.,b) ]),
        fade.final(duration=10.,a) ])
end

#Input harbors!

autodj = input.harbor(id="autodj","autodj",port=8000,password=passharbor)
studio1 = input.harbor(id="studio1","studio1",port=8000,password=passharbor)
studio2 = input.harbor(id="studio2","studio2",port=8000,password=passharbor)
oburl = "http://hullfire-radio.hull.ac.uk:8000/HullfireRadio.mp3"
ob = mksafe(input.http(id="ob",buffer=15.,max=20.,oburl))


#Noise for worst case
outage = mksafe(amplify(0.05, noise(id="outage")))
outage = audio_to_stereo(outage)

#announce   = mksafe(single(id="error_announcer", "say:hullfire radio is experiancing technical problems, we will be back as soon as posilbe"))
#announce   = audio_to_stereo(announce)

#net_outage = smooth_add(
#	normal=outage,
#	special=switch([
#		( { 0s }, announce )
#	])
#)


master = mix(id="Master",[studio1, studio2, ob, autodj])

radio = fallback(
		id="http_input fallback",
		track_sensitive=false,
		transitions=[ next(jingle),next(jingle) ],
		[
			master,
			autodj,
			localtracks,
			outage
		]
)





#vu = visu.volume(radio)
#print(vu)

output.dummy(fallible=true, ob)
#Switch for union auto DJ over ride
autodj = mksafe(autodj)

#radio = switch(track_sensitive=false, [(swstudio1,studio1), ({true},autodj)])
#union = switch(track_sensitive=false, [(unionautodj,autodj), ({true},radio)])

radio = switch(track_sensitive=false,
			transitions=[ crossfade ],
			[(swstudio1,studio1), ({true},autodj)])
			
union = switch(track_sensitive=false,
			transitions=[ crossfade ],
			[(unionautodj,autodj), ({true},radio)])

#Radio Processing
radio = mksafe(radio)
radio = normalize(radio)
#radio = audio_process(radio)

union = mksafe(union)
union = normalize(union)

autodj = mksafe(autodj)
autodj = normalize(autodj)


out_mp3(mount="HullfireRadio2.mp3",radio)
out_aacp64(mount="HullfireRadio_64.aacp",radio)
out_aacp128(mount="HullfireRadio_128.aacp",radio)
out_aacp256(mount="HullfireRadio_256.aacp",radio)


out_aux(mount="aux",radio)
out_union(mount="union",union)
out_autodj(mount="autodj",autodj)