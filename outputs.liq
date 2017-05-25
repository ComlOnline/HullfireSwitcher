#outputs

#main outs
out_mp3 = output.icecast(%mp3(bitrate=128), 
    password=passpublic, 
    host="hullfire-radio.hull.ac.uk",
	port=8000,
    genre="Student",
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    name="Hullfire Radio")

out_aacp64 = output.icecast(%fdkaac
    (channels=2, 
    bitrate=64),
    host="hullfire-radio.hull.ac.uk",
	port=8000,
    password=passpublic,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	
out_aacp128 = output.icecast(%aac+,
    (channels=2, 
    bitrate=128),
    host="hullfire-radio.hull.ac.uk",
	port=8000,
    password=passpublic,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	
out_aacp256 = output.icecast(%aac+,
    (channels=2, 
    bitrate=256),
    host="hullfire-radio.hull.ac.uk",
	port=8000,
    password=passpublic,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	
	
	
#exta output to centice
out_aux = output.icecast(%aac+,
    (channels=2, 
    bitrate=256),
    host="hfr-vh1-centice.hull.ac.uk",
	port=8000,
    password=passcent,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	
	
#output for union via centice
out_union = output.icecast(%aac+,
    (channels=2, 
    bitrate=256),
    host="hfr-vh1-centice.hull.ac.uk",
	port=8000,
    password=passcent,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	
#output for autodj to centice
out_autodj = output.icecast(%aac+,
    (channels=2, 
    bitrate=256),
    host="hfr-vh1-centice.hull.ac.uk",
	port=8000,
    password=passcent,
    url="radio.hullfire.com",
    description="Hullfire Raido, Hull univercity student media",
    genre="Student",
    name="Hullfire Radio")
	