set("log.file.path","/tmp/Switcher.log")
set("server.telnet",true)
set("server.telnet.port", 1234)
set("harbor.bind_addr","0.0.0.0")
set("harbor.verbose", true)
set("root.max_latency",60.)
set("server.telnet.bind_addr","0.0.0.0")
set("log.level",3)
set("log.stdout",false)

%include "outputs.liq"
#%include "passwords.liq"
#In the command %include "file" the path is relative to the script file. In %include <file>, it is relative to the library directory of liquidsoap.


unionautodj = interactive.bool("unionautodj", false)
swextob = interactive.bool("swextob", false)
swstudio1 = interactive.bool("swstudio1", true)
swstudio = interactive.bool("swstudio", false)
swob = interactive.bool("swob", false)

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

autodj = input.harbor("autodj",port=8000,password=harbor)

studio1 = input.harbor("studio1",port=8000,password=harbor)

studio2 = input.harbor("studio2",port=8000,password=harbor)

extoburl = "http://hullfire-radio.hull.ac.uk:8000/HullfireRadio.mp3"
extob = mksafe(input.http(extoburl))

intob = input.harbor("internal",port=8000,password=harbor)

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


ob = switch(track_sensitive=false, [(swextob,extob), ({true},intob)])
studio = switch(track_sensitive=false, [(swstudio1,studio1), ({true},studio2)])
master = switch(track_sensitive=false, [(swob,ob), (swstudio,studio), ({true},autodj)])
#master = mix([ob, studio, autodj])

radio = fallback(
		id="http_input fallback",
		track_sensitive=false,
		transitions=[ next(jingle),next(jingle) ],
		[
			master,
			localtracks,
			outage
		]
)

#Radio Processing
radio = mksafe(radio)
radio = normalize(radio)
#radio = audio_process(radio)

#vu = visu.volume(radio)
#print(vu)


#Switch for union auto DJ over ride
union = switch(track_sensitive=false, [(unionautodj,autodj), ({true},radio)])

out_aacp_low(,mount="Test.aacp",radio)


out_aux(mount="aux",radio)
out_union(mount="union",union)